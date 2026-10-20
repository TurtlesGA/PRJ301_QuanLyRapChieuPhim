<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Đặt Vé Thành Công - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Đặt Vé Thành Công - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card bg-dark border-success p-4 rounded-4 shadow text-center">
                    <div class="mb-3">
                        <i class="fa-solid fa-circle-check text-success display-3"></i>
                    </div>
                    <h3 class="fw-bold text-white mb-2" data-i18n="bookingSuccess.title">ĐẶT VÉ THÀNH CÔNG!</h3>
                    <p class="text-muted small mb-4" data-i18n="bookingSuccess.thanks">Cảm ơn bạn đã lựa chọn CineStar. Mã vé của bạn đã sẵn sàng.</p>

                    <!-- Ticket Slip -->
                    <div class="p-3 rounded-3 text-start mb-4 border border-secondary ticket-slip" style="background-color: #222;">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted" data-i18n="bookingSuccess.bookingCode">Mã đơn vé:</span>
                            <strong class="text-warning fs-5">${booking.bookingCode}</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted" data-i18n="bookingSuccess.movie">Phim:</span>
                            <span class="text-white fw-bold movie-title" data-original-title="${booking.showtime.movie.title}">${booking.showtime.movie.title}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted" data-i18n="bookingSuccess.room">Phòng chiếu:</span>
                            <span class="text-white room-name" data-original-room="${booking.showtime.room.roomName}">${booking.showtime.room.roomName}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted" data-i18n="bookingSuccess.time">Thời gian:</span>
                            <span class="text-white">
                                <fmt:formatDate value="${booking.showtime.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${booking.showtime.showDate}" pattern="dd/MM/yyyy"/>
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted" data-i18n="bookingSuccess.seats">Danh sách ghế:</span>
                            <span class="text-info fw-bold">
                                <c:forEach items="${booking.tickets}" var="t" varStatus="loop">
                                    ${t.seat.seatCode}${!loop.last ? ', ' : ''}
                                </c:forEach>
                            </span>
                        </div>
                        <hr class="border-secondary my-2">
                        <div class="d-flex justify-content-between">
                            <span class="text-white fw-bold" data-i18n="bookingSuccess.total">Tổng thanh toán:</span>
                            <span class="text-danger fw-bold fs-5">
                                <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/my-bookings" class="btn btn-outline-light flex-grow-1" data-i18n="bookingSuccess.viewHistory">Xem Lịch Sử Vé</a>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-danger flex-grow-1" data-i18n="bookingSuccess.backHome">Về Trang Chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>