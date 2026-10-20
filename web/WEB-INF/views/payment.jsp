<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Thanh Toán Trực Tuyến - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Thanh Toán Trực Tuyến - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10 col-xl-9">
                <div class="card bg-dark border-secondary p-4 p-md-5 rounded-4 shadow">
                    
                    <div class="text-center mb-4 border-bottom border-secondary pb-3">
                        <c:choose>
                            <c:when test="${booking.paymentMethod == 'MOMO'}">
                                <span class="badge bg-danger fs-6 px-3 py-2 mb-2">
                                    <i class="fa-solid fa-wallet me-2"></i><span data-i18n="payment.badgeMomo">Ví Điện Tử MoMo</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary fs-6 px-3 py-2 mb-2">
                                    <i class="fa-solid fa-qrcode me-2"></i><span data-i18n="payment.badgeVnpay">Cổng Thanh Toán VNPAY (QR Pay)</span>
                                </span>
                            </c:otherwise>
                        </c:choose>
                        <h3 class="fw-bold text-white mt-2" data-i18n="payment.title">CỔNG THANH TOÁN TRỰC TUYẾN</h3>
                        <p class="text-muted small mb-0" data-i18n="payment.subtitle">Quét mã QR để hoàn tất thanh toán đơn vé của bạn</p>
                    </div>

                    <div class="row g-4 align-items-center">
                        <div class="col-md-5 text-center">
                            <div class="p-3 bg-white rounded-3 shadow-sm d-inline-block border border-3 border-secondary">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=CINESTAR_PAYMENT_ACCOUNT" 
                                     alt="QR Code Thanh Toán" 
                                     class="img-fluid" 
                                     style="width: 220px; height: 220px; display: block;" />
                            </div>

                            <div class="mt-3">
                                <span class="text-muted small d-block mb-1" data-i18n="payment.expiresIn">Giao dịch hết hạn trong:</span>
                                <span id="countdownTimer" class="fw-bold text-warning fs-5">10:00</span>
                            </div>

                            <div class="mt-2 text-muted small">
                                <i class="fa-solid fa-camera me-1"></i><span data-i18n="payment.openAppHint">Mở App Ngân hàng hoặc Ví để quét</span>
                            </div>
                        </div>

                        <div class="col-md-7">
                            <div class="p-3 rounded-3 border border-secondary" style="background-color: #1a1a1a;">
                                <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2">
                                    <i class="fa-solid fa-receipt text-warning me-2"></i><span data-i18n="payment.ticketInfo">Thông Tin Đơn Vé</span>
                                </h5>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted small" data-i18n="payment.bookingCode">Mã đơn vé:</span>
                                    <strong class="text-warning">#${booking.bookingCode}</strong>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted small" data-i18n="payment.movie">Phim:</span>
                                    <span class="text-white fw-bold movie-title" data-original-title="${booking.showtime.movie.title}">${booking.showtime.movie.title}</span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted small" data-i18n="payment.room">Phòng chiếu:</span>
                                    <span class="text-white"><span class="room-name" data-original-room="${booking.showtime.room.roomName}">${booking.showtime.room.roomName}</span> (${booking.showtime.room.roomType})</span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted small" data-i18n="payment.showtime">Suất chiếu:</span>
                                    <span class="text-white">
                                        <fmt:formatDate value="${booking.showtime.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${booking.showtime.showDate}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted small" data-i18n="payment.selectedSeats">Ghế đã chọn:</span>
                                    <div>
                                        <c:forEach items="${booking.tickets}" var="t">
                                            <span class="badge bg-secondary">${t.seat.seatCode}</span>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted small" data-i18n="payment.transferContent">Nội dung chuyển khoản:</span>
                                    <code class="text-warning bg-black px-2 py-1 rounded">CINESTAR ${booking.bookingCode}</code>
                                </div>

                                <hr class="border-secondary my-3">

                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-white fw-bold" data-i18n="payment.paymentAmount">Số tiền thanh toán:</span>
                                    <span class="text-danger fw-bold fs-4">
                                        <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/> đ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-secondary bg-black border-secondary text-light small mt-4 mb-4" data-i18n-html="payment.notice">
                        <i class="fa-solid fa-circle-info text-info me-2"></i>
                        Vui lòng chuyển đúng số tiền và nội dung chuyển khoản. Sau khi chuyển khoản thành công trên điện thoại, bấm <strong>"Tôi Đã Chuyển Khoản Thành Công"</strong> để hoàn tất đơn vé.
                    </div>

                    <form action="${pageContext.request.contextPath}/payment-confirm" method="POST">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center">
                            <button type="submit" name="action" value="confirm" class="btn btn-success fw-bold py-2 px-4">
                                <i class="fa-solid fa-circle-check me-2"></i><span data-i18n="payment.iHavePaid">Tôi Đã Chuyển Khoản Thành Công</span>
                            </button>
                            <button type="submit" name="action" value="cancel" class="btn btn-outline-danger py-2 px-4"
                                    onclick="return confirm(window.CinemaI18n ? window.CinemaI18n.t('payment.cancelConfirm', 'Bạn có chắc chắn muốn hủy thanh toán không? Vé và ghế đã giữ sẽ được giải phóng ngay.') : 'Bạn có chắc chắn muốn hủy thanh toán không?');">
                                <i class="fa-solid fa-xmark me-2"></i><span data-i18n="payment.cancelPayment">Hủy Thanh Toán</span>
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</main>

<script>
    var timeLeft = 600;
    var timerElement = document.getElementById("countdownTimer");
    var timerInterval = setInterval(function () {
        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            var expiredLabel = window.CinemaI18n ? window.CinemaI18n.t('payment.expired', 'Hết hạn') : 'Hết hạn';
            var alertMsg = window.CinemaI18n ? window.CinemaI18n.t('payment.timeoutAlert', 'Thời gian giữ chỗ thanh toán đã hết hạn! Đơn đặt vé sẽ được đưa về danh sách vé.') : 'Thời gian giữ chỗ thanh toán đã hết hạn!';
            timerElement.innerText = expiredLabel;
            alert(alertMsg);
            window.location.href = "${pageContext.request.contextPath}/my-bookings";
        } else {
            var minutes = Math.floor(timeLeft / 60);
            var seconds = timeLeft % 60;
            var displayMin = minutes < 10 ? "0" + minutes : minutes;
            var displaySec = seconds < 10 ? "0" + seconds : seconds;
            timerElement.innerText = displayMin + ":" + displaySec;
            timeLeft--;
        }
    }, 1000);
</script>

<jsp:include page="common/footer.jsp"/>