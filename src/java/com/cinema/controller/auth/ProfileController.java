package com.cinema.controller.auth;

import com.cinema.dao.UserDAO;
import com.cinema.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin mới nhất từ DB
        User refreshedUser = userDAO.getUserById(currentUser.getUserId());
        session.setAttribute("currentUser", refreshedUser);

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateInfo".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);

            boolean success = userDAO.updateProfile(currentUser);
            if (success) {
                session.setAttribute("currentUser", currentUser);
                request.setAttribute("successMsg", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thông tin thất bại!");
            }
        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");

            if (!currentUser.getPassword().equals(oldPassword)) {
                request.setAttribute("pwError", "Mật khẩu hiện tại không đúng!");
            } else if (!newPassword.equals(confirmNewPassword)) {
                request.setAttribute("pwError", "Mật khẩu mới xác nhận không khớp!");
            } else {
                boolean success = userDAO.changePassword(currentUser.getUserId(), newPassword);
                if (success) {
                    currentUser.setPassword(newPassword);
                    session.setAttribute("currentUser", currentUser);
                    request.setAttribute("pwSuccess", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("pwError", "Đổi mật khẩu thất bại!");
                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
}

