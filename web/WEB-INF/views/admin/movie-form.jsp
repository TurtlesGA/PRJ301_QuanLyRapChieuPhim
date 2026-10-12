<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${movie != null ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới'} - CineStar Admin" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="${movie != null ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới'} - CineStar Admin"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block admin-sidebar p-3">
            <h6 class="text-uppercase text-muted fw-bold px-3 mb-3 small">Hệ Thống Quản Trị</h6>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-pie me-2"></i>Tổng Quan</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/movies"><i class="fa-solid fa-film me-2"></i>Quản Lý Phim</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/showtimes"><i class="fa-solid fa-clock me-2"></i>Quản Lý Suất Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-receipt me-2"></i>Lịch Sử Đặt Vé</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2"></i>Người Dùng</a>
                </li>
            </ul>
        </nav>

        <!-- Form Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">${movie != null ? 'CHỈNH SỬA PHIM' : 'THÊM PHIM MỚI'}</h2>
                <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-outline-secondary text-white btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>Quay Lại
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <form action="${pageContext.request.contextPath}/admin/movies" method="POST">
                    <c:if test="${movie != null}">
                        <input type="hidden" name="movieId" value="${movie.movieId}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label text-light small">Tên phim *</label>
                            <input type="text" class="form-control" name="title" value="${movie.title}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-light small">Thể loại *</label>
                            <input type="text" class="form-control" name="genre" value="${movie.genre}" placeholder="Hành Động, Hài Hước..." required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label text-light small">Thời lượng (phút) *</label>
                            <input type="number" class="form-control" name="duration" value="${movie.duration != null ? movie.duration : 120}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small">Ngày khởi chiếu *</label>
                            <input type="date" class="form-control" name="releaseDate" value="${movie.releaseDate}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small">Ngày kết thúc</label>
                            <input type="date" class="form-control" name="endDate" value="${movie.endDate}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small">Giới hạn tuổi</label>
                            <select class="form-select" name="ageRating">
                                <option value="P" ${movie.ageRating == 'P' ? 'selected' : ''}>P - Mọi lứa tuổi</option>
                                <option value="K" ${movie.ageRating == 'K' ? 'selected' : ''}>K - Dưới 13 tuổi xem cùng phụ huynh</option>
                                <option value="T13" ${movie.ageRating == 'T13' ? 'selected' : ''}>T13 - Khán giả từ 13 tuổi</option>
                                <option value="T16" ${movie.ageRating == 'T16' ? 'selected' : ''}>T16 - Khán giả từ 16 tuổi</option>
                                <option value="T18" ${movie.ageRating == 'T18' ? 'selected' : ''}>T18 - Khán giả từ 18 tuổi</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Đạo diễn</label>
                            <input type="text" class="form-control" name="director" value="${movie.director}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-light small">Diễn viên</label>
                            <input type="text" class="form-control" name="cast" value="${movie.cast}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Poster URL (Link ảnh)</label>
                            <input type="url" class="form-control" name="posterUrl" value="${movie.posterUrl}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-light small">Trailer URL (YouTube link)</label>
                            <input type="url" class="form-control" name="trailerUrl" value="${movie.trailerUrl}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small">Trạng thái phim</label>
                            <select class="form-select" name="status">
                                <option value="NOW_SHOWING" ${movie.status == 'NOW_SHOWING' ? 'selected' : ''}>Đang chiếu (NOW_SHOWING)</option>
                                <option value="COMING_SOON" ${movie.status == 'COMING_SOON' ? 'selected' : ''}>Sắp chiếu (COMING_SOON)</option>
                                <option value="STOPPED" ${movie.status == 'STOPPED' ? 'selected' : ''}>Ngừng chiếu (STOPPED)</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label text-light small">Mô tả tóm tắt nội dung</label>
                            <textarea class="form-control" name="description" rows="4">${movie.description}</textarea>
                        </div>

                        <div class="col-12 mt-4">
                            <button type="submit" class="btn btn-danger fw-bold px-4 py-2">
                                <i class="fa-solid fa-save me-1"></i>Lưu Thông Tin Phim
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
