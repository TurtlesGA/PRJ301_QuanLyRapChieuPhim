<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Vé Của Tôi - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Vé Của Tôi - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5">
    <div class="container">
        <div class="d-flex align-items-center gap-2 mb-4">
            <span class="bg-danger d-inline-block rounded" style="width: 6px; height: 26px;"></span>
            <h2 class="h4 fw-bold text-white mb-0">LỊCH SỬ ĐẶT VÉ CỦA BẠN</h2>
        </div>

        <c:choose>
            <c:when test="${empty myBookings}">
                <div class="card bg-dark border-secondary p-5 text-center rounded-4">
                    <i class="fa-solid fa-ticket-simple fs-1 text-secondary mb-3"></i>
                    <h5 class="text-white">Bạn chưa có đơn đặt vé nào!</h5>
                    <p class="text-muted">Hãy chọn ngay một bộ phim yêu thích và trải nghiệm rạp chiếu ngay hôm nay.</p>
                    <div class="mt-2">
                        <a href="${pageContext.request.contextPath}/movies" class="btn btn-danger">Xem Phim Đang Chiếu</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach items="${myBookings}" var="b">
                        <div class="col-md-6 col-lg-4">
                            <div class="card bg-dark border-secondary rounded-4 overflow-hidden h-100 shadow">
                                <div class="card-header bg-black border-secondary d-flex justify-content-between align-items-center py-3">
                                    <span class="text-warning fw-bold">#${b.bookingCode}</span>
                                    <span class="badge ${b.paymentStatus == 'PAID' ? 'bg-success' : 'bg-secondary'}">${b.paymentStatus}</span>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title text-white fw-bold mb-2">${b.showtime.movie.title}</h5>
                                    <p class="card-text small text-muted mb-3">
                                        <i class="fa-solid fa-door-open me-1"></i>${b.showtime.room.roomName} (${b.showtime.room.roomType})
                                    </p>
                                    <div class="small text-light mb-2">
                                        <i class="fa-regular fa-calendar-check me-1 text-danger"></i>
                                        Suất chiếu: <strong><fmt:formatDate value="${b.showtime.startTime}" pattern="HH:mm"/></strong> - <fmt:formatDate value="${b.showtime.showDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                    <div class="small text-light mb-3">
                                        <i class="fa-solid fa-couch me-1 text-info"></i>
                                        Ghế: 
                                        <c:forEach items="${b.tickets}" var="t" varStatus="loop">
                                            <span class="badge bg-secondary">${t.seat.seatCode}</span>
                                        </c:forEach>
                                    </div>
                                    <div class="border-top border-secondary pt-2 d-flex justify-content-between align-items-center">
                                        <span class="small text-muted">Tổng tiền:</span>
                                        <span class="text-danger fw-bold fs-5">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> đ
                                        </span>
                                    </div>
                                </div>
                                <div class="card-footer bg-dark border-secondary text-muted small">
                                    Đặt lúc: <fmt:formatDate value="${b.bookingTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
