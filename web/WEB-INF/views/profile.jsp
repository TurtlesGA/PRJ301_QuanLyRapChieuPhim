<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Thông Tin Tài Khoản - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Thông Tin Tài Khoản - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card bg-dark border-secondary p-4 rounded-4 shadow">
                    <h4 class="fw-bold text-white mb-4 border-bottom border-secondary pb-3">
                        <i class="fa-solid fa-user-gear text-danger me-2"></i>THÔNG TIN TÀI KHOẢN
                    </h4>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2 small"><i class="fa-solid fa-check me-1"></i>${successMsg}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small"><i class="fa-solid fa-circle-exclamation me-1"></i>${error}</div>
                    </c:if>

                    <!-- Update Info Form -->
                    <form action="${pageContext.request.contextPath}/profile" method="POST" class="mb-5">
                        <input type="hidden" name="action" value="updateInfo">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-light small">Tên đăng nhập</label>
                                <input type="text" class="form-control" value="${sessionScope.currentUser.username}" disabled>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light small">Vai trò</label>
                                <input type="text" class="form-control" value="${sessionScope.currentUser.role}" disabled>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label text-light small">Họ và tên</label>
                                <input type="text" class="form-control" name="fullName" value="${sessionScope.currentUser.fullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light small">Email</label>
                                <input type="email" class="form-control" name="email" value="${sessionScope.currentUser.email}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light small">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phone" value="${sessionScope.currentUser.phone}">
                            </div>
                            <div class="col-12 mt-3">
                                <button type="submit" class="btn btn-danger fw-bold px-4">Lưu Thay Đổi</button>
                            </div>
                        </div>
                    </form>

                    <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2">
                        <i class="fa-solid fa-key text-warning me-2"></i>ĐỔI MẬT KHẨU
                    </h5>

                    <c:if test="${not empty pwSuccess}">
                        <div class="alert alert-success py-2 small"><i class="fa-solid fa-check me-1"></i>${pwSuccess}</div>
                    </c:if>
                    <c:if test="${not empty pwError}">
                        <div class="alert alert-danger py-2 small"><i class="fa-solid fa-circle-exclamation me-1"></i>${pwError}</div>
                    </c:if>

                    <!-- Change Password Form -->
                    <form action="${pageContext.request.contextPath}/profile" method="POST">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label text-light small">Mật khẩu hiện tại</label>
                                <input type="password" class="form-control" name="oldPassword" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-light small">Mật khẩu mới</label>
                                <input type="password" class="form-control" name="newPassword" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-light small">Xác nhận mật khẩu mới</label>
                                <input type="password" class="form-control" name="confirmNewPassword" required>
                            </div>
                            <div class="col-12 mt-3">
                                <button type="submit" class="btn btn-outline-warning fw-bold px-4">Đổi Mật Khẩu</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
