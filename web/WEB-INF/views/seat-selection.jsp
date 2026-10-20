<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Chọn Ghế - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Chọn Ghế - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-4">
    <div class="container">
        <c:if test="${not empty error}">
            <div class="alert alert-danger py-2 small mb-3">
                <i class="fa-solid fa-circle-exclamation me-1"></i>${error}
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger py-2 small mb-3">
                <i class="fa-solid fa-circle-exclamation me-1"></i>${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>
        <!-- Movie & Showtime Info Bar -->
        <div class="card bg-dark border-secondary p-3 mb-4 rounded-3">
            <div class="row align-items-center">
                <div class="col-md-7">
                    <h4 class="text-white fw-bold mb-1 movie-title" data-original-title="${showtime.movie.title}">${showtime.movie.title}</h4>
                    <div class="text-muted small">
                        <span><i class="fa-solid fa-door-open me-1"></i><span class="room-name" data-original-room="${room.roomName}">${room.roomName}</span> (${room.roomType})</span>
                        <span class="mx-2">•</span>
                        <span><i class="fa-regular fa-calendar me-1"></i><fmt:formatDate value="${showtime.showDate}" pattern="dd/MM/yyyy"/></span>
                        <span class="mx-2">•</span>
                        <span><i class="fa-regular fa-clock me-1"></i><fmt:formatDate value="${showtime.startTime}" pattern="HH:mm"/> ~ <fmt:formatDate value="${showtime.endTime}" pattern="HH:mm"/></span>
                    </div>
                </div>
                <div class="col-md-5 text-md-end mt-2 mt-md-0">
                    <span class="badge bg-danger fs-6">${showtime.movie.ageRating}</span>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Seat Matrix Map -->
            <div class="col-lg-8">
                <div class="card bg-dark border-secondary p-4 rounded-4 text-center">
                    <!-- Screen visual -->
                    <div class="screen-area">
                        <div class="screen-bar"></div>
                        <div class="screen-label" data-i18n="seatSelection.screen">MÀN HÌNH</div>
                    </div>

                    <!-- Seats Grid -->
                    <div class="seat-map-wrapper">
                        <div class="seat-grid">
                        <c:set var="currentRow" value="" />
                        <c:forEach items="${seats}" var="seat" varStatus="loop">
                            <c:if test="${seat.seatRow ne currentRow}">
                                <c:if test="${not loop.first}">
                                    </div> <!-- close previous row -->
                                </c:if>
                                <c:set var="currentRow" value="${seat.seatRow}" />
                                <div class="seat-row">
                                    <span class="seat-row-label">${seat.seatRow}</span>
                            </c:if>

                            <button type="button" 
                                    class="seat-btn ${seat.seatType.toLowerCase()} ${seat.booked ? 'booked' : ''}" 
                                    data-seat-id="${seat.seatId}"
                                    data-seat-code="${seat.seatCode}"
                                    data-price="${showtime.basePrice + seat.priceModifier}"
                                    ${seat.booked ? 'disabled' : ''}>
                                ${seat.seatCode}
                            </button>
                        </c:forEach>
                        </div> <!-- close last row -->
                    </div>
                    </div>

                    <!-- Legend -->
                    <div class="d-flex flex-wrap justify-content-center gap-3 pt-3 border-top border-secondary text-light small">
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn standard" style="width: 20px; height: 20px; font-size: 0;"></span> <span data-i18n="seatSelection.standardSeat">Ghế Thường</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn vip" style="width: 20px; height: 20px; font-size: 0;"></span> <span data-i18n="seatSelection.vipSeat">Ghế VIP (+15k)</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn couple" style="width: 32px; height: 20px; font-size: 0;"></span> <span data-i18n="seatSelection.coupleSeat">Ghế Đôi (+30k)</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn selected" style="width: 20px; height: 20px; font-size: 0;"></span> <span data-i18n="seatSelection.selecting">Đang Chọn</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn booked" style="width: 20px; height: 20px; font-size: 0;"></span> <span data-i18n="seatSelection.sold">Đã Bán</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Summary & Checkout Form -->
            <div class="col-lg-4">
                <div class="card bg-dark border-secondary p-4 rounded-4 shadow sticky-top" style="top: 80px;">
                    <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2" data-i18n="seatSelection.bookingInfo">THÔNG TIN ĐẶT VÉ</h5>

                    <div class="mb-3">
                        <small class="text-muted d-block" data-i18n="seatSelection.movie">Phim:</small>
                        <strong class="text-white movie-title" data-original-title="${showtime.movie.title}">${showtime.movie.title}</strong>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block" data-i18n="seatSelection.roomShowtime">Rạp & Suất chiếu:</small>
                        <span class="text-white"><span class="room-name" data-original-room="${room.roomName}">${room.roomName}</span> | <fmt:formatDate value="${showtime.startTime}" pattern="HH:mm"/> <span data-i18n="seatSelection.date">ngày</span> <fmt:formatDate value="${showtime.showDate}" pattern="dd/MM/yyyy"/></span>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block" data-i18n="seatSelection.selectedSeats">Ghế đã chọn:</small>
                        <span id="selectedSeatCodes" class="text-warning fw-bold" data-i18n="seatSelection.noSeatSelected">Chưa chọn ghế</span>
                    </div>

                    <hr class="border-secondary">

                    <form action="${pageContext.request.contextPath}/checkout" method="POST">
                        <input type="hidden" name="showtimeId" value="${showtime.showtimeId}">
                        <input type="hidden" name="selectedSeats" id="selectedSeatsInput">

                        <div class="mb-3">
                            <label class="form-label text-white small" data-i18n="seatSelection.paymentMethod">Phương thức thanh toán:</label>
                            <select class="form-select form-select-sm" name="paymentMethod">
                                <option value="VNPAY" data-i18n="seatSelection.vnpay">Cổng VNPAY (Thẻ ATM / QR Pay)</option>
                                <option value="MOMO" data-i18n="seatSelection.momo">Ví Điện Tử MoMo</option>
                                <option value="CASH" data-i18n="seatSelection.cash">Thanh toán tại quầy</option>
                            </select>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="text-white fw-bold" data-i18n="seatSelection.total">Tổng Tiền:</span>
                            <span id="totalPrice" class="fs-4 fw-bold text-danger">0 đ</span>
                        </div>

                        <button type="submit" id="checkoutBtn" class="btn btn-danger w-100 py-2 fw-bold" disabled data-i18n="seatSelection.proceed">
                            Tiến Hành Thanh Toán
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>