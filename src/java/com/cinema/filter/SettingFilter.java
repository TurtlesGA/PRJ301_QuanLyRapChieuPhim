package com.cinema.filter;

import com.cinema.dao.LanguageDAO;
import com.cinema.dao.SettingDAO;
import com.cinema.model.Language;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebFilter(filterName = "SettingFilter", urlPatterns = {"/*"})
public class SettingFilter implements Filter {

    private SettingDAO settingDAO;
    private LanguageDAO languageDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.settingDAO = new SettingDAO();
        this.languageDAO = new LanguageDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest req = (HttpServletRequest) request;
            ServletContext context = req.getServletContext();

            // Cache settings in applicationScope, load if null
            @SuppressWarnings("unchecked")
            Map<String, String> siteSettings = (Map<String, String>) context.getAttribute("siteSettings");
            if (siteSettings == null) {
                siteSettings = settingDAO.getAllSettings();
                context.setAttribute("siteSettings", siteSettings);
            }
            req.setAttribute("siteSettings", siteSettings);

            // Cache active languages in applicationScope
            @SuppressWarnings("unchecked")
            List<Language> activeLanguages = (List<Language>) context.getAttribute("activeLanguages");
            if (activeLanguages == null) {
                activeLanguages = languageDAO.getAllActiveLanguages();
                context.setAttribute("activeLanguages", activeLanguages);
            }
            req.setAttribute("activeLanguages", activeLanguages);

            // Determine current user language preference from parameter, session, or cookie
            String currentLang = req.getParameter("lang");
            if (currentLang != null && !currentLang.trim().isEmpty()) {
                currentLang = currentLang.trim().toLowerCase();
                req.getSession().setAttribute("cinema_lang", currentLang);
                if (response instanceof jakarta.servlet.http.HttpServletResponse) {
                    jakarta.servlet.http.Cookie c = new jakarta.servlet.http.Cookie("cinema_lang", currentLang);
                    c.setPath("/");
                    c.setMaxAge(31536000);
                    ((jakarta.servlet.http.HttpServletResponse) response).addCookie(c);
                }
            } else {
                currentLang = (String) req.getSession().getAttribute("cinema_lang");
                if (currentLang == null || currentLang.trim().isEmpty()) {
                    jakarta.servlet.http.Cookie[] cookies = req.getCookies();
                    if (cookies != null) {
                        for (jakarta.servlet.http.Cookie c : cookies) {
                            if ("cinema_lang".equals(c.getName()) && c.getValue() != null && !c.getValue().trim().isEmpty()) {
                                currentLang = c.getValue().trim().toLowerCase();
                                break;
                            }
                        }
                    }
                }
            }
            if (currentLang == null || currentLang.trim().isEmpty()) {
                currentLang = "vi";
            }
            req.setAttribute("currentLang", currentLang);
            req.getSession().setAttribute("cinema_lang", currentLang);
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
