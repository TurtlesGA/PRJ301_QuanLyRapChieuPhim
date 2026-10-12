<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Suất Chiếu - CineStar Admin" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Quản Lý Suất Chiếu - CineStar Admin"/>
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

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">DANH SÁCH SUẤT CHIẾU</h2>
                <a href="${pageContext.request.contextPath}/admin/showtime-add" class="btn btn-danger fw-bold">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Suất Chiếu Mới
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th>ID</th>
                                <th>PHIM</th>
                                <th>PHÒNG CHIẾU</th>
                                <th>NGÀY CHIẾU</th>
                                <th>GIỜ BẮT ĐẦU</th>
                                <th>GIỜ KẾT THÚC</th>
                                <th>GIÁ VÉ GỐC</th>
                                <th>TRẠNG THÁI</th>
                                <th class="text-end">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${showtimes}" var="s">
                                <tr>
                                    <td>#${s.showtimeId}</td>
                                    <td class="fw-bold text-white">${s.movie.title}</td>
                                    <td><span class="badge bg-secondary">${s.room.roomName} (${s.room.roomType})</span></td>
                                    <td><fmt:formatDate value="${s.showDate}" pattern="dd/MM/yyyy"/></td>
                                    <td class="text-warning fw-bold"><fmt:formatDate value="${s.startTime}" pattern="HH:mm"/></td>
                                    <td><fmt:formatDate value="${s.endTime}" pattern="HH:mm"/></td>
                                    <td class="text-info"><fmt:formatNumber value="${s.basePrice}" type="number"/> đ</td>
                                    <td><span class="badge ${s.status == 'OPEN' ? 'bg-success' : 'bg-secondary'}">${s.status}</span></td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/admin/showtime-delete?id=${s.showtimeId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa suất chiếu này?');">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
