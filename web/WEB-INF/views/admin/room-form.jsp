<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${room != null ? 'Chỉnh Sửa Phòng Chiếu' : 'Thêm Phòng Chiếu Mới'} - CineStar Admin" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="${room != null ? 'Chỉnh Sửa Phòng Chiếu' : 'Thêm Phòng Chiếu Mới'} - CineStar Admin"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-door-open me-2"></i>Quản Lý Phòng Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/showtimes"><i class="fa-solid fa-clock me-2"></i>Quản Lý Suất Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-receipt me-2"></i>Lịch Sử Đặt Vé</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2"></i>Người Dùng</a>
                </li>
            </ul>
        </nav>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">${room != null ? 'CHỈNH SỬA PHÒNG CHIẾU' : 'THÊM PHÒNG CHIẾU MỚI'}</h2>
                <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-outline-secondary text-white btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>Quay Lại
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <form action="${pageContext.request.contextPath}/admin/rooms" method="POST">
                    <c:if test="${room != null}">
                        <input type="hidden" name="roomId" value="${room.roomId}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label text-light small">Tên phòng chiếu *</label>
                            <input type="text" class="form-control" name="roomName" value="${room.roomName}" placeholder="Ví dụ: Phòng Cinema 04 (2D)" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Định dạng phòng *</label>
                            <select class="form-select" name="roomType" required>
                                <option value="2D" ${room.roomType == '2D' ? 'selected' : ''}>2D Standard</option>
                                <option value="3D" ${room.roomType == '3D' ? 'selected' : ''}>3D Cinema</option>
                                <option value="IMAX" ${room.roomType == 'IMAX' ? 'selected' : ''}>IMAX Experience</option>
                                <option value="4DX" ${room.roomType == '4DX' ? 'selected' : ''}>4DX Motion</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Số hàng ghế *</label>
                            <input type="number" class="form-control" name="totalRows" min="1" max="15" value="${room != null ? room.totalRows : 5}" ${room != null ? 'readonly' : 'required'}>
                            <c:if test="${room != null}">
                                <div class="form-text text-secondary small">Không thể thay đổi sơ đồ số hàng sau khi đã khởi tạo ghế.</div>
                            </c:if>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Số ghế mỗi hàng *</label>
                            <input type="number" class="form-control" name="totalCols" min="1" max="20" value="${room != null ? room.totalCols : 8}" ${room != null ? 'readonly' : 'required'}>
                            <c:if test="${room != null}">
                                <div class="form-text text-secondary small">Không thể thay đổi sơ đồ số ghế sau khi đã khởi tạo ghế.</div>
                            </c:if>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small">Trạng thái phòng *</label>
                            <select class="form-select" name="status">
                                <option value="true" ${room == null || room.status ? 'selected' : ''}>Hoạt động</option>
                                <option value="false" ${room != null && !room.status ? 'selected' : ''}>Tạm dừng</option>
                            </select>
                        </div>
                    </div>

                    <hr class="border-secondary my-4">

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-secondary px-4">Hủy Bỏ</a>
                        <button type="submit" class="btn btn-danger fw-bold px-4">
                            <i class="fa-solid fa-save me-1"></i>Lưu Phòng Chiếu
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
