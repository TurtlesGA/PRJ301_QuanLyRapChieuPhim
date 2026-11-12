package com.cinema.filter;

import com.cinema.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/my-bookings", "/checkout", "/payment", "/payment-confirm", "/profile"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        String uri = httpRequest.getRequestURI();

        // 1. Kiểm tra chưa đăng nhập
        if (currentUser == null) {
            session = httpRequest.getSession(true);
            session.setAttribute("authMsg", "Vui lòng đăng nhập để tiếp tục!");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // 2. Kiểm tra truy cập trang Admin
        if (uri.contains("/admin/")) {
            // Chỉ ADMIN hoặc STAFF mới được vào khu vực quản trị
            if (!currentUser.isAdmin() && !currentUser.isStaff()) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang Quản trị!");
                return;
            }

            // Phân quyền cho role STAFF: chỉ được quản lý Suất chiếu, Phòng chiếu, Lịch sử đặt vé & xem Dashboard
            if (currentUser.isStaff() && !currentUser.isAdmin()) {
                boolean isAllowedForStaff = uri.contains("/admin/showtime")
                                         || uri.contains("/admin/room")
                                         || uri.contains("/admin/booking")
                                         || uri.contains("/admin/dashboard")
                                         || uri.endsWith("/admin")
                                         || uri.endsWith("/admin/");
                if (!isAllowedForStaff) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Nhân viên (STAFF) chỉ có quyền quản lý Suất chiếu, Phòng chiếu và Lịch sử đặt vé!");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

