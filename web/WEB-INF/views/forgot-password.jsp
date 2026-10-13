<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Quên Mật Khẩu - CineStar" scope="request" />
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Quên Mật Khẩu - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5 d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card auth-card bg-dark border-secondary p-4 rounded-4 shadow">
                    <div class="text-center mb-4">
                        <i class="fa-solid fa-key text-warning fs-1 mb-2"></i>
                        <h4 class="fw-bold auth-title text-white">QUÊN MẬT KHẨU</h4>
                        <p class="small auth-subtitle text-muted">Khôi phục mật khẩu tài khoản CineStar</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty otpNotice}">
                        <div class="alert alert-info py-2 small" role="alert">
                            <i class="fa-solid fa-shield-halved me-1"></i><strong>${otpNotice}</strong>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${step == '2'}">
                            <div class="mb-3 p-2 rounded bg-black border border-secondary small text-light d-flex justify-content-between align-items-center">
                                <span>Email: <strong class="text-warning">${sessionScope.resetEmail}</strong></span>
                                <a href="${pageContext.request.contextPath}/forgot-password?action=reset" class="text-info text-decoration-none small">Đổi email</a>
                            </div>

                            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                                <input type="hidden" name="step" value="2">

                                <div class="mb-3">
                                    <label class="form-label auth-label text-light small">Mã xác thực OTP</label>
                                    <div class="input-group">
                                        <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-shield-halved"></i></span>
                                        <input type="text" class="form-control" name="otp" placeholder="Nhập mã OTP 6 số" maxlength="6" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label auth-label text-light small">Mật khẩu mới</label>
                                    <div class="input-group">
                                        <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-lock"></i></span>
                                        <input type="password" class="form-control" name="newPassword" placeholder="Tối thiểu 6 ký tự" minlength="6" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label auth-label text-light small">Xác nhận mật khẩu mới</label>
                                    <div class="input-group">
                                        <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-lock"></i></span>
                                        <input type="password" class="form-control" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" minlength="6" required>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-warning w-100 py-2 fw-bold mb-3 text-dark">
                                    Đặt Lại Mật Khẩu
                                </button>
                            </form>
                        </c:when>

                        <c:otherwise>
                            <p class="small text-light mb-3">Vui lòng nhập địa chỉ email đã dùng để đăng ký tài khoản. Hệ thống sẽ cấp mã xác thực OTP để bạn đặt lại mật khẩu mới.</p>

                            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                                <input type="hidden" name="step" value="1">

                                <div class="mb-4">
                                    <label class="form-label auth-label text-light small">Địa chỉ Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text auth-input-icon bg-secondary border-secondary text-white"><i class="fa-solid fa-envelope"></i></span>
                                        <input type="email" class="form-control" name="email" placeholder="example@email.com" required>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-danger w-100 py-2 fw-bold mb-3">
                                    Nhận Mã Xác Thực OTP
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <div class="text-center small auth-footer-text text-muted">
                        Đã nhớ mật khẩu? <a href="${pageContext.request.contextPath}/login" class="text-danger fw-bold text-decoration-none">Quay lại Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
