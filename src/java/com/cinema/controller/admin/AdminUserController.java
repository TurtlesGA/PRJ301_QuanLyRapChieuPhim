package com.cinema.controller.admin;

import com.cinema.dao.UserDAO;
import com.cinema.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users", "/admin/user-toggle", "/admin/user-add"})
public class AdminUserController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/users".equals(servletPath)) {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
        } else if ("/admin/user-add".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
        } else if ("/admin/user-toggle".equals(servletPath)) {
            try {
                int userId = Integer.parseInt(request.getParameter("id"));
                User user = userDAO.getUserById(userId);
                if (user != null && !"ADMIN".equalsIgnoreCase(user.getRole())) {
                    userDAO.toggleUserStatus(userId, user.isStatus());
                }
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/user-add".equals(servletPath) || "/admin/users".equals(servletPath)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String statusStr = request.getParameter("status");
            boolean status = "1".equals(statusStr) || "true".equalsIgnoreCase(statusStr);

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
                request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                return;
            }

            username = username.trim();
            email = email.trim();

            if (userDAO.checkUsernameExists(username)) {
                request.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại!");
                request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                return;
            }

            if (userDAO.checkEmailExists(email)) {
                request.setAttribute("error", "Email '" + email + "' đã tồn tại!");
                request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                return;
            }

            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(password);
            newUser.setFullName(fullName.trim());
            newUser.setEmail(email);
            newUser.setPhone(phone != null ? phone.trim() : "");
            newUser.setRole(role != null && !role.isEmpty() ? role : "CUSTOMER");
            newUser.setStatus(status);

            boolean success = userDAO.insertUser(newUser);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?msg=add_success");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm người dùng!");
                request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
            }
        }
    }
}

