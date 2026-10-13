<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${movie.title} - Chi Tiết Phim CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="${movie.title} - Chi Tiết Phim CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5">
    <div class="container">
        <!-- Movie Header & Details -->
        <div class="row g-4 mb-5">
            <div class="col-md-4 col-lg-3 text-center text-md-start">
                <div class="rounded-4 overflow-hidden border border-secondary shadow movie-detail-poster d-inline-block">
                    <img src="${movie.posterUrl}" alt="${movie.title}" class="img-fluid w-100" onerror="this.src='https://placehold.co/400x600/222/fff?text=Poster'">
                </div>
            </div>
            <div class="col-md-8 col-lg-9">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-danger fs-6">${movie.ageRating}</span>
                    <span class="badge bg-secondary fs-6">${movie.status == 'NOW_SHOWING' ? 'Đang Chiếu' : 'Sắp Chiếu'}</span>
                </div>
                <h1 class="display-6 fw-bold text-white mb-3 movie-detail-title">${movie.title}</h1>

                <ul class="list-unstyled text-light mb-4">
                    <li class="mb-2"><strong class="text-secondary">Thể loại:</strong> ${movie.genre}</li>
                    <li class="mb-2"><strong class="text-secondary">Thời lượng:</strong> ${movie.duration} phút</li>
                    <li class="mb-2"><strong class="text-secondary">Đạo diễn:</strong> ${movie.director}</li>
                    <li class="mb-2"><strong class="text-secondary">Diễn viên:</strong> ${movie.cast}</li>
                    <li class="mb-2"><strong class="text-secondary">Khởi chiếu:</strong> <fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/></li>
                </ul>

                <h5 class="fw-bold text-white mb-2">Nội dung phim:</h5>
                <p class="text-light lead fs-6 mb-4" style="line-height: 1.8;">${movie.description}</p>

                <c:if test="${not empty movie.trailerUrl}">
                    <a href="${movie.trailerUrl}" target="_blank" class="btn btn-outline-danger fw-bold rounded-pill px-4">
                        <i class="fa-brands fa-youtube me-2"></i>Xem Trailer
                    </a>
                </c:if>
            </div>
        </div>

        <!-- Showtimes Schedule -->
        <section class="card bg-dark border-secondary p-4 rounded-4 shadow">
            <div class="d-flex align-items-center gap-2 mb-4">
                <span class="bg-danger d-inline-block rounded" style="width: 6px; height: 26px;"></span>
                <h3 class="h4 fw-bold text-white mb-0">LỊCH CHIẾU VÀ ĐẶT VÉ</h3>
            </div>

            <c:choose>
                <c:when test="${empty showtimes}">
                    <div class="text-center py-4 text-muted">
                        <i class="fa-solid fa-calendar-xmark fs-2 mb-2"></i>
                        <p class="mb-0">Hiện tại chưa có suất chiếu nào mở bán cho bộ phim này.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-3">
                        <c:forEach items="${showtimes}" var="st">
                            <div class="col">
                                <div class="p-3 rounded-3 border border-secondary showtime-box" style="background-color: #242424;">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="badge bg-secondary">${st.room.roomName}</span>
                                        <span class="badge bg-danger">${st.room.roomType}</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            <div class="fs-4 fw-bold text-warning">
                                                <fmt:formatDate value="${st.startTime}" pattern="HH:mm"/>
                                            </div>
                                            <small class="text-muted">Ngày: <fmt:formatDate value="${st.showDate}" pattern="dd/MM/yyyy"/></small>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-white">
                                                <fmt:formatNumber value="${st.basePrice}" type="number" groupingUsed="true"/> đ
                                            </div>
                                            <small class="text-muted">Giá từ</small>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/seat-selection?showtimeId=${st.showtimeId}" class="btn btn-danger btn-sm w-100 fw-bold">
                                        Chọn Ghế
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
