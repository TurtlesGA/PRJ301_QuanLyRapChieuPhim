<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Đơn Vé - CineStar Admin" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Quản Lý Đơn Vé - CineStar Admin"/>
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/showtimes"><i class="fa-solid fa-clock me-2"></i>Quản Lý Suất Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-receipt me-2"></i>Lịch Sử Đặt Vé</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2"></i>Người Dùng</a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">LỊCH SỬ ĐẶT VÉ TOÀN HỆ THỐNG</h2>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th>MÃ ĐƠN</th>
                                <th>KHÁCH HÀNG</th>
                                <th>PHIM</th>
                                <th>PHÒNG</th>
                                <th>SUẤT CHIẾU</th>
                                <th>GHẾ ĐÃ ĐẶT</th>
                                <th>PHƯƠNG THỨC</th>
                                <th>TỔNG TIỀN</th>
                                <th>TRẠNG THÁI</th>
                                <th>THỜI GIAN ĐẶT</th>
                                <th class="text-end">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${bookings}" var="b">
                                <tr>
                                    <td class="text-warning fw-bold">#${b.bookingCode}</td>
                                    <td>
                                        <div class="fw-bold">${b.user.fullName}</div>
                                        <small class="text-muted">${b.user.phone}</small>
                                    </td>
                                    <td class="text-white">${b.showtime.movie.title}</td>
                                    <td>${b.showtime.room.roomName}</td>
                                    <td>
                                        <fmt:formatDate value="${b.showtime.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${b.showtime.showDate}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>
                                        <c:forEach items="${b.tickets}" var="t">
                                             <span class="badge bg-secondary">${t.seat.seatCode}</span>
                                        </c:forEach>
                                    </td>
                                    <td><span class="badge bg-info text-dark">${b.paymentMethod}</span></td>
                                    <td class="text-danger fw-bold"><fmt:formatNumber value="${b.totalAmount}" type="number"/> đ</td>
                                    <td>
                                        <span class="badge ${b.paymentStatus == 'PAID' ? 'bg-success' : (b.paymentStatus == 'CANCELLED' ? 'bg-danger' : 'bg-secondary')}">${b.paymentStatus}</span>
                                    </td>
                                    <td class="small text-muted"><fmt:formatDate value="${b.bookingTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="text-end">
                                        <c:if test="${b.paymentStatus == 'PAID'}">
                                            <a href="${pageContext.request.contextPath}/admin/booking-cancel?id=${b.bookingId}" 
                                               class="btn btn-sm btn-outline-danger" 
                                               onclick="return confirm('Bạn có chắc chắn muốn hủy đơn vé này không?');">
                                                Hủy Đơn
                                            </a>
                                        </c:if>
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
