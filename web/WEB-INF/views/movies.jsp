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
        <div class="card bg-dark border-secondary p-3 mb-4 rounded-4 shadow-sm">
            <form action="${pageContext.request.contextPath}/movies" method="GET" class="row g-2 align-items-center">
                <div class="col-12 col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-black border-secondary text-secondary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </span>
                        <input type="text" class="form-control bg-black text-white border-secondary" name="q" value="${searchKeyword}" placeholder="Tìm theo tên phim, diễn viên, đạo diễn...">
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <select class="form-select bg-black text-white border-secondary" name="genre">
                        <option value="" ${empty selectedGenre ? 'selected' : ''}>Tất cả thể loại</option>
                        <c:forEach items="${genres}" var="g">
                            <option value="${g}" ${selectedGenre == g ? 'selected' : ''}>${g}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-6 col-md-2">
                    <select class="form-select bg-black text-white border-secondary" name="filter">
                        <option value="all" ${activeFilter == 'all' || empty activeFilter ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="now" ${activeFilter == 'now' ? 'selected' : ''}>Đang chiếu</option>
                        <option value="soon" ${activeFilter == 'soon' ? 'selected' : ''}>Sắp chiếu</option>
                    </select>
                </div>

                <div class="col-12 col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-danger fw-bold flex-grow-1">
                        <i class="fa-solid fa-filter me-1"></i>Lọc
                    </button>
                    <c:if test="${not empty searchKeyword or not empty selectedGenre or (not empty activeFilter and activeFilter != 'all')}">
                        <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-secondary" title="Đặt lại bộ lọc">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    </c:if>
                </div>
            </form>
        </div>

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom border-secondary gap-3">
            <h2 class="h4 fw-bold text-white mb-0">
                <c:choose>
                    <c:when test="${not empty searchKeyword}">
                        <span data-i18n="movies.searchResult">Kết quả tìm kiếm cho:</span> "${searchKeyword}"
                        <c:if test="${not empty selectedGenre}"> • ${selectedGenre}</c:if>
                    </c:when>
                    <c:when test="${not empty selectedGenre}">
                        <span>Thể loại:</span> ${selectedGenre}
                        <c:if test="${activeFilter == 'now'}"> (Đang Chiếu)</c:if>
                        <c:if test="${activeFilter == 'soon'}"> (Sắp Chiếu)</c:if>
                    </c:when>
                    <c:when test="${activeFilter == 'now'}"><span data-i18n="movies.nowShowing">Phim Đang Chiếu</span></c:when>
                    <c:when test="${activeFilter == 'soon'}"><span data-i18n="movies.comingSoon">Phim Sắp Chiếu</span></c:when>
                    <c:otherwise><span data-i18n="movies.allMovies">Tất Cả Phim</span></c:otherwise>
                </c:choose>
            </h2>

            <div class="d-flex align-items-center gap-2">
                <span class="text-secondary small">Tìm thấy <span class="fw-bold text-danger">${movies.size()}</span> phim</span>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty movies}">
                <div class="text-center py-5">
                    <i class="fa-solid fa-film fs-1 text-secondary mb-3"></i>
                    <h5 class="text-white" data-i18n="movies.noMovies">Không tìm thấy bộ phim nào phù hợp!</h5>
                    <p class="text-muted" data-i18n="movies.noMoviesHint">Vui lòng thử lại với từ khóa hoặc bộ lọc khác.</p>
                    <a href="${pageContext.request.contextPath}/movies" class="btn btn-danger mt-2" data-i18n="movies.viewAll">Xem Tất Cả Phim</a>
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
                                        <c:choose>
                                            <c:when test="${movie.status == 'NOW_SHOWING'}">${movie.ageRating}</c:when>
                                            <c:otherwise><span data-i18n="movies.comingSoonBadge">Sắp chiếu</span></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="movie-info">
                                    <div>
                                        <h5 class="movie-title" data-original-title="${movie.title}" title="${movie.title}"<c:forEach items="${movie.translations}" var="t"> data-title-${t.key}="<c:out value="${t.value.title}"/>"</c:forEach>>${not empty movie.translations[currentLang] and not empty movie.translations[currentLang].title ? movie.translations[currentLang].title : movie.title}</h5>
                                        <p class="small text-muted mb-1"><i class="fa-solid fa-tags me-1"></i><span class="movie-genre" data-original-genre="${movie.genre}"<c:forEach items="${movie.translations}" var="t"> data-genre-${t.key}="<c:out value="${t.value.genre}"/>"</c:forEach>>${not empty movie.translations[currentLang] and not empty movie.translations[currentLang].genre ? movie.translations[currentLang].genre : movie.genre}</span></p>
                                        <p class="small text-muted mb-3"><i class="fa-regular fa-clock me-1"></i>${movie.duration} <span data-i18n="movies.minutes">phút</span></p>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/movie-detail?id=${movie.movieId}" class="btn btn-sm btn-outline-danger fw-bold stretched-link">
                                            <c:choose>
                                                <c:when test="${movie.status == 'NOW_SHOWING'}"><span data-i18n="movies.buyTicket">Mua Vé</span></c:when>
                                                <c:otherwise><span data-i18n="movies.viewDetails">Xem Chi Tiết</span></c:otherwise>
                                            </c:choose>
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
