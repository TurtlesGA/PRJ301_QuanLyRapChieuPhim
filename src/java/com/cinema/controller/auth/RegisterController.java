package com.cinema.controller.auth;

import com.cinema.dao.UserDAO;
import com.cinema.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Validate
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkUsernameExists(username.trim())) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại trên hệ thống!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkEmailExists(email.trim())) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setPhone(phone != null ? phone.trim() : "");

        boolean success = userDAO.register(newUser);
        if (success) {
            request.setAttribute("successMsg", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký, vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}

