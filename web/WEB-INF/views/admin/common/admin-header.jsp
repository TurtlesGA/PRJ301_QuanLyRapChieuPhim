<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title != null ? param.title : (requestScope.pageTitle != null ? requestScope.pageTitle : (not empty siteSettings.site_title ? siteSettings.site_title : "CineStar Admin Portal"))}</title>
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${not empty siteSettings.site_favicon ? siteSettings.site_favicon : pageContext.request.contextPath.concat('/assets/images/favicon.ico')}">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.2">
    <!-- Load Theme Mode Before Render -->
    <script>
        (function() {
            var theme = localStorage.getItem('cinema_theme') || 'dark';
            document.documentElement.setAttribute('data-bs-theme', theme);
            var lang = localStorage.getItem('cinema_lang') || 'vi';
            document.documentElement.setAttribute('lang', lang);
        })();
    </script>
    <!-- Custom Head Script (From System Settings) -->
    <c:if test="${not empty siteSettings.script_head}">
        ${siteSettings.script_head}
    </c:if>
</head>
<body class="admin-body d-flex flex-column min-vh-100">
<!-- Custom Body Script (From System Settings) -->
<c:if test="${not empty siteSettings.script_body}">
    ${siteSettings.script_body}
</c:if>

<!-- ================= DEDICATED ADMIN NAVBAR ================= -->
<nav class="navbar navbar-expand-lg navbar-cinema navbar-admin sticky-top">
    <div class="container-fluid px-3 px-lg-4">
        <div class="d-flex align-items-center gap-2">
            <!-- Mobile Sidebar Trigger Button (Hamburger) -->
            <button class="btn btn-sm btn-outline-secondary d-lg-none me-1" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminSidebarOffcanvas" aria-controls="adminSidebarOffcanvas" aria-label="Mở menu quản trị">
                <i class="fa-solid fa-bars fs-5"></i>
            </button>

            <!-- Admin Brand Logo -->
            <a class="navbar-brand d-flex align-items-center gap-2 m-0" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fa-solid fa-film text-danger fs-3"></i>
                <span class="fw-bold">CINE<span class="text-white brand-suffix">STAR</span></span>
                <span class="badge bg-danger bg-opacity-25 text-danger border border-danger border-opacity-50 small ms-1 d-none d-sm-inline-block">ADMIN</span>
            </a>
        </div>

        <div class="d-flex align-items-center gap-2 gap-sm-3 ms-auto">
            <!-- Back to Client Website Link -->
            <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-secondary d-none d-md-inline-flex align-items-center gap-2" title="Quay về giao diện khách hàng">
                <i class="fa-solid fa-arrow-up-right-from-square"></i>
                <span data-i18n="admin.viewSite">Xem Website</span>
            </a>

            <!-- Theme Switch (Sáng / Tối) -->
            <button type="button" class="theme-toggle-btn" id="themeToggle" data-i18n-title="nav.themeToggle" title="Chuyển chế độ Sáng / Tối" aria-label="Chuyển chế độ Sáng / Tối">
                <span class="theme-icon light" title="Sáng">
                    <i class="fa-solid fa-sun"></i>
                </span>
                <span class="theme-divider"></span>
                <span class="theme-icon dark active" title="Tối">
                    <i class="fa-solid fa-moon"></i>
                </span>
            </button>

            <!-- Language Switcher (Admin) -->
            <div class="lang-switcher">
                <button type="button" class="lang-btn" id="adminLangToggle" title="Đổi ngôn ngữ / Change Language">
                    <span class="lang-flag"><img src="${pageContext.request.contextPath}/assets/images/flags/vn.svg" class="lang-flag-img" alt="VN"></span>
                    <span class="lang-label"> - VN</span>
                    <i class="fa-solid fa-chevron-down lang-arrow"></i>
                </button>
                <ul class="lang-dropdown">
                    <li>
                        <button type="button" data-lang="vi" class="lang-option">
                            <img src="${pageContext.request.contextPath}/assets/images/flags/vn.svg" class="lang-flag-img" alt="VN">
                            <span> - VN</span>
                        </button>
                    </li>
                    <li>
                        <button type="button" data-lang="en" class="lang-option">
                            <img src="${pageContext.request.contextPath}/assets/images/flags/us.svg" class="lang-flag-img" alt="US">
                            <span> - US</span>
                        </button>
                    </li>
                </ul>
            </div>

            <!-- Admin User Profile Dropdown -->
            <div class="dropdown">
                <a class="nav-link dropdown-toggle text-white d-flex align-items-center gap-2 py-1 px-2 rounded-3 text-decoration-none" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="admin-avatar-badge rounded-circle bg-danger text-white d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-weight: 700; font-size: 0.85rem;">
                        <i class="fa-solid fa-user-shield"></i>
                    </div>
                    <span class="d-none d-sm-inline-block fw-semibold text-truncate text-white" style="max-width: 140px;">
                        ${sessionScope.currentUser != null ? sessionScope.currentUser.fullName : "Quản Trị Viên"}
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end shadow border-secondary mt-2">
                    <li class="px-3 py-2 border-bottom border-secondary">
                        <div class="fw-bold text-white">${sessionScope.currentUser.fullName}</div>
                        <div class="small text-muted">${sessionScope.currentUser.email}</div>
                        <span class="badge bg-danger mt-1">Administrator</span>
                    </li>
                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-house me-2"></i><span data-i18n="admin.viewWebsite">Trang Khách Hàng</span></a></li>
                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-user-gear me-2"></i><span data-i18n="nav.myAccount">Tài Khoản</span></a></li>
                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/settings"><i class="fa-solid fa-gears me-2"></i><span data-i18n="admin.manageSettings">Cài Đặt Hệ Thống</span></a></li>
                    <li><hr class="dropdown-divider border-secondary my-1"></li>
                    <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i><span data-i18n="admin.logout">Đăng Xuất</span></a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- ================= MOBILE OFFCANVAS SIDEBAR ================= -->
<div class="offcanvas offcanvas-start bg-dark text-white border-secondary" tabindex="-1" id="adminSidebarOffcanvas" aria-labelledby="adminSidebarOffcanvasLabel">
    <div class="offcanvas-header border-bottom border-secondary">
        <h5 class="offcanvas-title d-flex align-items-center gap-2" id="adminSidebarOffcanvasLabel">
            <i class="fa-solid fa-film text-danger"></i>
            <span>CINE<span class="text-white">STAR</span> ADMIN</span>
        </h5>
        <button type="button" class="btn-close btn-close-white text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column p-3">
        <h6 class="text-uppercase text-muted fw-bold px-2 mb-2 small" data-i18n="admin.sidebarTitle">Hệ Thống Quản Trị</h6>
        <ul class="nav flex-column admin-nav-list flex-grow-1">
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fa-solid fa-chart-pie me-2"></i><span data-i18n="admin.overview">Tổng Quan</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'movies' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/movies">
                    <i class="fa-solid fa-film me-2"></i><span data-i18n="admin.manageMovies">Quản Lý Phim</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'rooms' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/rooms">
                    <i class="fa-solid fa-door-open me-2"></i><span data-i18n="admin.manageRooms">Quản Lý Phòng Chiếu</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'showtimes' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/showtimes">
                    <i class="fa-solid fa-clock me-2"></i><span data-i18n="admin.manageShowtimes">Quản Lý Suất Chiếu</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'bookings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings">
                    <i class="fa-solid fa-receipt me-2"></i><span data-i18n="admin.manageBookings">Lịch Sử Đặt Vé</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                    <i class="fa-solid fa-users me-2"></i><span data-i18n="admin.manageUsers">Người Dùng</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.activeMenu == 'settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/settings">
                    <i class="fa-solid fa-gears me-2"></i><span data-i18n="admin.manageSettings">Cài Đặt Hệ Thống</span>
                </a>
            </li>
        </ul>

        <hr class="border-secondary my-3">
        <div class="d-grid gap-2">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm text-start">
                <i class="fa-solid fa-house me-2"></i><span data-i18n="admin.viewWebsite">Xem Website Khách Hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm text-start">
                <i class="fa-solid fa-right-from-bracket me-2"></i><span data-i18n="admin.logout">Đăng Xuất</span>
            </a>
        </div>
    </div>
</div>

<!-- ================= MAIN ADMIN LAYOUT ================= -->
<div class="container-fluid flex-grow-1">
    <div class="row min-vh-100 flex-nowrap">
        <!-- Desktop Sidebar (Hidden on mobile/tablet < lg) -->
        <nav class="col-lg-2 d-none d-lg-block admin-sidebar p-3">
            <h6 class="text-uppercase text-muted fw-bold px-3 mb-3 small" data-i18n="admin.sidebarTitle">Hệ Thống Quản Trị</h6>
            <ul class="nav flex-column admin-nav-list">
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-pie me-2"></i><span data-i18n="admin.overview">Tổng Quan</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'movies' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/movies">
                        <i class="fa-solid fa-film me-2"></i><span data-i18n="admin.manageMovies">Quản Lý Phim</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'rooms' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/rooms">
                        <i class="fa-solid fa-door-open me-2"></i><span data-i18n="admin.manageRooms">Quản Lý Phòng Chiếu</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'showtimes' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/showtimes">
                        <i class="fa-solid fa-clock me-2"></i><span data-i18n="admin.manageShowtimes">Quản Lý Suất Chiếu</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'bookings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings">
                        <i class="fa-solid fa-receipt me-2"></i><span data-i18n="admin.manageBookings">Lịch Sử Đặt Vé</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-users me-2"></i><span data-i18n="admin.manageUsers">Người Dùng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.activeMenu == 'settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/settings">
                        <i class="fa-solid fa-gears me-2"></i><span data-i18n="admin.manageSettings">Cài Đặt Hệ Thống</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Dynamic Content Area -->
        <main class="col-12 col-lg-10 px-3 px-md-4 py-4 admin-main-content">
