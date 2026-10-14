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

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if ("reset".equals(action)) {
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetEmail");
        }

        String resetEmail = (String) session.getAttribute("resetEmail");
        if (resetEmail != null) {
            request.setAttribute("step", "2");
        } else {
            request.setAttribute("step", "1");
        }
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String step = request.getParameter("step");

        if ("1".equals(step)) {
            handleRequestOtp(request, response, session);
        } else if ("2".equals(step)) {
            handleResetPassword(request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    private void handleRequestOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("step", "1");
            request.setAttribute("error", "Vui lòng nhập địa chỉ email!");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByEmail(email.trim());
        if (user == null) {
            request.setAttribute("step", "1");
            request.setAttribute("error", "Email này chưa được đăng ký trong hệ thống!");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }

        String otp = "123456";

        session.setAttribute("resetEmail", user.getEmail());
        session.setAttribute("resetOtp", otp);

        request.setAttribute("step", "2");
        request.setAttribute("otpNotice", "Mã xác thực OTP của bạn là: " + otp + " (Mã có hiệu lực để đổi mật khẩu)");
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String resetEmail = (String) session.getAttribute("resetEmail");
        String sessionOtp = (String) session.getAttribute("resetOtp");

        if (resetEmail == null || sessionOtp == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String otpInput = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (otpInput == null || !otpInput.trim().equals(sessionOtp)) {
            request.setAttribute("step", "2");
            request.setAttribute("error", "Mã xác thực OTP không chính xác!");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("step", "2");
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("step", "2");
            request.setAttribute("error", "Xác nhận mật khẩu mới không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }

        boolean ok = userDAO.resetPasswordByEmail(resetEmail, newPassword);
        if (ok) {
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetEmail");
            session.setAttribute("successMsg", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("step", "2");
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật mật khẩu! Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
        }
    }
}
