<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="CineStar - Trang Chủ Đặt Vé Phim" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="CineStar - Trang Chủ Đặt Vé Phim"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<!-- Hero Carousel -->
<div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner" style="max-height: 480px;">
        <div class="carousel-item active">
            <div class="position-relative hero-slide" style="height: 480px; background: linear-gradient(to right, rgba(0,0,0,0.85) 40%, rgba(0,0,0,0.3)), url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=1600') center/cover no-repeat;">
                <div class="container h-100 d-flex align-items-center">
                    <div class="col-lg-6 col-md-8 col-12 text-white">
                        <span class="badge bg-danger mb-2 px-3 py-2 fs-6">BOM TẤN HOT</span>
                        <h1 class="display-4 fw-bold hero-title">Phim Chiếu Rạp Đỉnh Cao</h1>
                        <p class="lead text-light mb-4 hero-lead">Trải nghiệm hệ thống âm thanh Dolby Atmos và màn hình IMAX đỉnh cao ngay hôm nay.</p>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="${pageContext.request.contextPath}/movies?filter=now" class="btn btn-danger btn-lg px-4 rounded-pill fw-bold hero-btn">Đặt Vé Ngay</a>
                            <a href="#now-showing" class="btn btn-outline-light btn-lg px-4 rounded-pill fw-bold hero-btn">Xem Lịch Chiếu</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="carousel-item">
            <div class="position-relative hero-slide" style="height: 480px; background: linear-gradient(to right, rgba(0,0,0,0.85) 40%, rgba(0,0,0,0.3)), url('https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600') center/cover no-repeat;">
                <div class="container h-100 d-flex align-items-center">
                    <div class="col-lg-6 col-md-8 col-12 text-white">
                        <span class="badge bg-warning text-dark mb-2 px-3 py-2 fs-6">KHOA HỌC VIỄN TƯỞNG</span>
                        <h1 class="display-4 fw-bold hero-title">Dune: Hành Tinh Cát 2</h1>
                        <p class="lead text-light mb-4 hero-lead">Siêu phẩm điện ảnh đoạt nhiều giải thưởng danh giá. Khởi chiếu toàn quốc.</p>
                        <a href="${pageContext.request.contextPath}/movie-detail?id=2" class="btn btn-danger btn-lg px-4 rounded-pill fw-bold hero-btn">Chi Tiết & Mua Vé</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="carousel-item">
            <div class="position-relative hero-slide" style="height: 480px; background: linear-gradient(to right, rgba(0,0,0,0.85) 40%, rgba(0,0,0,0.3)), url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1600') center/cover no-repeat;">
                <div class="container h-100 d-flex align-items-center">
                    <div class="col-lg-6 col-md-8 col-12 text-white">
                        <span class="badge bg-info text-dark mb-2 px-3 py-2 fs-6">SẮP KHỞI CHIẾU</span>
                        <h1 class="display-4 fw-bold hero-title">Lật Mặt 7: Một Điều Ước</h1>
                        <p class="lead text-light mb-4 hero-lead">Câu chuyện gia đình xúc động lấy đi nước mắt hàng triệu khán giả Việt.</p>
                        <a href="${pageContext.request.contextPath}/movies?filter=soon" class="btn btn-danger btn-lg px-4 rounded-pill fw-bold hero-btn">Khám Phá Thêm</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<!-- Main Content -->
<main class="main-content py-5">
    <div class="container">
        
        <!-- Phim Đang Chiếu -->
        <section id="now-showing" class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex align-items-center gap-2">
                    <span class="bg-danger d-inline-block rounded" style="width: 6px; height: 28px;"></span>
                    <h2 class="h3 fw-bold text-white mb-0">PHIM ĐANG CHIẾU</h2>
                </div>
                <a href="${pageContext.request.contextPath}/movies?filter=now" class="text-danger text-decoration-none fw-bold">Xem tất cả <i class="fa-solid fa-angle-right"></i></a>
            </div>

            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-2 g-sm-3 g-md-4">
                <c:forEach items="${nowShowing}" var="movie">
                    <div class="col">
                        <div class="movie-card position-relative">
                            <div class="movie-poster-wrapper">
                                <img src="${movie.posterUrl}" alt="${movie.title}" class="movie-poster" onerror="this.src='https://placehold.co/400x600/222/fff?text=Poster'">
                                <span class="movie-badge bg-danger">${movie.ageRating}</span>
                            </div>
                            <div class="movie-info">
                                <div>
                                    <h5 class="movie-title" title="${movie.title}">${movie.title}</h5>
                                    <p class="small text-muted mb-1"><i class="fa-solid fa-tags me-1"></i>${movie.genre}</p>
                                    <p class="small text-muted mb-3"><i class="fa-regular fa-clock me-1"></i>${movie.duration} phút</p>
                                </div>
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/movie-detail?id=${movie.movieId}" class="btn btn-sm btn-outline-danger fw-bold stretched-link">Mua Vé</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Phim Sắp Chiếu -->
        <section id="coming-soon" class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex align-items-center gap-2">
                    <span class="bg-warning d-inline-block rounded" style="width: 6px; height: 28px;"></span>
                    <h2 class="h3 fw-bold text-white mb-0">PHIM SẮP CHIẾU</h2>
                </div>
                <a href="${pageContext.request.contextPath}/movies?filter=soon" class="text-warning text-decoration-none fw-bold">Xem tất cả <i class="fa-solid fa-angle-right"></i></a>
            </div>

            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-2 g-sm-3 g-md-4">
                <c:forEach items="${comingSoon}" var="movie">
                    <div class="col">
                        <div class="movie-card position-relative">
                            <div class="movie-poster-wrapper">
                                <img src="${movie.posterUrl}" alt="${movie.title}" class="movie-poster" onerror="this.src='https://placehold.co/400x600/222/fff?text=Poster'">
                                <span class="movie-badge bg-warning text-dark">Khởi chiếu: <fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM"/></span>
                            </div>
                            <div class="movie-info">
                                <div>
                                    <h5 class="movie-title" title="${movie.title}">${movie.title}</h5>
                                    <p class="small text-muted mb-1"><i class="fa-solid fa-tags me-1"></i>${movie.genre}</p>
                                    <p class="small text-muted mb-3"><i class="fa-regular fa-clock me-1"></i>${movie.duration} phút</p>
                                </div>
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/movie-detail?id=${movie.movieId}" class="btn btn-sm btn-movie-detail fw-bold stretched-link">Chi Tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Tiện Ích Rạp -->
        <section class="cinema-features p-4 p-md-5 rounded-4 border">
            <div class="row g-4 text-center">
                <div class="col-md-3 col-6">
                    <i class="fa-solid fa-tv text-danger fs-1 mb-3"></i>
                    <h5 class="fw-bold feature-title">Màn Hình Siêu Lớn</h5>
                    <p class="small text-muted mb-0">Hệ thống chiếu Laser 4K sắc nét tới từng chi tiết</p>
                </div>
                <div class="col-md-3 col-6">
                    <i class="fa-solid fa-volume-high text-danger fs-1 mb-3"></i>
                    <h5 class="fw-bold feature-title">Âm Thanh Dolby Atmos</h5>
                    <p class="small text-muted mb-0">Âm thanh vòm đa chiều bao trùm không gian</p>
                </div>
                <div class="col-md-3 col-6">
                    <i class="fa-solid fa-couch text-danger fs-1 mb-3"></i>
                    <h5 class="fw-bold feature-title">Ghế VIP & Couple</h5>
                    <p class="small text-muted mb-0">Ghế da bọc êm ái, khoảng cách thoải mái</p>
                </div>
                <div class="col-md-3 col-6">
                    <i class="fa-solid fa-mobile-screen-button text-danger fs-1 mb-3"></i>
                    <h5 class="fw-bold feature-title">Đặt Vé Nhanh Chóng</h5>
                    <p class="small text-muted mb-0">Thanh toán tiện lợi, quét mã QR vào rạp</p>
                </div>
            </div>
        </section>

    </div>
</main>

<jsp:include page="common/footer.jsp"/>
