<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Người Dùng - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Người Dùng - CineStar Admin"/>
    <jsp:param name="activeMenu" value="users"/>
</jsp:include>
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white">DANH SÁCH NGƯỜI DÙNG</h2>
                <a href="${pageContext.request.contextPath}/admin/user-add" class="btn btn-danger fw-bold">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Người Dùng Mới
                </a>
            </div>

            <c:if test="${param.msg == 'add_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Thêm người dùng mới thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'update_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Cập nhật thông tin người dùng thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'delete_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Xóa người dùng thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'self_delete'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Bạn không thể tự xóa tài khoản của chính mình!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

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
                                        <div class="action-btns justify-content-end">
                                            <a href="${pageContext.request.contextPath}/admin/user-edit?id=${u.userId}" 
                                               class="btn btn-sm btn-outline-warning" 
                                               title="Chỉnh sửa thông tin">
                                                <i class="fa-solid fa-pen"></i>
                                            </a>
                                            <c:if test="${u.role ne 'ADMIN'}">
                                                <a href="${pageContext.request.contextPath}/admin/user-toggle?id=${u.userId}" 
                                                   class="btn btn-sm ${u.status ? 'btn-outline-secondary' : 'btn-outline-success'} btn-swal-confirm"
                                                   data-title="${u.status ? 'Khóa tài khoản?' : 'Mở khóa tài khoản?'}"
                                                   data-confirm="${u.status ? 'Bạn có chắc chắn muốn khóa tài khoản này? Người dùng sẽ không thể đăng nhập.' : 'Bạn có muốn mở khóa tài khoản này không?'}"
                                                   data-icon="${u.status ? 'warning' : 'question'}"
                                                   data-confirm-color="${u.status ? '#dc3545' : '#198754'}"
                                                   title="${u.status ? 'Khóa tài khoản (Ban)' : 'Mở khóa tài khoản'}">
                                                    <i class="fa-solid ${u.status ? 'fa-lock' : 'fa-lock-open'}"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${u.userId ne sessionScope.currentUser.userId}">
                                                <a href="${pageContext.request.contextPath}/admin/user-delete?id=${u.userId}" 
                                                   class="btn btn-sm btn-outline-danger btn-swal-confirm" 
                                                   data-title="Xóa người dùng?"
                                                   data-confirm="Bạn có chắc chắn muốn xóa người dùng '${u.username}'? Mọi dữ liệu đặt vé liên quan cũng sẽ bị xóa vĩnh viễn!"
                                                   data-icon="warning"
                                                   data-confirm-color="#dc3545"
                                                   title="Xóa người dùng">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
<jsp:include page="common/admin-footer.jsp"/>
