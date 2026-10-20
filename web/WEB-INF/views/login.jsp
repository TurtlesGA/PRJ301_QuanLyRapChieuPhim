<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Đăng Nhập - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Đăng Nhập - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5 d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card auth-card bg-dark border-secondary p-4 rounded-4 shadow">
                    <div class="text-center mb-4">
                        <i class="fa-solid fa-film text-danger fs-1 mb-2"></i>
                        <h4 class="fw-bold auth-title text-white" data-i18n="login.title">ĐĂNG NHẬP</h4>
                        <p class="small auth-subtitle text-muted" data-i18n="login.subtitle">Truy cập để quản lý tài khoản & đặt vé xem phim</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small auth-error-alert" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i><span class="alert-text">${error}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2 small auth-success-alert" role="alert">
                            <i class="fa-solid fa-circle-check me-1"></i><span class="alert-text">${successMsg}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.authMsg}">
                        <div class="alert alert-warning py-2 small auth-warning-alert" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i><span class="alert-text">${sessionScope.authMsg}</span>
                        </div>
                        <c:remove var="authMsg" scope="session"/>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="mb-3">
                            <label class="form-label auth-label text-light small" data-i18n="login.username">Tên đăng nhập</label>
                            <div class="input-group">
                                <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-user"></i></span>
                                <input type="text" class="form-control" name="username" value="${username}" data-i18n-placeholder="login.usernamePlaceholder" placeholder="Nhập username" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label auth-label text-light small" data-i18n="login.password">Mật khẩu</label>
                            <div class="input-group">
                                <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" class="form-control" name="password" data-i18n-placeholder="login.passwordPlaceholder" placeholder="Nhập password" required>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mb-3">
                            <a href="${pageContext.request.contextPath}/forgot-password" class="text-warning small text-decoration-none" data-i18n="login.forgotPassword">Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold mb-3" data-i18n="login.loginBtn">Đăng Nhập</button>
                    </form>

                    <div class="text-center small auth-footer-text text-muted">
                        <span data-i18n="login.noAccount">Chưa có tài khoản?</span> <a href="${pageContext.request.contextPath}/register" class="text-danger fw-bold text-decoration-none" data-i18n="login.registerNow">Đăng ký ngay</a>
                    </div>

                    <!-- Demo Accounts Helper -->
                    <div class="mt-4 p-3 rounded demo-account-box small border border-secondary text-muted">
                        <strong class="demo-title text-white d-block mb-1" data-i18n="login.demoTitle">Tài khoản demo:</strong>
                        <div><span data-i18n="login.demoAdmin">Admin:</span> <code>admin</code> / <code>123456</code></div>
                        <div><span data-i18n="login.demoGuest">Khách:</span> <code>customer</code> / <code>123456</code></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>