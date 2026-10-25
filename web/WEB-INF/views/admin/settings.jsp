<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Cài Đặt Hệ Thống - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Cài Đặt Hệ Thống - CineStar Admin"/>
    <jsp:param name="activeMenu" value="settings"/>
</jsp:include>

<div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
    <div>
        <h2 class="h3 fw-bold text-white mb-1">
            <i class="fa-solid fa-gears text-danger me-2"></i>CÀI ĐẶT HỆ THỐNG & TÙY BIẾN
        </h2>
        <p class="text-muted small mb-0">Quản lý nhận diện thương hiệu, kịch bản nhúng tùy chỉnh và gói ngôn ngữ giao diện.</p>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/admin/settings?action=download-template" class="btn btn-outline-warning btn-sm fw-bold">
            <i class="fa-solid fa-download me-1"></i>Tải Template JSON Mẫu
        </a>
    </div>
</div>

<!-- Tabs Navigation -->
<ul class="nav nav-pills mb-4 gap-2" id="settingsTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link ${empty param.tab || param.tab == 'general' ? 'active' : ''} fw-semibold px-4 py-2 rounded-pill" id="tab-general-btn" data-bs-toggle="pill" data-bs-target="#tab-general" type="button" role="tab">
            <i class="fa-solid fa-sliders me-2"></i>Cấu Hình Chung
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link ${param.tab == 'scripts' ? 'active' : ''} fw-semibold px-4 py-2 rounded-pill" id="tab-scripts-btn" data-bs-toggle="pill" data-bs-target="#tab-scripts" type="button" role="tab">
            <i class="fa-solid fa-code me-2"></i>Mã Script Tùy Biến
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link ${param.tab == 'languages' ? 'active' : ''} fw-semibold px-4 py-2 rounded-pill" id="tab-languages-btn" data-bs-toggle="pill" data-bs-target="#tab-languages" type="button" role="tab">
            <i class="fa-solid fa-earth-americas me-2"></i>Ngôn Ngữ & Đóng Góp Bản Dịch
        </button>
    </li>
</ul>

<div class="tab-content" id="settingsTabContent">
    <!-- TAB 1: Cấu hình chung (General & Header/Footer) -->
    <div class="tab-pane fade ${empty param.tab || param.tab == 'general' ? 'show active' : ''}" id="tab-general" role="tabpanel">
        <form id="formGeneralSettings" action="${pageContext.request.contextPath}/admin/settings" method="POST">
            <input type="hidden" name="action" value="saveSettings">

            <!-- Card 1: Nhận diện website & Favicon -->
            <div class="card bg-dark border-secondary rounded-4 p-4 shadow mb-4">
                <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2">
                    <i class="fa-solid fa-globe text-danger me-2"></i>Nhận Diện Website & Header
                </h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label text-light small fw-semibold">Tiêu đề Website mặc định (Site Title)</label>
                        <input type="text" class="form-control" name="site_title" value="${settings.site_title != null ? settings.site_title : 'CineStar - Đặt Vé Xem Phim Trực Tuyến'}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-light small fw-semibold">Favicon URL (Link ảnh icon)</label>
                        <input type="text" class="form-control" name="site_favicon" value="${settings.site_favicon}" placeholder="https://example.com/favicon.ico hoặc /assets/images/favicon.ico">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-light small fw-semibold">Tên thương hiệu Header (Header Brand Name)</label>
                        <input type="text" class="form-control" name="header_brand_name" value="${settings.header_brand_name != null ? settings.header_brand_name : 'CINESTAR'}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-light small fw-semibold">Khẩu hiệu Header (Header Slogan)</label>
                        <input type="text" class="form-control" name="header_slogan" value="${settings.header_slogan != null ? settings.header_slogan : 'Trải nghiệm điện ảnh đỉnh cao'}">
                    </div>
                </div>
            </div>

            <!-- Card 2: Thông tin Footer -->
            <div class="card bg-dark border-secondary rounded-4 p-4 shadow mb-4">
                <h5 class="fw-bold text-white mb-3 border-bottom border-secondary pb-2">
                    <i class="fa-solid fa-circle-info text-danger me-2"></i>Thông Tin Chân Trang (Footer)
                </h5>
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label text-light small fw-semibold">Đoạn mô tả giới thiệu rạp (Footer Description)</label>
                        <textarea class="form-control" name="footer_description" rows="3">${settings.footer_description != null ? settings.footer_description : 'Hệ thống rạp chiếu phim hiện đại chuẩn quốc tế. Mang đến trải nghiệm điện ảnh chân thực và sống động nhất cho khán giả.'}</textarea>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-light small fw-semibold">Số điện thoại Hotline</label>
                        <input type="text" class="form-control" name="footer_hotline" value="${settings.footer_hotline != null ? settings.footer_hotline : '1900 6017'}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-light small fw-semibold">Email hỗ trợ khách hàng</label>
                        <input type="email" class="form-control" name="footer_email" value="${settings.footer_email != null ? settings.footer_email : 'support@cinestar.vn'}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-light small fw-semibold">Giờ hoạt động phục vụ</label>
                        <input type="text" class="form-control" name="footer_hours" value="${settings.footer_hours != null ? settings.footer_hours : '8:00 - 22:00 Hàng ngày'}">
                    </div>
                    <div class="col-12">
                        <label class="form-label text-light small fw-semibold">Thông tin bản quyền (Copyright)</label>
                        <input type="text" class="form-control" name="footer_copyright" value="${settings.footer_copyright != null ? settings.footer_copyright : '© 2026 CineStar Cinema - PRJ302 Quản Lý Rạp Chiếu Phim.'}">
                    </div>
                </div>
            </div>

            <div class="text-end">
                <button type="button" class="btn btn-danger fw-bold px-4 py-2 btn-save-settings" data-form="formGeneralSettings">
                    <i class="fa-solid fa-save me-1"></i>Lưu Cấu Hình Chung
                </button>
            </div>
        </form>
    </div>

    <!-- TAB 2: Custom Scripts (Head / Body / Foot) -->
    <div class="tab-pane fade ${param.tab == 'scripts' ? 'show active' : ''}" id="tab-scripts" role="tabpanel">
        <form id="formScriptSettings" action="${pageContext.request.contextPath}/admin/settings" method="POST">
            <input type="hidden" name="action" value="saveSettings">

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow mb-4">
                <div class="d-flex align-items-center justify-content-between border-bottom border-secondary pb-3 mb-3">
                    <div>
                        <h5 class="fw-bold text-white mb-1">
                            <i class="fa-solid fa-code text-warning me-2"></i>Kịch Bản Nhúng Tùy Biến (Custom Scripts)
                        </h5>
                        <p class="text-muted small mb-0">Thêm các mã script như Google Analytics, Facebook Pixel, Chat Widget, hoặc CSS tùy chỉnh.</p>
                    </div>
                    <span class="badge bg-warning text-dark"><i class="fa-solid fa-shield-halved me-1"></i>Admin Only</span>
                </div>

                <div class="row g-4">
                    <!-- Head Script -->
                    <div class="col-12">
                        <label class="form-label text-light small fw-semibold d-flex justify-content-between">
                            <span><i class="fa-solid fa-terminal me-1 text-info"></i>Mã nhúng trong thẻ &lt;head&gt; (Head Script):</span>
                            <span class="text-muted">Chèn trước &lt;/head&gt;</span>
                        </label>
                        <textarea class="form-control font-monospace text-light" style="background-color: #1a1a1a; font-size: 0.88rem;" name="script_head" rows="5" placeholder="&lt;!-- Ví dụ: Google Tag Manager hoặc CSS tùy chỉnh --&gt;&#10;&lt;script&gt;&#10;  console.log('Head script loaded');&#10;&lt;/script&gt;">${settings.script_head}</textarea>
                    </div>

                    <!-- Body Script -->
                    <div class="col-12">
                        <label class="form-label text-light small fw-semibold d-flex justify-content-between">
                            <span><i class="fa-solid fa-terminal me-1 text-success"></i>Mã nhúng ngay sau mở &lt;body&gt; (Body Script):</span>
                            <span class="text-muted">Chèn ngay sau &lt;body&gt;</span>
                        </label>
                        <textarea class="form-control font-monospace text-light" style="background-color: #1a1a1a; font-size: 0.88rem;" name="script_body" rows="5" placeholder="&lt;!-- Ví dụ: Google Tag Manager (noscript) --&gt;&#10;&lt;noscript&gt;&lt;iframe src='...' height='0' width='0'&gt;&lt;/iframe&gt;&lt;/noscript&gt;">${settings.script_body}</textarea>
                    </div>

                    <!-- Foot Script -->
                    <div class="col-12">
                        <label class="form-label text-light small fw-semibold d-flex justify-content-between">
                            <span><i class="fa-solid fa-terminal me-1 text-danger"></i>Mã nhúng cuối trang trước &lt;/body&gt; (Foot Script):</span>
                            <span class="text-muted">Chèn trước đóng &lt;/body&gt;</span>
                        </label>
                        <textarea class="form-control font-monospace text-light" style="background-color: #1a1a1a; font-size: 0.88rem;" name="script_foot" rows="5" placeholder="&lt;!-- Ví dụ: Livechat widget, tracking pixel --&gt;&#10;&lt;script&gt;&#10;  console.log('Foot script loaded');&#10;&lt;/script&gt;">${settings.script_foot}</textarea>
                    </div>
                </div>
            </div>

            <div class="text-end">
                <button type="button" class="btn btn-danger fw-bold px-4 py-2 btn-save-settings" data-form="formScriptSettings">
                    <i class="fa-solid fa-save me-1"></i>Lưu Mã Script
                </button>
            </div>
        </form>
    </div>

    <!-- TAB 3: Language Manager & Upload Contributor Translation -->
    <div class="tab-pane fade ${param.tab == 'languages' ? 'show active' : ''}" id="tab-languages" role="tabpanel">
        <div class="row g-4">
            <!-- Cột trái: Danh sách ngôn ngữ hiện có -->
            <div class="col-lg-6">
                <div class="card bg-dark border-secondary rounded-4 p-4 shadow h-100">
                    <div class="d-flex justify-content-between align-items-center border-bottom border-secondary pb-3 mb-3">
                        <h5 class="fw-bold text-white mb-0">
                            <i class="fa-solid fa-list-check text-danger me-2"></i>Gói Ngôn Ngữ Đang Kích Hoạt
                        </h5>
                        <span class="badge bg-danger">${languages.size()} Ngôn ngữ</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-dark table-hover align-middle mb-0">
                            <thead>
                                <tr class="text-secondary small">
                                    <th>Cờ</th>
                                    <th>Mã</th>
                                    <th>Quốc Gia</th>
                                    <th>Mặc Định</th>
                                    <th>File Bản Dịch</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${languages}" var="lang">
                                    <tr>
                                        <td>
                                            <img src="${pageContext.request.contextPath}${lang.flagUrl}" alt="${lang.langCode}" style="width: 28px; height: 18px; object-fit: cover; border-radius: 3px; border: 1px solid #555;">
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary font-monospace fw-bold">${lang.langCode.toUpperCase()}</span>
                                        </td>
                                        <td class="text-white fw-semibold">${lang.countryName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${lang.defaultLang}">
                                                    <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i>Mặc định</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/assets/i18n/${lang.langCode.toLowerCase()}.json" target="_blank" class="text-info text-decoration-none small">
                                                <i class="fa-regular fa-file-code me-1"></i>${lang.langCode.toLowerCase()}.json
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4 p-3 rounded-3 settings-info-box">
                        <h6 class="info-box-title fw-bold mb-1"><i class="fa-solid fa-circle-question me-1"></i>Cơ Chế Hoạt Động</h6>
                        <p class="small info-box-desc mb-0">
                            Các văn bản cốt lõi (Core UI) được tải từ file <code>assets/i18n/{code}.json</code>. Khi thêm một ngôn ngữ mới, bộ chọn cờ ở thanh Navbar sẽ tự động hiển thị lá cờ và tên quốc gia của ngôn ngữ đó ngay lập tức mà không cần khởi động lại máy chủ.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Form Upload Bản Dịch Mới -->
            <div class="col-lg-6">
                <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                    <div class="d-flex justify-content-between align-items-center border-bottom border-secondary pb-3 mb-3">
                        <div>
                            <h5 class="fw-bold text-white mb-1">
                                <i class="fa-solid fa-cloud-arrow-up text-warning me-2"></i>Đóng Góp / Tải Lên Bản Dịch Mới
                            </h5>
                            <p class="text-muted small mb-0">Đóng góp gói dịch giao diện cho quốc gia hoặc ngôn ngữ mới.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/settings?action=download-template" class="btn btn-outline-warning btn-sm" title="Tải file template JSON mẫu chuẩn">
                            <i class="fa-solid fa-file-arrow-down me-1"></i>Template JSON
                        </a>
                    </div>

                    <form id="formUploadLanguage" action="${pageContext.request.contextPath}/admin/settings" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="uploadLanguage">

                        <div class="row g-3">
                            <div class="col-md-7">
                                <label class="form-label text-light small fw-semibold">Tên Đầy Đủ Quốc Gia *</label>
                                <input type="text" class="form-control" name="countryName" id="uploadCountryName" placeholder="Ví dụ: France, Japan, Germany..." required>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label text-light small fw-semibold">Mã Quốc Gia / Ngôn Ngữ *</label>
                                <input type="text" class="form-control font-monospace text-uppercase" name="langCode" id="uploadLangCode" placeholder="Ví dụ: FR, JP, DE" maxlength="10" required>
                                <div class="form-text text-muted small">Mã viết tắt (2 - 5 ký tự)</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label text-light small fw-semibold">
                                    <i class="fa-regular fa-image text-warning me-1"></i>Ảnh Cờ Quốc Gia (Flag Image) *
                                </label>
                                <input type="file" class="form-control" name="flagImage" id="uploadFlagImage" accept=".png, .jpg, .jpeg, .svg, .webp" required>
                                <div class="form-text text-muted small">Định dạng hỗ trợ: <strong>.png, .jpg, .jpeg, .svg, .webp</strong> (Khuyên dùng tỷ lệ 3:2 hoặc SVG). Tối đa 5MB.</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label text-light small fw-semibold">
                                    <i class="fa-solid fa-file-code text-info me-1"></i>File Bản Dịch JSON (.json) *
                                </label>
                                <input type="file" class="form-control" name="jsonFile" id="uploadJsonFile" accept=".json, application/json" required>
                                <div class="form-text text-muted small">File dịch phải theo đúng cấu trúc của <strong>template.json</strong> (chứa các khối <code>common</code>, <code>nav</code>, <code>footer</code>, <code>home</code>, <code>status</code>).</div>
                            </div>

                            <div class="col-12 mt-4 pt-3 border-top border-secondary text-end">
                                <button type="button" id="btnSubmitUpload" class="btn btn-warning fw-bold px-4 py-2 text-dark">
                                    <i class="fa-solid fa-upload me-1"></i>Kiểm Tra & Tải Lên Bản Dịch
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var isDark = document.documentElement.getAttribute('data-bs-theme') !== 'light';

        // 1. Check URL parameters for SweetAlert2 Flash Notifications
        var urlParams = new URLSearchParams(window.location.search);
        var msg = urlParams.get('msg');
        var err = urlParams.get('error');
        var code = urlParams.get('code');
        var missing = urlParams.get('missing');

        if (msg === 'settings_saved') {
            Swal.fire({
                icon: 'success',
                title: 'Đã lưu cấu hình!',
                text: 'Cài đặt hệ thống và giao diện đã được cập nhật thành công.',
                confirmButtonColor: '#dc2626'
            });
        } else if (msg === 'lang_added') {
            Swal.fire({
                icon: 'success',
                title: 'Thêm ngôn ngữ thành công!',
                text: 'Gói ngôn ngữ (' + (code ? code.toUpperCase() : '') + ') và cờ quốc gia đã được tích hợp vào hệ thống.',
                confirmButtonColor: '#dc2626'
            });
        }

        if (err) {
            var errTitle = 'Đã có lỗi xảy ra';
            var errText = 'Vui lòng kiểm tra lại thông tin đã nhập.';

            if (err === 'missing_fields') {
                errText = 'Vui lòng điền đầy đủ tên quốc gia và mã ngôn ngữ!';
            } else if (err === 'invalid_lang_code') {
                errText = 'Mã ngôn ngữ không hợp lệ! Vui lòng nhập từ 2 đến 10 ký tự chữ cái (Ví dụ: VN, US, FR, JP).';
            } else if (err === 'lang_exists') {
                errText = 'Mã ngôn ngữ "' + (code ? code.toUpperCase() : '') + '" đã tồn tại trong hệ thống! Không thể thêm trùng lặp.';
            } else if (err === 'missing_flag') {
                errText = 'Vui lòng chọn file ảnh cờ cho quốc gia!';
            } else if (err === 'invalid_image_format' || err === 'invalid_image_mime') {
                errText = 'Định dạng file cờ không hợp lệ! Hệ thống chỉ chấp nhận các định dạng ảnh: .png, .jpg, .jpeg, .svg, .webp.';
            } else if (err === 'missing_json') {
                errText = 'Vui lòng chọn file bản dịch .json!';
            } else if (err === 'invalid_json_extension') {
                errText = 'File bản dịch bắt buộc phải có phần mở rộng .json!';
            } else if (err === 'json_syntax_invalid') {
                errText = 'Cú pháp file JSON bị lỗi hoặc không đúng chuẩn JSON! Vui lòng kiểm tra lại dấu ngoặc và dấu phẩy.';
            } else if (err === 'json_missing_keys') {
                errText = 'File JSON thiếu khối bắt buộc: "' + (missing || 'common/nav/footer/home') + '" theo template chuẩn!';
            }

            Swal.fire({
                icon: 'error',
                title: errTitle,
                text: errText,
                confirmButtonColor: '#dc2626'
            });
        }

        // 2. SweetAlert2 Confirmation for Saving General / Script Settings
        document.querySelectorAll('.btn-save-settings').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                var formId = btn.getAttribute('data-form');
                var form = document.getElementById(formId);

                Swal.fire({
                    title: 'Xác nhận lưu cài đặt?',
                    text: 'Các thay đổi sẽ được áp dụng trực tiếp lên giao diện website.',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#dc2626',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: '<i class="fa-solid fa-check me-1"></i> Xác nhận',
                    cancelButtonText: '<i class="fa-solid fa-xmark me-1"></i> Hủy',
                    background: isDark ? '#1e1e1e' : '#ffffff',
                    color: isDark ? '#f5f5f5' : '#0f172a',
                    reverseButtons: true
                }).then(function (result) {
                    if (result.isConfirmed && form) {
                        form.submit();
                    }
                });
            });
        });

        // 3. Client-side Pre-validation & SweetAlert2 for Uploading Language
        var btnSubmitUpload = document.getElementById('btnSubmitUpload');
        var formUploadLanguage = document.getElementById('formUploadLanguage');

        if (btnSubmitUpload && formUploadLanguage) {
            btnSubmitUpload.addEventListener('click', function (e) {
                e.preventDefault();

                var countryName = document.getElementById('uploadCountryName').value.trim();
                var langCode = document.getElementById('uploadLangCode').value.trim().toLowerCase();
                var flagInput = document.getElementById('uploadFlagImage');
                var jsonInput = document.getElementById('uploadJsonFile');

                if (!countryName || !langCode) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Thiếu thông tin',
                        text: 'Vui lòng nhập tên quốc gia và mã ngôn ngữ!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                if (!/^[a-z0-9_-]{2,10}$/.test(langCode)) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Mã ngôn ngữ không hợp lệ',
                        text: 'Mã ngôn ngữ chỉ được chứa từ 2 đến 10 ký tự chữ cái hoặc số (Ví dụ: FR, JP, DE, CN)!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                if (!flagInput.files || flagInput.files.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Chưa chọn cờ',
                        text: 'Vui lòng chọn file ảnh cờ quốc gia!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                var flagFile = flagInput.files[0];
                var allowedExts = ['.png', '.jpg', '.jpeg', '.svg', '.webp'];
                var flagFileName = flagFile.name.toLowerCase();
                var isValidExt = allowedExts.some(function (ext) { return flagFileName.endsWith(ext); });

                if (!isValidExt) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Định dạng ảnh không hợp lệ',
                        text: 'File cờ phải thuộc định dạng: .png, .jpg, .jpeg, .svg, .webp!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                if (!jsonInput.files || jsonInput.files.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Chưa chọn file JSON',
                        text: 'Vui lòng chọn file bản dịch .json!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                var jsonFile = jsonInput.files[0];
                if (!jsonFile.name.toLowerCase().endsWith('.json')) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Định dạng JSON không hợp lệ',
                        text: 'File bản dịch bắt buộc phải có định dạng .json!',
                        confirmButtonColor: '#dc2626'
                    });
                    return;
                }

                // Asynchronously parse client-side JSON to verify syntax & required keys before upload
                var reader = new FileReader();
                reader.onload = function (evt) {
                    try {
                        var parsed = JSON.parse(evt.target.result);
                        var requiredKeys = ['common', 'nav', 'footer', 'home', 'status'];
                        var missingKeys = [];

                        requiredKeys.forEach(function (k) {
                            if (!parsed[k] || typeof parsed[k] !== 'object') {
                                missingKeys.push(k);
                            }
                        });

                        if (missingKeys.length > 0) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Thiếu cấu trúc template',
                                text: 'File JSON thiếu các khối bắt buộc: ' + missingKeys.join(', ') + '. Vui lòng tải Template JSON mẫu để xem định dạng chuẩn.',
                                confirmButtonColor: '#dc2626'
                            });
                            return;
                        }

                        // Everything is valid! Show Confirmation Dialog
                        Swal.fire({
                            title: 'Xác nhận tải lên bản dịch?',
                            html: 'Bạn sắp tải lên gói ngôn ngữ <strong>' + countryName + ' (' + langCode.toUpperCase() + ')</strong>.<br><small class="text-muted">Cờ: ' + flagFile.name + ' | JSON: ' + jsonFile.name + '</small>',
                            icon: 'question',
                            showCancelButton: true,
                            confirmButtonColor: '#eab308',
                            cancelButtonColor: '#6c757d',
                            confirmButtonText: '<i class="fa-solid fa-cloud-arrow-up me-1 text-dark"></i> Xác nhận tải lên',
                            cancelButtonText: '<i class="fa-solid fa-xmark me-1"></i> Hủy',
                            background: isDark ? '#1e1e1e' : '#ffffff',
                            color: isDark ? '#f5f5f5' : '#0f172a',
                            reverseButtons: true
                        }).then(function (result) {
                            if (result.isConfirmed) {
                                Swal.fire({
                                    title: 'Đang xử lý tải lên...',
                                    text: 'Đang lưu trữ file cờ, phân tích JSON và cập nhật hệ thống.',
                                    allowOutsideClick: false,
                                    didOpen: function () {
                                        Swal.showLoading();
                                    }
                                });
                                formUploadLanguage.submit();
                            }
                        });

                    } catch (err) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Cú pháp JSON không hợp lệ',
                            text: 'Không thể đọc file JSON (lỗi cú pháp JSON): ' + err.message,
                            confirmButtonColor: '#dc2626'
                        });
                    }
                };
                reader.readAsText(jsonFile);
            });
        }
    });
</script>

<jsp:include page="common/admin-footer.jsp"/>
