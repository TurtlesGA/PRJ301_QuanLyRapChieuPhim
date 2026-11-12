<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Suất Chiếu - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Suất Chiếu - CineStar Admin"/>
    <jsp:param name="activeMenu" value="showtimes"/>
</jsp:include>
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white mb-0" data-i18n="admin.showtimes.title">DANH SÁCH SUẤT CHIẾU</h2>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" id="btnCleanupShowtimes" 
                            class="btn btn-outline-warning fw-semibold d-inline-flex align-items-center gap-1"
                            data-count="${not empty expiredCount ? expiredCount : 0}"
                            title="Dọn dẹp suất chiếu đã kết thúc trong quá khứ">
                        <i class="fa-solid fa-broom me-1"></i><span data-i18n="admin.showtimes.cleanupBtn">Dọn Dẹp Quá Hạn</span>
                        <c:if test="${expiredCount > 0}">
                            <span class="badge bg-warning text-dark ms-1 rounded-pill">${expiredCount}</span>
                        </c:if>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/showtime-add" class="btn btn-danger fw-bold">
                        <i class="fa-solid fa-plus me-1"></i><span data-i18n="admin.showtimes.addNew">Thêm Suất Chiếu Mới</span>
                    </a>
                </div>
            </div>

            <c:if test="${param.msg == 'cleanup_success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i><span data-i18n="admin.showtimes.cleanupSuccess">Đã dọn dẹp thành công các suất chiếu hết hạn!</span> (Đã xóa <strong>${not empty param.count ? param.count : '0'}</strong> suất)
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <c:choose>
                        <c:when test="${param.error == 'showtime_past'}">Không thể tạo suất chiếu trong quá khứ!</c:when>
                        <c:when test="${param.error == 'showtime_duration'}">Khoảng thời gian chiếu phải lớn hơn hoặc bằng thời lượng của phim!</c:when>
                        <c:when test="${param.error == 'room_conflict'}">Phòng chiếu đã có suất chiếu khác trong khung giờ này!</c:when>
                        <c:otherwise>${param.error}</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>


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
                                    <td class="text-info"><fmt:formatNumber value="${s.basePrice}" type="number"/> <span data-i18n="common.currency">đ</span></td>
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

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center mt-3 pt-3 border-top border-secondary gap-2">
                        <div class="text-muted small">
                            <span data-i18n="common.page">Trang</span> <strong>${currentPage}</strong> / <strong>${totalPages}</strong> (<span data-i18n="common.total">Tổng</span> <strong>${totalItems}</strong> <span data-i18n="admin.showtimes.titleUnit">suất chiếu</span>)
                        </div>
                        <nav aria-label="Pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/showtimes?page=${currentPage - 1}"><i class="fa-solid fa-angle-left"></i></a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                        <li class="page-item ${currentPage == p ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/showtimes?page=${p}">${p}</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${(p == 2 && currentPage - 2 > 2) || (p == totalPages - 1 && currentPage + 2 < totalPages - 1)}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/showtimes?page=${currentPage + 1}"><i class="fa-solid fa-angle-right"></i></a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var cleanupBtn = document.getElementById('btnCleanupShowtimes');
    if (cleanupBtn) {
        cleanupBtn.addEventListener('click', function (e) {
            e.preventDefault();
            var isDark = document.documentElement.getAttribute('data-bs-theme') !== 'light';
            var isEn = (localStorage.getItem('cinema_lang') || 'vi') === 'en';

            Swal.fire({
                title: isEn ? 'Checking expired showtimes...' : 'Đang kiểm tra số lượng...',
                text: isEn ? 'Please wait a moment' : 'Vui lòng chờ trong giây lát',
                allowOutsideClick: false,
                didOpen: function () {
                    Swal.showLoading();
                }
            });

            fetch(window.CONTEXT_PATH + '/admin/showtime-cleanup?action=count')
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    var count = (data && typeof data.count === 'number') ? data.count : (parseInt(cleanupBtn.getAttribute('data-count'), 10) || 0);
                    if (count <= 0) {
                        Swal.fire({
                            icon: 'info',
                            title: isEn ? 'No Expired Showtimes' : 'Không có suất chiếu quá hạn',
                            text: isEn ? 'There are currently no expired showtimes to clean up!' : 'Hiện tại không có suất chiếu nào đã kết thúc cần dọn dẹp. Tất cả các suất chiếu đều đang mở hoặc sắp diễn ra!',
                            confirmButtonColor: '#eab308',
                            background: isDark ? '#1e1e1e' : '#ffffff',
                            color: isDark ? '#f5f5f5' : '#0f172a'
                        });
                        return;
                    }

                    var titleText = isEn ? ('Clean up ' + count + ' expired showtimes?') : ('Dọn dẹp ' + count + ' suất chiếu quá hạn?');
                    var htmlText = isEn 
                        ? ('The system found <strong>' + count + '</strong> expired showtime(s) that have ended.<br>Are you sure you want to permanently delete these <strong>' + count + '</strong> showtime(s)?')
                        : ('Hệ thống phát hiện có <strong>' + count + '</strong> suất chiếu đã kết thúc trong quá khứ.<br>Bạn có chắc chắn muốn dọn dẹp và xóa sạch <strong>' + count + '</strong> suất chiếu này khỏi cơ sở dữ liệu?');
                    var confirmBtn = isEn ? ('<i class="fa-solid fa-broom me-1"></i> Confirm delete ' + count) : ('<i class="fa-solid fa-broom me-1"></i> Xác nhận xóa ' + count + ' suất');
                    var cancelBtn = isEn ? '<i class="fa-solid fa-xmark me-1"></i> Cancel' : '<i class="fa-solid fa-xmark me-1"></i> Hủy bỏ';

                    Swal.fire({
                        title: titleText,
                        html: htmlText,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#eab308',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: confirmBtn,
                        cancelButtonText: cancelBtn,
                        background: isDark ? '#1e1e1e' : '#ffffff',
                        color: isDark ? '#f5f5f5' : '#0f172a',
                        reverseButtons: true,
                        focusCancel: true
                    }).then(function (result) {
                        if (result.isConfirmed) {
                            window.location.href = window.CONTEXT_PATH + '/admin/showtime-cleanup';
                        }
                    });
                })
                .catch(function () {
                    var count = parseInt(cleanupBtn.getAttribute('data-count'), 10) || 0;
                    if (count <= 0) {
                        Swal.fire({
                            icon: 'info',
                            title: 'Không có suất chiếu quá hạn',
                            text: 'Hiện tại không có suất chiếu nào đã kết thúc cần dọn dẹp!',
                            confirmButtonColor: '#eab308'
                        });
                        return;
                    }
                    Swal.fire({
                        title: 'Dọn dẹp ' + count + ' suất chiếu quá hạn?',
                        html: 'Hệ thống phát hiện có <strong>' + count + '</strong> suất chiếu đã kết thúc trong quá khứ.<br>Bạn có chắc chắn muốn xóa sạch <strong>' + count + '</strong> suất chiếu này khỏi cơ sở dữ liệu?',
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#eab308',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: '<i class="fa-solid fa-broom me-1"></i> Xác nhận xóa ' + count + ' suất',
                        cancelButtonText: '<i class="fa-solid fa-xmark me-1"></i> Hủy bỏ'
                    }).then(function (result) {
                        if (result.isConfirmed) {
                            window.location.href = window.CONTEXT_PATH + '/admin/showtime-cleanup';
                        }
                    });
                });
        });
    }
});
</script>

<jsp:include page="common/admin-footer.jsp"/>