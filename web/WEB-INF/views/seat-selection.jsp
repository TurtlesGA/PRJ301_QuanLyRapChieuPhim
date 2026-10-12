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
                    <h4 class="text-white fw-bold mb-1">${showtime.movie.title}</h4>
                    <div class="text-muted small">
                        <span><i class="fa-solid fa-door-open me-1"></i>${room.roomName} (${room.roomType})</span>
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
                        <div class="screen-label">MÀN HÌNH</div>
                    </div>

                    <!-- Seats Grid -->
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

                    <!-- Legend -->
                    <div class="d-flex flex-wrap justify-content-center gap-3 pt-3 border-top border-secondary text-light small">
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn standard" style="width: 20px; height: 20px; font-size: 0;"></span> Ghế Thường
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn vip" style="width: 20px; height: 20px; font-size: 0;"></span> Ghế VIP (+15k)
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn couple" style="width: 32px; height: 20px; font-size: 0;"></span> Ghế Đôi (+30k)
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn selected" style="width: 20px; height: 20px; font-size: 0;"></span> Đang Chọn
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="seat-btn booked" style="width: 20px; height: 20px; font-size: 0;"></span> Đã Bán
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Summary & Checkout Form -->
            <div class="col-lg-4">
                <div class="card bg-dark border-secondary p-4 rounded-4 shadow sticky-top" style="top: 80px;">
                    <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2">THÔNG TIN ĐẶT VÉ</h5>

                    <div class="mb-3">
                        <small class="text-muted d-block">Phim:</small>
                        <strong class="text-white">${showtime.movie.title}</strong>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block">Rạp & Suất chiếu:</small>
                        <span class="text-white">${room.roomName} | <fmt:formatDate value="${showtime.startTime}" pattern="HH:mm"/> ngày <fmt:formatDate value="${showtime.showDate}" pattern="dd/MM/yyyy"/></span>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block">Ghế đã chọn:</small>
                        <span id="selectedSeatCodes" class="text-warning fw-bold">Chưa chọn ghế</span>
                    </div>

                    <hr class="border-secondary">

                    <form action="${pageContext.request.contextPath}/checkout" method="POST">
                        <input type="hidden" name="showtimeId" value="${showtime.showtimeId}">
                        <input type="hidden" name="selectedSeats" id="selectedSeatsInput">

                        <div class="mb-3">
                            <label class="form-label text-white small">Phương thức thanh toán:</label>
                            <select class="form-select form-select-sm" name="paymentMethod">
                                <option value="VNPAY">Cổng VNPAY (Thẻ ATM / QR Pay)</option>
                                <option value="MOMO">Ví Điện Tử MoMo</option>
                                <option value="CASH">Thanh toán tại quầy</option>
                            </select>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="text-white fw-bold">Tổng Tiền:</span>
                            <span id="totalPrice" class="fs-4 fw-bold text-danger">0 đ</span>
                        </div>

                        <button type="submit" id="checkoutBtn" class="btn btn-danger w-100 py-2 fw-bold" disabled>
                            Tiến Hành Thanh Toán
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
