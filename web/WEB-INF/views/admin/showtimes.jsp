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
                    <a href="${pageContext.request.contextPath}/admin/showtime-cleanup" 
                       class="btn btn-outline-warning fw-semibold btn-swal-confirm"
                       data-title="Dọn dẹp suất chiếu quá hạn?"
                       data-confirm="Hệ thống sẽ tự động quét và xóa sạch tất cả các suất chiếu đã kết thúc trong quá khứ khỏi cơ sở dữ liệu."
                       data-icon="question"
                       data-confirm-color="#eab308"
                       data-i18n-title="admin.showtimes.cleanupTitle"
                       data-i18n-confirm-title="admin.showtimes.cleanupConfirmTitle"
                       data-i18n-confirm="admin.showtimes.cleanupConfirm"
                       title="Dọn dẹp suất chiếu đã kết thúc trong quá khứ">
                        <i class="fa-solid fa-broom me-1"></i><span data-i18n="admin.showtimes.cleanupBtn">Dọn Dẹp Quá Hạn</span>
                    </a>
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
<jsp:include page="common/admin-footer.jsp"/>