<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<footer class="bg-black text-secondary py-5 mt-auto border-top border-secondary">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <h5 class="text-white fw-bold mb-3"><i class="fa-solid fa-film text-danger me-2"></i><span data-i18n="footer.brandTitle">CINESTAR CINEMA</span></h5>
                <p class="small text-muted" data-i18n="footer.description">Hệ thống rạp chiếu phim hiện đại chuẩn quốc tế. Mang đến trải nghiệm điện ảnh chân thực và sống động nhất cho khán giả.</p>
                <div class="d-flex gap-3 fs-5 text-secondary">
                    <a href="#" class="text-secondary"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#" class="text-secondary"><i class="fa-brands fa-youtube"></i></a>
                    <a href="#" class="text-secondary"><i class="fa-brands fa-tiktok"></i></a>
                    <a href="#" class="text-secondary"><i class="fa-brands fa-instagram"></i></a>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <h6 class="text-white fw-bold mb-3" data-i18n="footer.policy">Chính Sách</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="#" class="text-decoration-none text-muted" data-i18n="footer.terms">Điều khoản chung</a></li>
                    <li class="mb-2"><a href="#" class="text-decoration-none text-muted" data-i18n="footer.privacy">Chính sách bảo mật</a></li>
                    <li class="mb-2"><a href="#" class="text-decoration-none text-muted" data-i18n="footer.regulations">Quy chế hoạt động</a></li>
                    <li class="mb-2"><a href="#" class="text-decoration-none text-muted" data-i18n="footer.refund">Chính sách hoàn vé</a></li>
                </ul>
            </div>
            <div class="col-md-3 col-6">
                <h6 class="text-white fw-bold mb-3" data-i18n="footer.support">Hỗ Trợ Khách Hàng</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><i class="fa-solid fa-phone me-2 text-danger"></i><span data-i18n="footer.hotline">Hotline: 1900 6017</span></li>
                    <li class="mb-2"><i class="fa-solid fa-envelope me-2 text-danger"></i><span data-i18n="footer.email">support@cinestar.vn</span></li>
                    <li class="mb-2"><i class="fa-solid fa-clock me-2 text-danger"></i><span data-i18n="footer.hours">8:00 - 22:00 Hàng ngày</span></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h6 class="text-white fw-bold mb-3" data-i18n="footer.mobileApp">Ứng Dụng Di Động</h6>
                <p class="small text-muted" data-i18n="footer.mobileDesc">Tải ngay ứng dụng để đặt vé nhanh chóng và nhận ngập tràn ưu đãi.</p>
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-outline-secondary text-white"><i class="fa-brands fa-apple me-1"></i> App Store</button>
                    <button class="btn btn-sm btn-outline-secondary text-white"><i class="fa-brands fa-google-play me-1"></i> Google Play</button>
                </div>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="text-center small text-muted" data-i18n="footer.copyright">
            &copy; 2026 CineStar Cinema - PRJ302 Quản Lý Rạp Chiếu Phim. Thiết kế & phát triển bởi Nhóm Dự Án.
        </div>
    </div>
</footer>

<!-- Context Path Definition for JS -->
<script>window.CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- i18n Translation Engine -->
<script src="${pageContext.request.contextPath}/assets/js/i18n.js?v=2.4" charset="UTF-8"></script>
<!-- Main App JS -->
<script src="${pageContext.request.contextPath}/assets/js/main.js?v=2.1" charset="UTF-8"></script>
</body>
</html>