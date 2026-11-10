<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Đơn Vé - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Đơn Vé - CineStar Admin"/>
    <jsp:param name="activeMenu" value="bookings"/>
</jsp:include>

            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white" data-i18n="admin.bookings.title">LỊCH SỬ ĐẶT VÉ TOÀN HỆ THỐNG</h2>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th data-i18n="admin.bookings.colCode">MÃ ĐƠN</th>
                                <th data-i18n="admin.bookings.colCustomer">KHÁCH HÀNG</th>
                                <th data-i18n="admin.bookings.colMovie">PHIM</th>
                                <th data-i18n="admin.bookings.colRoom">PHÒNG</th>
                                <th data-i18n="admin.bookings.colShowtime">SUẤT CHIẾU</th>
                                <th data-i18n="admin.bookings.colSeats">GHẾ ĐÃ ĐẶT</th>
                                <th data-i18n="admin.bookings.colMethod">PHƯƠNG THỨC</th>
                                <th data-i18n="admin.bookings.colTotal">TỔNG TIỀN</th>
                                <th data-i18n="admin.bookings.colStatus">TRẠNG THÁI</th>
                                <th data-i18n="admin.bookings.colBookTime">THỜI GIAN ĐẶT</th>
                                <th class="text-end" data-i18n="admin.bookings.colActions">THAO TÁC</th>
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
                                    <td class="text-white"><span class="movie-title" data-original-title="${b.showtime.movie.title}">${b.showtime.movie.title}</span></td>
                                    <td><span class="room-name" data-original-room="${b.showtime.room.roomName}">${b.showtime.room.roomName}</span></td>
                                    <td>
                                        <fmt:formatDate value="${b.showtime.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${b.showtime.showDate}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>
                                        <c:forEach items="${b.tickets}" var="t">
                                             <span class="badge bg-secondary">${t.seat.seatCode}</span>
                                        </c:forEach>
                                    </td>
                                    <td><span class="badge bg-info text-dark">${b.paymentMethod}</span></td>
                                    <td class="text-danger fw-bold"><fmt:formatNumber value="${b.totalAmount}" type="number"/> <span data-i18n="common.currency">đ</span></td>
                                    <td>
                                        <span class="badge badge-status ${b.paymentStatus == 'PAID' ? 'bg-success' : (b.paymentStatus == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')}" data-status-code="${b.paymentStatus}">${b.paymentStatus}</span>
                                    </td>
                                    <td class="small text-muted"><fmt:formatDate value="${b.bookingTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="text-end">
                                        <c:if test="${b.paymentStatus == 'PAID' || b.paymentStatus == 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/admin/booking-cancel?id=${b.bookingId}" 
                                               class="btn btn-sm btn-outline-danger btn-swal-confirm" 
                                               data-title="Hủy đơn vé?"
                                               data-confirm="Bạn có chắc chắn muốn hủy đơn vé #${b.bookingCode} không? Vé sẽ bị hủy và không thể hoàn tác."
                                               data-i18n-confirm-title="admin.bookings.cancelConfirmTitle"
                                               data-i18n-confirm="admin.bookings.cancelConfirm"
                                               data-icon="warning"
                                               data-confirm-color="#dc3545">
                                                <i class="fa-solid fa-ban me-1"></i><span data-i18n="admin.bookings.cancelBtn">Hủy Đơn</span>
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center mt-3 pt-3 border-top border-secondary gap-2">
                        <div class="text-muted small">
                            <span data-i18n="common.page">Trang</span> <strong>${currentPage}</strong> / <strong>${totalPages}</strong> (<span data-i18n="common.total">Tổng</span> <strong>${totalItems}</strong> <span data-i18n="admin.bookings.titleUnit">đơn vé</span>)
                        </div>
                        <nav aria-label="Pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/bookings?page=${currentPage - 1}"><i class="fa-solid fa-angle-left"></i></a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                        <li class="page-item ${currentPage == p ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/bookings?page=${p}">${p}</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${(p == 2 && currentPage - 2 > 2) || (p == totalPages - 1 && currentPage + 2 < totalPages - 1)}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/bookings?page=${currentPage + 1}"><i class="fa-solid fa-angle-right"></i></a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>

<jsp:include page="common/admin-footer.jsp"/>