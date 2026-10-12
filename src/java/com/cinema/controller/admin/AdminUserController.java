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

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users", "/admin/user-toggle"})
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
}

