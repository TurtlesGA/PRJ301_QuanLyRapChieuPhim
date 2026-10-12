package com.cinema.filter;

import com.cinema.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/my-bookings", "/checkout", "/profile"})
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
            if (!currentUser.isAdmin()) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang Quản trị!");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
