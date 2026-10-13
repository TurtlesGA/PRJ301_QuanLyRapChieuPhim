<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Bảng Điều Khiển Quản Trị - CineStar" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Bảng Điều Khiển Quản Trị - CineStar"/>
    <jsp:param name="activeMenu" value="dashboard"/>
</jsp:include>
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">BẢNG ĐIỀU KHIỂN HỆ THỐNG</h2>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/admin/movie-add" class="btn btn-sm btn-danger fw-bold me-2">
                        <i class="fa-solid fa-plus me-1"></i>Thêm Phim Mới
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/showtime-add" class="btn btn-sm btn-outline-light fw-bold">
                        <i class="fa-solid fa-calendar-plus me-1"></i>Thêm Suất Chiếu
                    </a>
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="row g-4 mb-5">
                <div class="col-sm-6 col-xl-3">
                    <div class="card bg-dark border-secondary p-3 rounded-4 shadow-sm">
                        <div class="d-flex align-items-center">
                            <div class="p-3 rounded-3 bg-danger bg-opacity-25 text-danger me-3">
                                <i class="fa-solid fa-sack-dollar fs-2"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block">Doanh Thu</small>
                                <h4 class="text-white fw-bold mb-0">
                                    <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> đ
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="card bg-dark border-secondary p-3 rounded-4 shadow-sm">
                        <div class="d-flex align-items-center">
                            <div class="p-3 rounded-3 bg-success bg-opacity-25 text-success me-3">
                                <i class="fa-solid fa-ticket fs-2"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block">Vé Đã Bán</small>
                                <h4 class="text-white fw-bold mb-0">${totalTickets}</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="card bg-dark border-secondary p-3 rounded-4 shadow-sm">
                        <div class="d-flex align-items-center">
                            <div class="p-3 rounded-3 bg-warning bg-opacity-25 text-warning me-3">
                                <i class="fa-solid fa-film fs-2"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block">Số Lượng Phim</small>
                                <h4 class="text-white fw-bold mb-0">${totalMovies}</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="card bg-dark border-secondary p-3 rounded-4 shadow-sm">
                        <div class="d-flex align-items-center">
                            <div class="p-3 rounded-3 bg-info bg-opacity-25 text-info me-3">
                                <i class="fa-solid fa-user-group fs-2"></i>
                            </div>
                            <div>
                                <small class="text-muted d-block">Người Dùng</small>
                                <h4 class="text-white fw-bold mb-0">${totalUsers}</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders Table -->
            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-white mb-0">Đơn Đặt Vé Gần Đây</h5>
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="text-danger small fw-bold text-decoration-none">Xem tất cả</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th>MÃ ĐƠN</th>
                                <th>KHÁCH HÀNG</th>
                                <th>PHIM</th>
                                <th>SUẤT CHIẾU</th>
                                <th>GHẾ</th>
                                <th>TỔNG TIỀN</th>
                                <th>TRẠNG THÁI</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentBookings}" var="b">
                                <tr>
                                    <td class="text-warning fw-bold">#${b.bookingCode}</td>
                                    <td>${b.user.fullName}</td>
                                    <td>${b.showtime.movie.title}</td>
                                    <td><fmt:formatDate value="${b.showtime.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${b.showtime.showDate}" pattern="dd/MM"/></td>
                                    <td>
                                        <c:forEach items="${b.tickets}" var="t">
                                            <span class="badge bg-secondary">${t.seat.seatCode}</span>
                                        </c:forEach>
                                    </td>
                                    <td class="text-danger fw-bold"><fmt:formatNumber value="${b.totalAmount}" type="number"/> đ</td>
                                    <td><span class="badge ${b.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning'}">${b.paymentStatus}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
<jsp:include page="common/admin-footer.jsp"/>
