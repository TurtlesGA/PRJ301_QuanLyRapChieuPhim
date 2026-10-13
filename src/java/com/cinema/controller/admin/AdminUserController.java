package com.cinema.controller.admin;

import com.cinema.dao.UserDAO;
import com.cinema.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users", "/admin/user-toggle", "/admin/user-add", "/admin/user-edit", "/admin/user-delete"})
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
        } else if ("/admin/user-edit".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                User user = userDAO.getUserById(id);
                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
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
        } else if ("/admin/user-delete".equals(servletPath)) {
            try {
                int userId = Integer.parseInt(request.getParameter("id"));
                HttpSession session = request.getSession(false);
                User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
                if (currentUser != null && currentUser.getUserId() == userId) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=self_delete");
                    return;
                }
                boolean success = userDAO.deleteUser(userId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?msg=delete_success");
                    return;
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

        if ("/admin/user-add".equals(servletPath) || "/admin/user-edit".equals(servletPath) || "/admin/users".equals(servletPath)) {
            String userIdStr = request.getParameter("userId");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String statusStr = request.getParameter("status");
            boolean status = "1".equals(statusStr) || "true".equalsIgnoreCase(statusStr);

            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                try {
                    int userId = Integer.parseInt(userIdStr.trim());
                    User existingUser = userDAO.getUserById(userId);
                    if (existingUser == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                        return;
                    }

                    if (username == null || username.trim().isEmpty() ||
                        fullName == null || fullName.trim().isEmpty() ||
                        email == null || email.trim().isEmpty()) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
                        request.setAttribute("user", existingUser);
                        request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                        return;
                    }

                    username = username.trim();
                    email = email.trim();

                    if (userDAO.checkUsernameExistsForOther(username, userId)) {
                        request.setAttribute("error", "Tên đăng nhập '" + username + "' đã được sử dụng bởi người dùng khác!");
                        request.setAttribute("user", existingUser);
                        request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                        return;
                    }

                    if (userDAO.checkEmailExistsForOther(email, userId)) {
                        request.setAttribute("error", "Email '" + email + "' đã được sử dụng bởi người dùng khác!");
                        request.setAttribute("user", existingUser);
                        request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                        return;
                    }

                    existingUser.setUsername(username);
                    if (password != null && !password.trim().isEmpty()) {
                        existingUser.setPassword(password.trim());
                    }
                    existingUser.setFullName(fullName.trim());
                    existingUser.setEmail(email);
                    existingUser.setPhone(phone != null ? phone.trim() : "");
                    existingUser.setRole(role != null && !role.isEmpty() ? role : "CUSTOMER");
                    existingUser.setStatus(status);

                    boolean success = userDAO.updateUser(existingUser);
                    if (success) {
                        HttpSession session = request.getSession(false);
                        if (session != null) {
                            User currentUser = (User) session.getAttribute("currentUser");
                            if (currentUser != null && currentUser.getUserId() == userId) {
                                session.setAttribute("currentUser", existingUser);
                            }
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/users?msg=update_success");
                    } else {
                        request.setAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin người dùng!");
                        request.setAttribute("user", existingUser);
                        request.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                }
                return;
            }

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

