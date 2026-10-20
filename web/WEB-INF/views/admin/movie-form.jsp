<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${movie != null ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới'} - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="${movie != null ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới'} - CineStar Admin"/>
    <jsp:param name="activeMenu" value="movies"/>
</jsp:include>

            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">
                    <span data-i18n="${movie != null ? 'admin.movieForm.editTitle' : 'admin.movieForm.addTitle'}">${movie != null ? 'CHỈNH SỬA PHIM' : 'THÊM PHIM MỚI'}</span>
                </h2>
                <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-admin-back btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="admin.movieForm.back">Quay Lại</span>
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <form action="${pageContext.request.contextPath}/admin/movies" method="POST">
                    <c:if test="${movie != null}">
                        <input type="hidden" name="movieId" value="${movie.movieId}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.title">Tên phim *</label>
                            <input type="text" class="form-control" name="title" value="${movie.title}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.genre">Thể loại *</label>
                            <input type="text" class="form-control" name="genre" value="${movie.genre}" data-i18n-placeholder="admin.movieForm.genrePlaceholder" placeholder="Hành Động, Hài Hước..." required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.duration">Thời lượng (phút) *</label>
                            <input type="number" class="form-control" name="duration" value="${movie.duration != null ? movie.duration : 120}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.releaseDate">Ngày khởi chiếu *</label>
                            <input type="date" class="form-control" name="releaseDate" value="${movie.releaseDate}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.endDate">Ngày kết thúc</label>
                            <input type="date" class="form-control" name="endDate" value="${movie.endDate}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.ageRating">Giới hạn tuổi</label>
                            <select class="form-select" name="ageRating">
                                <option value="P" ${movie.ageRating == 'P' ? 'selected' : ''} data-i18n="ageRating.P">P - Mọi lứa tuổi</option>
                                <option value="K" ${movie.ageRating == 'K' ? 'selected' : ''} data-i18n="ageRating.K">K - Dưới 13 tuổi xem cùng phụ huynh</option>
                                <option value="T13" ${movie.ageRating == 'T13' ? 'selected' : ''} data-i18n="ageRating.T13">T13 - Khán giả từ 13 tuổi</option>
                                <option value="T16" ${movie.ageRating == 'T16' ? 'selected' : ''} data-i18n="ageRating.T16">T16 - Khán giả từ 16 tuổi</option>
                                <option value="T18" ${movie.ageRating == 'T18' ? 'selected' : ''} data-i18n="ageRating.T18">T18 - Khán giả từ 18 tuổi</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.director">Đạo diễn</label>
                            <input type="text" class="form-control" name="director" value="${movie.director}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.cast">Diễn viên</label>
                            <input type="text" class="form-control" name="cast" value="${movie.cast}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.posterUrl">Poster URL (Link ảnh)</label>
                            <input type="url" class="form-control" name="posterUrl" value="${movie.posterUrl}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.trailerUrl">Trailer URL (YouTube link)</label>
                            <input type="url" class="form-control" name="trailerUrl" value="${movie.trailerUrl}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.status">Trạng thái phim</label>
                            <select class="form-select" name="status">
                                <option value="NOW_SHOWING" ${movie.status == 'NOW_SHOWING' ? 'selected' : ''} data-i18n="movieStatus.NOW_SHOWING">Đang chiếu</option>
                                <option value="COMING_SOON" ${movie.status == 'COMING_SOON' ? 'selected' : ''} data-i18n="movieStatus.COMING_SOON">Sắp chiếu</option>
                                <option value="STOPPED" ${movie.status == 'STOPPED' ? 'selected' : ''} data-i18n="movieStatus.STOPPED">Ngừng chiếu</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label text-light small" data-i18n="admin.movieForm.description">Mô tả tóm tắt nội dung</label>
                            <textarea class="form-control" name="description" rows="4">${movie.description}</textarea>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top border-secondary text-end">
                            <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-admin-back me-2" data-i18n="admin.movieForm.cancel">Hủy Bỏ</a>
                            <button type="submit" class="btn btn-danger fw-bold px-4 py-2">
                                <i class="fa-solid fa-save me-1"></i><span data-i18n="admin.movieForm.save">Lưu Thông Tin Phim</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
<jsp:include page="common/admin-footer.jsp"/>