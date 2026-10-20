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
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
