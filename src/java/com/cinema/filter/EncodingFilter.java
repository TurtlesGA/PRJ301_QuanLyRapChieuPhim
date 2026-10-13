package com.cinema.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(filterName = "EncodingFilter", urlPatterns = {"/*"})
public class EncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String enc = filterConfig.getInitParameter("encoding");
        if (enc != null) {
            encoding = enc;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        httpRequest.setCharacterEncoding(encoding);
        httpResponse.setCharacterEncoding(encoding);
        String path = httpRequest.getRequestURI();
        if (path.endsWith(".js")) {
            httpResponse.setContentType("application/javascript; charset=UTF-8");
        } else if (path.endsWith(".css")) {
            httpResponse.setContentType("text/css; charset=UTF-8");
        } else if (!path.endsWith(".png") && !path.endsWith(".jpg") && !path.endsWith(".jpeg") && !path.endsWith(".gif") && !path.endsWith(".ico") && !path.endsWith(".svg")) {
            httpResponse.setContentType("text/html; charset=UTF-8");
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

