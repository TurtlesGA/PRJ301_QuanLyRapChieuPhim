<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="500 - Lỗi Máy Chủ Nội Bộ | CineStar" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="500 - Lỗi Máy Chủ Nội Bộ | CineStar"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<main class="error-page-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10 col-12 text-center">
                <div class="error-card p-4 p-md-5">
                    <!-- Cinema Icon Box -->
                    <div class="error-icon-box danger">
                        <i class="fa-solid fa-video-slash"></i>
                    </div>

                    <!-- Glitch Code -->
                    <div class="error-code-glitch">500</div>

                    <!-- Badge -->
                    <div class="mb-3">
                        <span class="badge bg-danger bg-opacity-25 text-danger border border-danger border-opacity-50 px-3 py-2 fs-6 rounded-pill">
                            <i class="fa-solid fa-server me-1"></i><span data-i18n="error.500.badge">SỰ CỐ KỸ THUẬT / LỖI MÁY CHỦ NỘI BỘ</span>
                        </span>
                    </div>

                    <!-- Title -->
                    <h2 class="h3 fw-bold text-white mb-3" data-i18n="error.500.title">
                        Máy Chiếu Đang Gặp Sự Cố Kỹ Thuật!
                    </h2>

                    <!-- Description -->
                    <p class="text-secondary mb-4 mx-auto lead fs-6" style="max-width: 580px;" data-i18n="error.500.desc">
                        Hệ thống đã xảy ra lỗi bất ngờ trong quá trình xử lý yêu cầu. Đội ngũ kỹ thuật viên CineStar đang nhanh chóng kiểm tra và khắc phục.
                    </p>

                    <!-- Action Buttons -->
                    <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                        <button type="button" onclick="window.location.reload()" class="btn btn-danger error-quick-link-btn">
                            <i class="fa-solid fa-rotate-right me-1"></i><span data-i18n="error.btnReload">Tải Lại Trang</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-danger error-quick-link-btn">
                            <i class="fa-solid fa-house me-1"></i><span data-i18n="error.btnHome">Về Trang Chủ</span>
                        </a>
                        <button type="button" onclick="window.history.back()" class="btn btn-outline-secondary error-quick-link-btn text-white">
                            <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="error.btnBack">Quay Lại</span>
                        </button>
                    </div>

                    <!-- Technical Details (Collapsible for debug) -->
                    <c:if test="${not empty pageContext.exception or not empty requestScope['jakarta.servlet.error.message']}">
                        <div class="mt-4 text-start">
                            <a class="text-muted small text-decoration-none d-inline-flex align-items-center gap-1" data-bs-toggle="collapse" href="#debugDetails" role="button" aria-expanded="false" aria-controls="debugDetails">
                                <i class="fa-solid fa-circle-info"></i> <span data-i18n="error.viewTechDetails">Xem chi tiết kỹ thuật</span> <i class="fa-solid fa-chevron-down small"></i>
                            </a>
                            <div class="collapse mt-2" id="debugDetails">
                                <div class="error-debug-box p-3">
                                    <div class="mb-1"><strong>Mã trạng thái:</strong> ${not empty pageContext.errorData.statusCode ? pageContext.errorData.statusCode : '500'}</div>
                                    <div class="mb-1"><strong>Đường dẫn:</strong> ${pageContext.errorData.requestURI}</div>
                                    <c:if test="${not empty requestScope['jakarta.servlet.error.message']}">
                                        <div class="mb-1"><strong>Thông báo:</strong> ${requestScope['jakarta.servlet.error.message']}</div>
                                    </c:if>
                                    <c:if test="${not empty pageContext.exception}">
                                        <div class="text-danger mt-2"><strong>Ngoại lệ:</strong> ${pageContext.exception}</div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Helpful links -->
                    <div class="border-top border-secondary pt-3 mt-4 text-muted small">
                        <span data-i18n="error.needHelp">Hỗ trợ khẩn cấp? Gọi ngay hotline</span> 
                        <strong class="text-danger">${not empty siteSettings.footer_hotline ? siteSettings.footer_hotline : '1900 6017'}</strong> 
                        <span data-i18n="error.orEmail">hoặc email</span> 
                        <strong class="text-white">${not empty siteSettings.footer_email ? siteSettings.footer_email : 'support@cinestar.vn'}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
