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
                        <h4 class="fw-bold auth-title text-white">ĐĂNG NHẬP</h4>
                        <p class="small auth-subtitle text-muted">Truy cập để quản lý tài khoản & đặt vé xem phim</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2 small" role="alert">
                            <i class="fa-solid fa-circle-check me-1"></i>${successMsg}
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.authMsg}">
                        <div class="alert alert-warning py-2 small" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i>${sessionScope.authMsg}
                        </div>
                        <c:remove var="authMsg" scope="session"/>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="mb-3">
                            <label class="form-label auth-label text-light small">Tên đăng nhập</label>
                            <div class="input-group">
                                <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-user"></i></span>
                                <input type="text" class="form-control" name="username" value="${username}" placeholder="Nhập username" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label auth-label text-light small">Mật khẩu</label>
                            <div class="input-group">
                                <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" class="form-control" name="password" placeholder="Nhập password" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold mb-3">Đăng Nhập</button>
                    </form>

                    <div class="text-center small auth-footer-text text-muted">
                        Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-danger fw-bold text-decoration-none">Đăng ký ngay</a>
                    </div>

                    <!-- Demo Accounts Helper -->
                    <div class="mt-4 p-3 rounded demo-account-box small border border-secondary text-muted">
                        <strong class="demo-title text-white d-block mb-1">Tài khoản demo:</strong>
                        <div>Admin: <code>admin</code> / <code>123456</code></div>
                        <div>Khách: <code>customer</code> / <code>123456</code></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
