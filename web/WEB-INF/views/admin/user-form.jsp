<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${user != null ? 'Chỉnh Sửa Người Dùng' : 'Thêm Người Dùng Mới'} - CineStar Admin" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="${user != null ? 'Chỉnh Sửa Người Dùng' : 'Thêm Người Dùng Mới'} - CineStar Admin"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block admin-sidebar p-3">
            <h6 class="text-uppercase text-muted fw-bold px-3 mb-3 small">Hệ Thống Quản Trị</h6>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-pie me-2"></i>Tổng Quan</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/movies"><i class="fa-solid fa-film me-2"></i>Quản Lý Phim</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-door-open me-2"></i>Quản Lý Phòng Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/showtimes"><i class="fa-solid fa-clock me-2"></i>Quản Lý Suất Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-receipt me-2"></i>Lịch Sử Đặt Vé</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2"></i>Người Dùng</a>
                </li>
            </ul>
        </nav>

        <!-- Main Form -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">${user != null ? 'CHỈNH SỬA NGƯỜI DÙNG' : 'THÊM NGƯỜI DÙNG MỚI'}</h2>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary text-white btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>Quay Lại
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                    <c:if test="${user != null}">
                        <input type="hidden" name="userId" value="${user.userId}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-light small">Tên đăng nhập *</label>
                            <input type="text" class="form-control" name="username" value="${user != null ? user.username : param.username}" placeholder="Nhập tên đăng nhập" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Mật khẩu ${user != null ? '(để trống nếu giữ nguyên)' : '*'}</label>
                            <input type="password" class="form-control" name="password" placeholder="${user != null ? 'Để trống nếu không đổi mật khẩu' : 'Nhập mật khẩu'}" ${user != null ? '' : 'required'}>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Họ và tên *</label>
                            <input type="text" class="form-control" name="fullName" value="${user != null ? user.fullName : param.fullName}" placeholder="Nhập họ và tên" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Email *</label>
                            <input type="email" class="form-control" name="email" value="${user != null ? user.email : param.email}" placeholder="example@email.com" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Số điện thoại</label>
                            <input type="text" class="form-control" name="phone" value="${user != null ? user.phone : param.phone}" placeholder="Nhập số điện thoại">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Vai trò *</label>
                            <select class="form-select" name="role" required>
                                <option value="CUSTOMER" ${(user != null && user.role == 'CUSTOMER') || param.role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng (CUSTOMER)</option>
                                <option value="STAFF" ${(user != null && user.role == 'STAFF') || param.role == 'STAFF' ? 'selected' : ''}>Nhân viên (STAFF)</option>
                                <option value="ADMIN" ${(user != null && user.role == 'ADMIN') || param.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên (ADMIN)</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Trạng thái *</label>
                            <select class="form-select" name="status" required>
                                <option value="1" ${(user == null || user.status || param.status == '1') ? 'selected' : ''}>Hoạt động</option>
                                <option value="0" ${(user != null && !user.status) || param.status == '0' ? 'selected' : ''}>Bị khóa</option>
                            </select>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top border-secondary text-end">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary me-2">Hủy bỏ</a>
                            <button type="submit" class="btn btn-danger fw-bold px-4">
                                <i class="fa-solid fa-save me-1"></i>${user != null ? 'Cập Nhật' : 'Lưu Người Dùng'}
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
