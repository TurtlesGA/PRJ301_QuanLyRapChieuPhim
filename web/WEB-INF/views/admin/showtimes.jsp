<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Suất Chiếu - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Suất Chiếu - CineStar Admin"/>
    <jsp:param name="activeMenu" value="showtimes"/>
</jsp:include>
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white" data-i18n="admin.showtimes.title">DANH SÁCH SUẤT CHIẾU</h2>
                <a href="${pageContext.request.contextPath}/admin/showtime-add" class="btn btn-danger fw-bold">
                    <i class="fa-solid fa-plus me-1"></i><span data-i18n="admin.showtimes.addNew">Thêm Suất Chiếu Mới</span>
                </a>
            </div>

            <div class="card bg-dark border-secondary rounded-4 p-3 shadow">
                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle mb-0">
                        <thead class="text-secondary small">
                            <tr>
                                <th data-i18n="admin.showtimes.colId">ID</th>
                                <th data-i18n="admin.showtimes.colMovie">PHIM</th>
                                <th data-i18n="admin.showtimes.colRoom">PHÒNG CHIẾU</th>
                                <th data-i18n="admin.showtimes.colDate">NGÀY CHIẾU</th>
                                <th data-i18n="admin.showtimes.colStart">GIỜ BẮT ĐẦU</th>
                                <th data-i18n="admin.showtimes.colEnd">GIỜ KẾT THÚC</th>
                                <th data-i18n="admin.showtimes.colPrice">GIÁ VÉ GỐC</th>
                                <th data-i18n="admin.showtimes.colStatus">TRẠNG THÁI</th>
                                <th class="text-end" data-i18n="admin.showtimes.colActions">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${showtimes}" var="s">
                                <tr>
                                    <td>#${s.showtimeId}</td>
                                    <td class="fw-bold text-white"><span class="movie-title" data-original-title="${s.movie.title}">${s.movie.title}</span></td>
                                    <td><span class="badge bg-secondary"><span class="room-name" data-original-room="${s.room.roomName}">${s.room.roomName}</span> (${s.room.roomType})</span></td>
                                    <td><fmt:formatDate value="${s.showDate}" pattern="dd/MM/yyyy"/></td>
                                    <td class="text-warning fw-bold"><fmt:formatDate value="${s.startTime}" pattern="HH:mm"/></td>
                                    <td><fmt:formatDate value="${s.endTime}" pattern="HH:mm"/></td>
                                    <td class="text-info"><fmt:formatNumber value="${s.basePrice}" type="number"/> đ</td>
                                    <td><span class="badge badge-status ${s.status == 'OPEN' ? 'bg-success' : 'bg-secondary'}" data-status-code="${s.status}">${s.status}</span></td>
                                    <td class="text-end">
                                        <div class="action-btns justify-content-end">
                                            <a href="${pageContext.request.contextPath}/admin/showtime-delete?id=${s.showtimeId}" 
                                               class="btn btn-sm btn-outline-danger btn-swal-confirm" 
                                               data-title="Xác nhận xóa suất chiếu"
                                               data-confirm="Bạn có chắc chắn muốn xóa suất chiếu này? Các thông tin đặt vé liên quan cũng sẽ bị ảnh hưởng!"
                                               data-i18n-confirm-title="admin.showtimes.deleteConfirmTitle"
                                               data-i18n-confirm="admin.showtimes.deleteConfirm"
                                               data-i18n-title="admin.showtimes.deleteTitle"
                                               title="Xóa suất chiếu">
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