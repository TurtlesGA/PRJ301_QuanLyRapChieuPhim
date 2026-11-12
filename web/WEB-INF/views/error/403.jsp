<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="403 - Truy Cập Bị Từ Chối | CineStar" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="403 - Truy Cập Bị Từ Chối | CineStar"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<main class="error-page-wrapper">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10 col-12 text-center">
                <div class="error-card p-4 p-md-5">
                    <!-- Cinema Icon Box -->
                    <div class="error-icon-box warning">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>

                    <!-- Glitch Code -->
                    <div class="error-code-glitch error-code-warning">403</div>

                    <!-- Badge -->
                    <div class="mb-3">
                        <span class="badge bg-warning bg-opacity-25 text-warning border border-warning border-opacity-50 px-3 py-2 fs-6 rounded-pill">
                            <i class="fa-solid fa-lock me-1"></i><span data-i18n="error.403.badge">KHU VỰC HẠN CHẾ / TRUY CẬP BỊ TỪ CHỐI</span>
                        </span>
                    </div>

                    <!-- Title -->
                    <h2 class="h3 fw-bold text-white mb-3" data-i18n="error.403.title">
                        Bạn Không Có Quyền Truy Cập
                    </h2>

                    <!-- Description -->
                    <p class="text-secondary mb-4 mx-auto lead fs-6" style="max-width: 580px;" data-i18n="error.403.desc">
                        Khu vực này yêu cầu tài khoản có thẩm quyền Quản trị (Admin) hoặc bạn chưa được phân quyền truy cập tính năng này.
                    </p>

                    <!-- Action Buttons -->
                    <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                        <c:choose>
                            <c:when test="${empty sessionScope.currentUser}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-danger error-quick-link-btn">
                                    <i class="fa-solid fa-right-to-bracket me-1"></i><span data-i18n="error.btnLogin">Đăng Nhập Ngay</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-danger error-quick-link-btn">
                                    <i class="fa-solid fa-house me-1"></i><span data-i18n="error.btnHome">Về Trang Chủ</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-danger error-quick-link-btn">
                            <i class="fa-solid fa-film me-1"></i><span data-i18n="error.btnMovies">Xem Danh Sách Phim</span>
                        </a>
                        <button type="button" onclick="window.history.back()" class="btn btn-outline-secondary error-quick-link-btn text-white">
                            <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="error.btnBack">Quay Lại</span>
                        </button>
                    </div>

                    <!-- Helpful links -->
                    <div class="border-top border-secondary pt-3 mt-2 text-muted small">
                        <span data-i18n="error.needHelp">Nếu bạn cho rằng đây là sự nhầm lẫn, vui lòng liên hệ</span> 
                        <strong class="text-danger">${not empty siteSettings.footer_hotline ? siteSettings.footer_hotline : '1900 6017'}</strong> 
                        <span data-i18n="error.orEmail">hoặc gửi email về</span> 
                        <strong class="text-white">${not empty siteSettings.footer_email ? siteSettings.footer_email : 'support@cinestar.vn'}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
