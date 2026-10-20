<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${movie != null ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới'} - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="${movie != null ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới'} - CineStar Admin"/>
    <jsp:param name="activeMenu" value="movies"/>
</jsp:include>

            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white mb-0">
                    <span data-i18n="${movie != null ? 'admin.movieForm.editTitle' : 'admin.movieForm.addTitle'}">${movie != null ? 'CHỈNH SỬA PHIM' : 'THÊM PHIM MỚI'}</span>
                </h2>
                <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-admin-back btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="admin.movieForm.back">Quay Lại</span>
                </a>
            </div>

            <form id="movieAdminForm" action="${pageContext.request.contextPath}/admin/movies" method="POST">
                <c:if test="${movie != null}">
                    <input type="hidden" name="movieId" value="${movie.movieId}">
                </c:if>

                <!-- SECTION 1: Cấu hình thông số kỹ thuật chung -->
                <div class="card bg-dark border-secondary rounded-4 p-4 shadow mb-4">
                    <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2">
                        <i class="fa-solid fa-film text-danger me-2"></i>Thông Tin Kỹ Thuật & Xuất Bản
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.duration">Thời lượng (phút) *</label>
                            <input type="number" class="form-control" name="duration" value="${movie.duration != null ? movie.duration : 120}" required min="1">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.releaseDate">Ngày khởi chiếu *</label>
                            <input type="date" class="form-control" name="releaseDate" value="${movie.releaseDate}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.endDate">Ngày kết thúc</label>
                            <input type="date" class="form-control" name="endDate" value="${movie.endDate}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.ageRating">Giới hạn tuổi</label>
                            <select class="form-select" name="ageRating">
                                <option value="P" ${movie.ageRating == 'P' ? 'selected' : ''} data-i18n="ageRating.P">P - Mọi lứa tuổi</option>
                                <option value="K" ${movie.ageRating == 'K' ? 'selected' : ''} data-i18n="ageRating.K">K - Dưới 13 tuổi xem cùng phụ huynh</option>
                                <option value="T13" ${movie.ageRating == 'T13' ? 'selected' : ''} data-i18n="ageRating.T13">T13 - Khán giả từ 13 tuổi</option>
                                <option value="T16" ${movie.ageRating == 'T16' ? 'selected' : ''} data-i18n="ageRating.T16">T16 - Khán giả từ 16 tuổi</option>
                                <option value="T18" ${movie.ageRating == 'T18' ? 'selected' : ''} data-i18n="ageRating.T18">T18 - Khán giả từ 18 tuổi</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.status">Trạng thái phim</label>
                            <select class="form-select" name="status">
                                <option value="NOW_SHOWING" ${movie.status == 'NOW_SHOWING' ? 'selected' : ''} data-i18n="movieStatus.NOW_SHOWING">Đang chiếu</option>
                                <option value="COMING_SOON" ${movie.status == 'COMING_SOON' ? 'selected' : ''} data-i18n="movieStatus.COMING_SOON">Sắp chiếu</option>
                                <option value="STOPPED" ${movie.status == 'STOPPED' ? 'selected' : ''} data-i18n="movieStatus.STOPPED">Ngừng chiếu</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.posterUrl">Poster URL (Link ảnh) *</label>
                            <input type="url" class="form-control" name="posterUrl" value="${movie.posterUrl}" placeholder="https://..." required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.movieForm.trailerUrl">Trailer URL (YouTube link)</label>
                            <input type="url" class="form-control" name="trailerUrl" value="${movie.trailerUrl}" placeholder="https://youtube.com/watch?v=...">
                        </div>
                    </div>
                </div>

                <!-- SECTION 2: Đa ngôn ngữ (Chọn ngôn ngữ & sửa detail phim theo từng ngôn ngữ) -->
                <div class="card bg-dark border-secondary rounded-4 p-4 shadow mb-4">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2 mb-3 border-bottom border-secondary pb-3">
                        <div>
                            <h5 class="fw-bold text-white mb-1">
                                <i class="fa-solid fa-language text-warning me-2"></i>Nội Dung Phim Đa Ngôn Ngữ (Database)
                            </h5>
                            <p class="small text-muted mb-0">Chọn các ngôn ngữ bộ phim này sẽ hỗ trợ. Dữ liệu dịch chi tiết sẽ được lưu trực tiếp vào cơ sở dữ liệu.</p>
                        </div>
                    </div>

                    <!-- Danh sách Checkbox chọn ngôn ngữ hỗ trợ -->
                    <div class="p-3 rounded-3 mb-4" style="background-color: #1a1a1a; border: 1px dashed #444;">
                        <label class="form-label text-warning small fw-bold text-uppercase mb-2 d-block">
                            <i class="fa-solid fa-check-double me-1"></i>Ngôn Ngữ Kích Hoạt Cho Bộ Phim Này:
                        </label>
                        <div class="d-flex flex-wrap gap-3">
                            <c:forEach items="${activeLanguages}" var="lang">
                                <c:set var="codeLower" value="${lang.langCode.toLowerCase()}" />
                                <c:set var="isSelected" value="${movie == null ? (codeLower == 'vi' || codeLower == 'en') : (movie.translations[codeLower] != null || (empty movie.translations && codeLower == 'vi'))}" />
                                <div class="form-check form-check-inline m-0">
                                    <input class="form-check-input lang-selector-chk" type="checkbox" name="selectedLanguages" value="${codeLower}" id="chk_lang_${codeLower}" ${isSelected ? 'checked' : ''} onchange="toggleLangTab('${codeLower}')">
                                    <label class="form-check-label text-white fw-semibold small" for="chk_lang_${codeLower}">
                                        <img src="${pageContext.request.contextPath}${lang.flagUrl}" style="width: 20px; height: 14px; object-fit: cover; border-radius: 2px;" class="me-1">
                                        ${lang.countryName} (${lang.langCode.toUpperCase()})
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Tabs chuyển đổi nhập liệu chi tiết giữa các ngôn ngữ đã chọn -->
                    <ul class="nav nav-tabs border-secondary mb-3" id="movieLangTabs" role="tablist">
                        <c:forEach items="${activeLanguages}" var="lang" varStatus="vs">
                            <c:set var="codeLower" value="${lang.langCode.toLowerCase()}" />
                            <c:set var="isSelected" value="${movie == null ? (codeLower == 'vi' || codeLower == 'en') : (movie.translations[codeLower] != null || (empty movie.translations && codeLower == 'vi'))}" />
                            <li class="nav-item tab-lang-header" id="tab-header-${codeLower}" style="${isSelected ? '' : 'display:none;'}">
                                <button class="nav-link text-light ${vs.first ? 'active' : ''}" id="tab-btn-${codeLower}" data-bs-toggle="tab" data-bs-target="#tab-pane-${codeLower}" type="button" role="tab">
                                    <img src="${pageContext.request.contextPath}${lang.flagUrl}" style="width: 18px; height: 12px; object-fit: cover; border-radius: 2px;" class="me-1">
                                    ${lang.countryName} (${lang.langCode.toUpperCase()})
                                </button>
                            </li>
                        </c:forEach>
                    </ul>

                    <!-- Nội dung chi tiết từng tab ngôn ngữ -->
                    <div class="tab-content" id="movieLangTabsContent">
                        <c:forEach items="${activeLanguages}" var="lang" varStatus="vs">
                            <c:set var="codeLower" value="${lang.langCode.toLowerCase()}" />
                            <c:set var="trans" value="${movie != null ? movie.translations[codeLower] : null}" />
                            <c:set var="valTitle" value="${trans != null ? trans.title : (codeLower == 'vi' && movie != null ? movie.title : '')}" />
                            <c:set var="valGenre" value="${trans != null ? trans.genre : (codeLower == 'vi' && movie != null ? movie.genre : '')}" />
                            <c:set var="valDirector" value="${trans != null ? trans.director : (codeLower == 'vi' && movie != null ? movie.director : '')}" />
                            <c:set var="valCast" value="${trans != null ? trans.cast : (codeLower == 'vi' && movie != null ? movie.cast : '')}" />
                            <c:set var="valDesc" value="${trans != null ? trans.description : (codeLower == 'vi' && movie != null ? movie.description : '')}" />

                            <div class="tab-pane fade ${vs.first ? 'show active' : ''}" id="tab-pane-${codeLower}" role="tabpanel">
                                <div class="row g-3 p-3 rounded-3" style="background-color: #212121;">
                                    <div class="col-md-8">
                                        <label class="form-label text-light small fw-semibold">
                                            Tên phim (${lang.langCode.toUpperCase()}) *
                                        </label>
                                        <input type="text" class="form-control field-title-${codeLower}" name="title_${codeLower}" value="${valTitle}" placeholder="Ví dụ: Dune: Part Two / Lật Mặt 7">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label text-light small fw-semibold">
                                            Thể loại (${lang.langCode.toUpperCase()})
                                        </label>
                                        <input type="text" class="form-control" name="genre_${codeLower}" value="${valGenre}" placeholder="Ví dụ: Sci-Fi, Adventure">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label text-light small fw-semibold">
                                            Đạo diễn (${lang.langCode.toUpperCase()})
                                        </label>
                                        <input type="text" class="form-control" name="director_${codeLower}" value="${valDirector}" placeholder="Tên đạo diễn...">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label text-light small fw-semibold">
                                            Diễn viên (${lang.langCode.toUpperCase()})
                                        </label>
                                        <input type="text" class="form-control" name="cast_${codeLower}" value="${valCast}" placeholder="Danh sách diễn viên...">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label text-light small fw-semibold">
                                            Mô tả tóm tắt nội dung (${lang.langCode.toUpperCase()})
                                        </label>
                                        <textarea class="form-control" name="description_${codeLower}" rows="4" placeholder="Nội dung tóm tắt của bộ phim bằng ${lang.countryName}...">${valDesc}</textarea>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Nút thao tác -->
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/movies" class="btn btn-admin-back px-4">
                        <i class="fa-solid fa-xmark me-1"></i>Hủy Bỏ
                    </a>
                    <button type="button" id="btnSubmitMovie" class="btn btn-danger fw-bold px-4 py-2">
                        <i class="fa-solid fa-save me-1"></i>Lưu Toàn Bộ Thông Tin Phim
                    </button>
                </div>
            </form>

<script>
    function toggleLangTab(langCode) {
        var chk = document.getElementById('chk_lang_' + langCode);
        var tabHeader = document.getElementById('tab-header-' + langCode);
        var tabBtn = document.getElementById('tab-btn-' + langCode);

        if (chk && tabHeader) {
            if (chk.checked) {
                tabHeader.style.display = '';
                // If no tab is active, activate this one
                var activeTab = document.querySelector('#movieLangTabs .nav-link.active');
                if (!activeTab || activeTab.closest('.tab-lang-header').style.display === 'none') {
                    if (tabBtn) tabBtn.click();
                }
            } else {
                tabHeader.style.display = 'none';
                // If this tab was active, switch to first visible tab
                if (tabBtn && tabBtn.classList.contains('active')) {
                    var firstVisible = document.querySelector('.tab-lang-header:not([style*="display: none"]) .nav-link');
                    if (firstVisible) firstVisible.click();
                }
            }
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        var submitBtn = document.getElementById('btnSubmitMovie');
        var form = document.getElementById('movieAdminForm');

        if (submitBtn && form) {
            submitBtn.addEventListener('click', function (e) {
                e.preventDefault();

                // Check at least one language is checked
                var checkedLangs = document.querySelectorAll('.lang-selector-chk:checked');
                if (checkedLangs.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Chưa chọn ngôn ngữ',
                        text: 'Vui lòng chọn ít nhất 1 ngôn ngữ hỗ trợ cho bộ phim này!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                // Check title in the first checked language
                var firstLang = checkedLangs[0].value;
                var titleInput = document.querySelector('input[name="title_' + firstLang + '"]');
                if (titleInput && !titleInput.value.trim()) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Thiếu tên phim',
                        text: 'Vui lòng nhập tên phim cho ngôn ngữ ' + firstLang.toUpperCase() + '!',
                        confirmButtonColor: '#dc2626'
                    });
                    var tabBtn = document.getElementById('tab-btn-' + firstLang);
                    if (tabBtn) tabBtn.click();
                    titleInput.focus();
                    return;
                }

                var isDark = document.documentElement.getAttribute('data-bs-theme') !== 'light';
                Swal.fire({
                    title: 'Xác nhận lưu thông tin phim',
                    text: 'Bạn có chắc chắn muốn lưu thông tin phim cùng các bản dịch đã cấu hình vào cơ sở dữ liệu?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#dc2626',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: '<i class="fa-solid fa-check me-1"></i> Xác nhận lưu',
                    cancelButtonText: '<i class="fa-solid fa-xmark me-1"></i> Hủy',
                    background: isDark ? '#1e1e1e' : '#ffffff',
                    color: isDark ? '#f5f5f5' : '#0f172a',
                    reverseButtons: true
                }).then(function (result) {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });
        }
    });
</script>

<jsp:include page="common/admin-footer.jsp"/>
