<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="400 - Yêu Cầu Không Hợp Lệ | CineStar" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="400 - Yêu Cầu Không Hợp Lệ | CineStar"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<main class="error-page-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10 col-12 text-center">
                <div class="error-card p-4 p-md-5">
                    <!-- Cinema Icon Box -->
                    <div class="error-icon-box orange">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>

                    <!-- Glitch Code -->
                    <div class="error-code-glitch error-code-orange">400</div>

                    <!-- Badge -->
                    <div class="mb-3">
                        <span class="badge bg-warning bg-opacity-25 text-warning border border-warning border-opacity-50 px-3 py-2 fs-6 rounded-pill">
                            <i class="fa-solid fa-circle-exclamation me-1"></i><span data-i18n="error.400.badge">YÊU CẦU KHÔNG HỢP LỆ / DỮ LIỆU SAI ĐỊNH DẠNG</span>
                        </span>
                    </div>

                    <!-- Title -->
                    <h2 class="h3 fw-bold text-white mb-3" data-i18n="error.400.title">
                        Yêu Cầu Của Bạn Không Thể Xử Lý
                    </h2>

                    <!-- Description -->
                    <p class="text-secondary mb-4 mx-auto lead fs-6" style="max-width: 580px;" data-i18n="error.400.desc">
                        Máy chủ không thể hiểu yêu cầu do cú pháp dữ liệu gửi lên không đúng định dạng hoặc đã bị gián đoạn. Vui lòng kiểm tra lại thao tác của bạn.
                    </p>

                    <!-- Action Buttons -->
                    <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                        <button type="button" onclick="window.history.back()" class="btn btn-danger error-quick-link-btn">
                            <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="error.btnBackRetry">Quay Lại Thao Tác</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-danger error-quick-link-btn">
                            <i class="fa-solid fa-house me-1"></i><span data-i18n="error.btnHome">Về Trang Chủ</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-secondary error-quick-link-btn text-white">
                            <i class="fa-solid fa-film me-1"></i><span data-i18n="error.btnMovies">Xem Lịch Phim</span>
                        </a>
                    </div>

                    <!-- Helpful links -->
                    <div class="border-top border-secondary pt-3 mt-2 text-muted small">
                        <span data-i18n="error.needHelp">Cần trợ giúp? Liên hệ hotline</span> 
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
