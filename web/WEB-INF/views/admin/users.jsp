<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Người Dùng - CineStar Admin" scope="request" />
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Quản Lý Người Dùng - CineStar Admin"/>
</jsp:include>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block admin-sidebar p-3">
            <h6 class="text-uppercase text-muted fw-bold px-3 mb-3 small">Hệ Thống Quản Trị</h6>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-pie me-2"></i>Tổng Quan</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/movies"><i class="fa-solid fa-film me-2"></i>Quản Lý Phim</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/showtimes"><i class="fa-solid fa-clock me-2"></i>Quản Lý Suất Chiếu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-receipt me-2"></i>Lịch Sử Đặt Vé</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2"></i>Người Dùng</a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">DANH SÁCH NGƯỜI DÙNG</h2>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th>ID</th>
                                <th>TÀI KHOẢN</th>
                                <th>HỌ VÀ TÊN</th>
                                <th>EMAIL</th>
                                <th>SỐ ĐIỆN THOẠI</th>
                                <th>VAI TRÒ</th>
                                <th>TRẠNG THÁI</th>
                                <th>NGÀY TẠO</th>
                                <th class="text-end">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="u">
                                <tr>
                                    <td>#${u.userId}</td>
                                    <td class="fw-bold text-white">${u.username}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : 'bg-secondary'}">${u.role}</span>
                                    </td>
                                    <td>
                                        <span class="badge ${u.status ? 'bg-success' : 'bg-danger'}">
                                            ${u.status ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                    </td>
                                    <td class="small text-muted"><fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/></td>
                                    <td class="text-end">
                                        <c:if test="${u.role ne 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/admin/user-toggle?id=${u.userId}" 
                                               class="btn btn-sm ${u.status ? 'btn-outline-danger' : 'btn-outline-success'}"
                                               onclick="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái tài khoản này?');">
                                                <i class="fa-solid ${u.status ? 'fa-lock' : 'fa-lock-open'} me-1"></i>
                                                ${u.status ? 'Khóa' : 'Mở khóa'}
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
