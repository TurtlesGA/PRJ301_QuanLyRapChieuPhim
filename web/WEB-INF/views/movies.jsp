<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Danh Sách Phim - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Danh Sách Phim - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5">
    <div class="container">
        <!-- Filter Tabs -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom border-secondary gap-3">
            <h2 class="h3 fw-bold text-white mb-0">
                <c:choose>
                    <c:when test="${not empty searchKeyword}">Kết quả tìm kiếm cho: "${searchKeyword}"</c:when>
                    <c:when test="${activeFilter == 'now'}">Phim Đang Chiếu</c:when>
                    <c:when test="${activeFilter == 'soon'}">Phim Sắp Chiếu</c:when>
                    <c:otherwise>Tất Cả Phim</c:otherwise>
                </c:choose>
            </h2>

            <div class="btn-group filter-btn-group" role="group">
                <a href="${pageContext.request.contextPath}/movies" class="btn btn-sm ${activeFilter == 'all' || empty activeFilter ? 'btn-danger' : 'btn-outline-secondary'}">Tất Cả</a>
                <a href="${pageContext.request.contextPath}/movies?filter=now" class="btn btn-sm ${activeFilter == 'now' ? 'btn-danger' : 'btn-outline-secondary'}">Đang Chiếu</a>
                <a href="${pageContext.request.contextPath}/movies?filter=soon" class="btn btn-sm ${activeFilter == 'soon' ? 'btn-danger' : 'btn-outline-secondary'}">Sắp Chiếu</a>
            </div>
        </div>

        <!-- Movie List Grid -->
        <c:choose>
            <c:when test="${empty movies}">
                <div class="text-center py-5">
                    <i class="fa-solid fa-film fs-1 text-secondary mb-3"></i>
                    <h5 class="text-white">Không tìm thấy bộ phim nào phù hợp!</h5>
                    <p class="text-muted">Vui lòng thử lại với từ khóa hoặc bộ lọc khác.</p>
                    <a href="${pageContext.request.contextPath}/movies" class="btn btn-danger mt-2">Xem Tất Cả Phim</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-2 g-sm-3 g-md-4">
                    <c:forEach items="${movies}" var="movie">
                        <div class="col">
                            <div class="movie-card position-relative">
                                <div class="movie-poster-wrapper">
                                    <img src="${movie.posterUrl}" alt="${movie.title}" class="movie-poster" onerror="this.src='https://placehold.co/400x600/222/fff?text=Poster'">
                                    <span class="movie-badge ${movie.status == 'NOW_SHOWING' ? 'bg-danger' : 'bg-warning text-dark'}">
                                        ${movie.status == 'NOW_SHOWING' ? movie.ageRating : 'Sắp chiếu'}
                                    </span>
                                </div>
                                <div class="movie-info">
                                    <div>
                                        <h5 class="movie-title" title="${movie.title}">${movie.title}</h5>
                                        <p class="small text-muted mb-1"><i class="fa-solid fa-tags me-1"></i>${movie.genre}</p>
                                        <p class="small text-muted mb-3"><i class="fa-regular fa-clock me-1"></i>${movie.duration} phút</p>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/movie-detail?id=${movie.movieId}" class="btn btn-sm btn-outline-danger fw-bold stretched-link">
                                            ${movie.status == 'NOW_SHOWING' ? 'Mua Vé' : 'Xem Chi Tiết'}
                                        </a>
                                    </div>
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
