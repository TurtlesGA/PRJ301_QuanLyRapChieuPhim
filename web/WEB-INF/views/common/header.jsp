<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${not empty currentLang ? currentLang : 'vi'}" <c:if test="${not empty currentLang and currentLang != 'vi'}">data-i18n-loading="true"</c:if>>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${requestScope.pageTitle != null ? requestScope.pageTitle : (param.title != null ? param.title : (not empty siteSettings.site_title ? siteSettings.site_title : "CineStar - Đặt Vé Xem Phim Trực Tuyến"))}</title>
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${not empty siteSettings.site_favicon ? siteSettings.site_favicon : pageContext.request.contextPath.concat('/assets/images/favicon.ico')}">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.3">
    <!-- Anti-FOUT: Prevent Flash of Untranslated Vietnamese when language is not 'vi' -->
    <style id="anti-fout-style">
        html[data-i18n-loading="true"] [data-i18n],
        html[data-i18n-loading="true"] [data-i18n-html],
        html[data-i18n-loading="true"] [data-i18n-placeholder],
        html[data-i18n-loading="true"] .movie-title,
        html[data-i18n-loading="true"] .movie-genre,
        html[data-i18n-loading="true"] .movie-description,
        html[data-i18n-loading="true"] .movie-director,
        html[data-i18n-loading="true"] .movie-cast,
        html[data-i18n-loading="true"] .room-name,
        html[data-i18n-loading="true"] .badge-status {
            visibility: hidden !important;
        }
    </style>
    <!-- Load Context Path, Theme & Language Mode Early in Head -->
    <script>
        window.CONTEXT_PATH = '${pageContext.request.contextPath}';
        (function() {
            var theme = localStorage.getItem('cinema_theme') || 'dark';
            document.documentElement.setAttribute('data-bs-theme', theme);
            var lang = localStorage.getItem('cinema_lang') || '${not empty currentLang ? currentLang : "vi"}';
            document.documentElement.setAttribute('lang', lang);
            if (lang !== 'vi') {
                document.documentElement.setAttribute('data-i18n-loading', 'true');
                setTimeout(function() {
                    document.documentElement.removeAttribute('data-i18n-loading');
                }, 400);
            }
        })();
    </script>
    <!-- Load i18n Translation Engine Early in Head -->
    <script src="${pageContext.request.contextPath}/assets/js/i18n.js?v=3.0" charset="UTF-8"></script>
    <!-- Custom Head Script (From System Settings) -->
    <c:if test="${not empty siteSettings.script_head}">
        ${siteSettings.script_head}
    </c:if>
</head>
<body>
<!-- Custom Body Script (From System Settings) -->
<c:if test="${not empty siteSettings.script_body}">
    ${siteSettings.script_body}
</c:if>
