<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-cinema sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-film text-danger fs-3"></i>
            <span>CINE<span class="text-white">STAR</span></span>
        </a>
        <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#cinemaNav">
            <i class="fa-solid fa-bars fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="cinemaNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang Chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/movies?filter=now">Phim Đang Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/movies?filter=soon">Phim Sắp Chiếu</a>
                </li>
            </ul>

            <!-- Search Form -->
            <form class="d-flex me-lg-3 my-2 my-lg-0" action="${pageContext.request.contextPath}/movies" method="GET" accept-charset="UTF-8">
                <div class="input-group">
                    <input class="form-control form-control-sm bg-dark text-white border-secondary" type="search" name="q" placeholder="Tìm tên phim..." value="${searchKeyword}">
                    <button class="btn btn-sm btn-outline-danger" type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </form>
                    
            <!-- User Auth -->
            <ul class="navbar-nav align-items-center mb-2 mb-lg-0">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-white d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fa-solid fa-circle-user fs-5 text-danger"></i>
                                <span>${sessionScope.currentUser.fullName}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end shadow">
                                <c:if test="${sessionScope.currentUser.admin}">
                                    <li><a class="dropdown-item text-warning" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-line me-2"></i>Trang Quản Trị</a></li>
                                    <li><hr class="dropdown-divider border-secondary"></li>
                                    </c:if>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/my-bookings"><i class="fa-solid fa-ticket me-2"></i>Vé Của Tôi</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-user-gear me-2"></i>Tài Khoản</a></li>
                                <li><hr class="dropdown-divider border-secondary"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng Xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link btn btn-outline-secondary btn-sm px-3 me-2 text-white border-0" href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-danger btn-sm px-3 rounded-pill fw-bold" href="${pageContext.request.contextPath}/register">Đăng Ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <!-- Theme Switch (Sáng / Tối) -->
                <li class="nav-item ms-lg-2">
                    <button type="button" class="theme-toggle-btn" id="themeToggle" title="Chuyển chế độ Sáng / Tối" aria-label="Chuyển chế độ Sáng / Tối">
                        <span class="theme-icon light" title="Sáng">
                            <i class="fa-solid fa-sun"></i>
                        </span>
                        <span class="theme-divider"></span>
                        <span class="theme-icon dark active" title="Tối">
                            <i class="fa-solid fa-moon"></i>
                        </span>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>
