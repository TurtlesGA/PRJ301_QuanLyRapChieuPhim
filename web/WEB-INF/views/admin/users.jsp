<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Người Dùng - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Người Dùng - CineStar Admin"/>
    <jsp:param name="activeMenu" value="users"/>
</jsp:include>
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white" data-i18n="admin.users.title">DANH SÁCH NGƯỜI DÙNG</h2>
                <a href="${pageContext.request.contextPath}/admin/user-add" class="btn btn-danger fw-bold">
                    <i class="fa-solid fa-plus me-1"></i><span data-i18n="admin.users.addNew">Thêm Người Dùng Mới</span>
                </a>
            </div>

            <c:if test="${param.msg == 'add_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i><span data-i18n="admin.users.addSuccess">Thêm người dùng mới thành công!</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'update_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i><span data-i18n="admin.users.updateSuccess">Cập nhật thông tin người dùng thành công!</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'delete_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i><span data-i18n="admin.users.deleteSuccess">Xóa người dùng thành công!</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'self_delete'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i><span data-i18n="admin.users.selfDeleteError">Bạn không thể tự xóa tài khoản của chính mình!</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th data-i18n="admin.users.colId">ID</th>
                                <th data-i18n="admin.users.colUsername">TÀI KHOẢN</th>
                                <th data-i18n="admin.users.colFullName">HỌ VÀ TÊN</th>
                                <th data-i18n="admin.users.colEmail">EMAIL</th>
                                <th data-i18n="admin.users.colPhone">SỐ ĐIỆN THOẠI</th>
                                <th data-i18n="admin.users.colRole">VAI TRÒ</th>
                                <th data-i18n="admin.users.colStatus">TRẠNG THÁI</th>
                                <th data-i18n="admin.users.colCreatedAt">NGÀY TẠO</th>
                                <th class="text-end" data-i18n="admin.users.colActions">THAO TÁC</th>
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
                                        <span class="badge badge-status ${u.role == 'ADMIN' ? 'bg-danger' : 'bg-secondary'}" data-status-code="${u.role}">${u.role}</span>
                                    </td>
                                    <td>
                                        <span class="badge badge-status ${u.status ? 'bg-success' : 'bg-danger'}" data-status-code="${u.status ? 'ACTIVE' : 'BANNED'}">
                                            ${u.status ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                    </td>
                                    <td class="small text-muted"><fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/></td>
                                    <td class="text-end">
                                        <div class="action-btns justify-content-end">
                                            <a href="${pageContext.request.contextPath}/admin/user-edit?id=${u.userId}" 
                                               class="btn btn-sm btn-outline-warning" 
                                               data-i18n-title="admin.users.editTitle"
                                               title="Chỉnh sửa thông tin">
                                                <i class="fa-solid fa-pen"></i>
                                            </a>
                                            <c:if test="${u.role ne 'ADMIN'}">
                                                <a href="${pageContext.request.contextPath}/admin/user-toggle?id=${u.userId}" 
                                                   class="btn btn-sm ${u.status ? 'btn-outline-secondary' : 'btn-outline-success'} btn-swal-confirm"
                                                   data-title="${u.status ? 'Khóa tài khoản?' : 'Mở khóa tài khoản?'}"
                                                   data-confirm="${u.status ? 'Bạn có chắc chắn muốn khóa tài khoản này? Người dùng sẽ không thể đăng nhập.' : 'Bạn có muốn mở khóa tài khoản này không?'}"
                                                   data-i18n-confirm-title="${u.status ? 'admin.users.banConfirmTitle' : 'admin.users.unbanConfirmTitle'}"
                                                   data-i18n-confirm="${u.status ? 'admin.users.banConfirm' : 'admin.users.unbanConfirm'}"
                                                   data-icon="${u.status ? 'warning' : 'question'}"
                                                   data-confirm-color="${u.status ? '#dc3545' : '#198754'}"
                                                   data-i18n-title="${u.status ? 'admin.users.banTitle' : 'admin.users.unbanTitle'}"
                                                   title="${u.status ? 'Khóa tài khoản (Ban)' : 'Mở khóa tài khoản'}">
                                                    <i class="fa-solid ${u.status ? 'fa-lock' : 'fa-lock-open'}"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${u.userId ne sessionScope.currentUser.userId}">
                                                <a href="${pageContext.request.contextPath}/admin/user-delete?id=${u.userId}" 
                                                   class="btn btn-sm btn-outline-danger btn-swal-confirm" 
                                                   data-title="Xóa người dùng?"
                                                   data-confirm="Bạn có chắc chắn muốn xóa người dùng '${u.username}'? Mọi dữ liệu đặt vé liên quan cũng sẽ bị xóa vĩnh viễn!"
                                                   data-i18n-confirm-title="admin.users.deleteConfirmTitle"
                                                   data-icon="warning"
                                                   data-confirm-color="#dc3545"
                                                   data-i18n-title="admin.users.deleteTitle"
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

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center mt-3 pt-3 border-top border-secondary gap-2">
                        <div class="text-muted small">
                            <span data-i18n="common.page">Trang</span> <strong>${currentPage}</strong> / <strong>${totalPages}</strong> (<span data-i18n="common.total">Tổng</span> <strong>${totalItems}</strong> <span data-i18n="admin.users.titleUnit">người dùng</span>)
                        </div>
                        <nav aria-label="Pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}"><i class="fa-solid fa-angle-left"></i></a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                        <li class="page-item ${currentPage == p ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${p}">${p}</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${(p == 2 && currentPage - 2 > 2) || (p == totalPages - 1 && currentPage + 2 < totalPages - 1)}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}"><i class="fa-solid fa-angle-right"></i></a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
<jsp:include page="common/admin-footer.jsp"/>