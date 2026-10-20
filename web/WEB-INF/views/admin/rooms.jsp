<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Phòng Chiếu - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Phòng Chiếu - CineStar Admin"/>
    <jsp:param name="activeMenu" value="rooms"/>
</jsp:include>
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white" data-i18n="admin.rooms.title">DANH SÁCH PHÒNG CHIẾU</h2>
                <a href="${pageContext.request.contextPath}/admin/room-add" class="btn btn-danger fw-bold">
                    <i class="fa-solid fa-plus me-1"></i><span data-i18n="admin.rooms.addNew">Thêm Phòng Mới</span>
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th data-i18n="admin.rooms.colId">ID</th>
                                <th data-i18n="admin.rooms.colName">TÊN PHÒNG</th>
                                <th data-i18n="admin.rooms.colType">LOẠI PHÒNG</th>
                                <th data-i18n="admin.rooms.colRows">SỐ HÀNG</th>
                                <th data-i18n="admin.rooms.colSeatsPerRow">SỐ GHẾ/HÀNG</th>
                                <th data-i18n="admin.rooms.colTotal">TỔNG GHẾ</th>
                                <th data-i18n="admin.rooms.colStatus">TRẠNG THÁI</th>
                                <th class="text-end" data-i18n="admin.rooms.colActions">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${rooms}" var="r">
                                <tr>
                                    <td>#${r.roomId}</td>
                                    <td class="fw-bold text-white">${r.roomName}</td>
                                    <td><span class="badge bg-secondary">${r.roomType}</span></td>
                                    <td>${r.totalRows} <span data-i18n="admin.rooms.rows">hàng</span></td>
                                    <td>${r.totalCols} <span data-i18n="admin.rooms.seats">ghế</span></td>
                                    <td class="text-warning fw-bold">${r.totalRows * r.totalCols} <span data-i18n="admin.rooms.seats">ghế</span></td>
                                    <td>
                                        <span class="badge badge-status ${r.status ? 'bg-success' : 'bg-danger'}" data-status-code="${r.status ? 'ACTIVE' : 'INACTIVE'}">
                                            ${r.status ? 'Hoạt động' : 'Tạm dừng'}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <div class="action-btns justify-content-end">
                                            <a href="${pageContext.request.contextPath}/admin/room-edit?id=${r.roomId}" class="btn btn-sm btn-outline-warning" data-i18n-title="admin.rooms.editTitle" title="Chỉnh sửa phòng">
                                                <i class="fa-solid fa-pen"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/room-toggle?id=${r.roomId}" 
                                               class="btn btn-sm ${r.status ? 'btn-outline-secondary' : 'btn-outline-success'} btn-swal-confirm"
                                               data-title="Xác nhận đổi trạng thái"
                                               data-confirm="Bạn có chắc chắn muốn thay đổi trạng thái hoạt động của phòng chiếu này?"
                                               data-i18n-confirm-title="admin.rooms.toggleConfirmTitle"
                                               data-i18n-confirm="admin.rooms.toggleConfirm"
                                               data-icon="question"
                                               data-confirm-color="#4f46e5"
                                               data-i18n-title="${r.status ? 'admin.rooms.pauseTitle' : 'admin.rooms.resumeTitle'}"
                                               title="${r.status ? 'Tạm dừng phòng' : 'Mở hoạt động'}">
                                                <i class="fa-solid ${r.status ? 'fa-pause' : 'fa-play'}"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/room-delete?id=${r.roomId}" 
                                               class="btn btn-sm btn-outline-danger btn-swal-confirm" 
                                               data-title="Xác nhận xóa phòng chiếu"
                                               data-confirm="Bạn có chắc chắn muốn xóa phòng chiếu này? Mọi ghế và dữ liệu liên quan sẽ bị xóa!"
                                               data-i18n-confirm-title="admin.rooms.deleteConfirmTitle"
                                               data-i18n-confirm="admin.rooms.deleteConfirm"
                                               data-i18n-title="admin.rooms.deleteTitle"
                                               title="Xóa phòng chiếu">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
<jsp:include page="common/admin-footer.jsp"/>