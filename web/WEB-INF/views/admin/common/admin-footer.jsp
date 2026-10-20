<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
        </main>
    </div>
</div>

<!-- ================= DEDICATED ADMIN FOOTER ================= -->
<footer class="admin-footer py-3 border-top border-secondary mt-auto">
    <div class="container-fluid px-3 px-lg-4">
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2 text-muted small">
            <div>
                <span class="text-white fw-semibold">CineStar Cinema</span> &copy; 2026 Admin Control Panel. <span data-i18n="admin.footerText">Phiên bản 2.0</span>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-50">
                    <i class="fa-solid fa-circle text-success me-1" style="font-size: 0.5rem;"></i><span data-i18n="admin.systemStable">Hệ thống ổn định</span>
                </span>
                <span class="d-none d-md-inline">PRJ302 Quản Lý Rạp Chiếu Phim</span>
            </div>
        </div>
    </div>
</footer>

<!-- Context Path for JS -->
<script>window.CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- i18n Translation Engine -->
<script src="${pageContext.request.contextPath}/assets/js/i18n.js?v=2.4" charset="UTF-8"></script>
<!-- Admin SweetAlert2 and UI Script -->
<script src="${pageContext.request.contextPath}/assets/js/admin.js?v=2.3" charset="UTF-8"></script>
</body>
</html>