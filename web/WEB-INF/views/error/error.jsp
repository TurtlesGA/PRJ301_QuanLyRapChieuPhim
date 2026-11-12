<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="statusCode" value="${not empty pageContext.errorData.statusCode ? pageContext.errorData.statusCode : 500}" />
<c:set var="pageTitle" value="Lỗi ${statusCode} | CineStar" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Lỗi ${statusCode} | CineStar"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<main class="error-page-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10 col-12 text-center">
                <div class="error-card p-4 p-md-5">
                    <!-- Cinema Icon Box -->
                    <div class="error-icon-box danger">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>

                    <!-- Code -->
                    <div class="error-code-glitch">${statusCode}</div>

                    <!-- Badge -->
                    <div class="mb-3">
                        <span class="badge bg-danger bg-opacity-25 text-danger border border-danger border-opacity-50 px-3 py-2 fs-6 rounded-pill">
                            <i class="fa-solid fa-circle-exclamation me-1"></i><span>SỰ CỐ XỬ LÝ YÊU CẦU</span>
                        </span>
                    </div>

                    <!-- Title -->
                    <h2 class="h3 fw-bold text-white mb-3">
                        Đã Xảy Ra Sự Cố Không Mong Muốn
                    </h2>

                    <!-- Description -->
                    <p class="text-secondary mb-4 mx-auto lead fs-6" style="max-width: 580px;">
                        Hệ thống gặp sự cố trong quá trình phản hồi yêu cầu của bạn. Xin vui lòng thử lại hoặc quay trở về trang chủ.
                    </p>

                    <!-- Action Buttons -->
                    <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-danger error-quick-link-btn">
                            <i class="fa-solid fa-house me-1"></i><span data-i18n="error.btnHome">Về Trang Chủ</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-danger error-quick-link-btn">
                            <i class="fa-solid fa-film me-1"></i><span data-i18n="error.btnMovies">Xem Lịch Phim</span>
                        </a>
                        <button type="button" onclick="window.history.back()" class="btn btn-outline-secondary error-quick-link-btn text-white">
                            <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="error.btnBack">Quay Lại</span>
                        </button>
                    </div>

                    <!-- Helpful links -->
                    <div class="border-top border-secondary pt-3 mt-2 text-muted small">
                        <span data-i18n="error.needHelp">Cần trợ giúp? Gọi ngay hotline</span> 
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
