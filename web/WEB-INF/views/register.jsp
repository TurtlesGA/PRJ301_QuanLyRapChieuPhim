<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="Đăng Ký Tài Khoản - CineStar"/>
</jsp:include>
<jsp:include page="common/navbar.jsp"/>

<main class="main-content py-5 d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card auth-card bg-dark border-secondary p-4 rounded-4 shadow">
                    <div class="text-center mb-4">
                        <i class="fa-solid fa-user-plus text-danger fs-1 mb-2"></i>
                        <h4 class="fw-bold auth-title text-white">ĐĂNG KÝ TÀI KHOẢN</h4>
                        <p class="small auth-subtitle text-muted">Trở thành thành viên để nhận hàng ngàn ưu đãi vé phim</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2 small" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="POST">
                        <div class="mb-3">
                            <label class="form-label auth-label text-light small">Tên đăng nhập *</label>
                            <input type="text" class="form-control" name="username" placeholder="Ví dụ: nguyenvana" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label auth-label text-light small">Họ và tên *</label>
                            <input type="text" class="form-control" name="fullName" placeholder="Ví dụ: Nguyễn Văn A" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label auth-label text-light small">Email *</label>
                                <input type="email" class="form-control" name="email" placeholder="name@example.com" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label auth-label text-light small">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phone" placeholder="0901234567">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label auth-label text-light small">Mật khẩu *</label>
                                <input type="password" class="form-control" name="password" placeholder="Tối thiểu 6 ký tự" required>
                            </div>
                            <div class="col-md-6 mb-4">
                                <label class="form-label auth-label text-light small">Nhập lại mật khẩu *</label>
                                <input type="password" class="form-control" name="confirmPassword" placeholder="Khớp với mật khẩu" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-danger w-100 py-2 fw-bold mb-3">Đăng Ký Tài Khoản</button>
                    </form>

                    <div class="text-center small auth-footer-text text-muted">
                        Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-danger fw-bold text-decoration-none">Đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
