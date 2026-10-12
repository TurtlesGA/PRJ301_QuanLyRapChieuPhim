<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Thêm Suất Chiếu Mới - CineStar Admin"/>
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/showtimes"><i class="fa-solid fa-clock me-2"></i>Quản Lý Suất Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-receipt me-2"></i>Lịch Sử Đặt Vé</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2"></i>Người Dùng</a>
                </li>
            </ul>
        </nav>

        <!-- Main Form -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">THÊM SUẤT CHIẾU MỚI</h2>
                <a href="${pageContext.request.contextPath}/admin/showtimes" class="btn btn-outline-secondary text-white btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>Quay Lại
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <form action="${pageContext.request.contextPath}/admin/showtimes" method="POST">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-light small">Chọn phim *</label>
                            <select class="form-select" name="movieId" required>
                                <c:forEach items="${movies}" var="m">
                                    <option value="${m.movieId}">${m.title} (${m.duration} phút)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Chọn phòng chiếu *</label>
                            <select class="form-select" name="roomId" required>
                                <c:forEach items="${rooms}" var="r">
                                    <option value="${r.roomId}">${r.roomName} (${r.roomType})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Ngày chiếu *</label>
                            <input type="date" class="form-control" name="showDate" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Giờ bắt đầu *</label>
                            <input type="time" class="form-control" name="startTime" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Giờ kết thúc *</label>
                            <input type="time" class="form-control" name="endTime" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Giá vé cơ bản (VNĐ) *</label>
                            <input type="number" step="5000" class="form-control" name="basePrice" value="85000" required>
                        </div>

                        <div class="col-12 mt-4">
                            <button type="submit" class="btn btn-danger fw-bold px-4 py-2">
                                <i class="fa-solid fa-calendar-plus me-1"></i>Thêm Suất Chiếu
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
