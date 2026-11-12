<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Phim - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Quản Lý Phim - CineStar Admin"/>
    <jsp:param name="activeMenu" value="movies"/>
</jsp:include>
            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white" data-i18n="admin.movies.title">DANH SÁCH PHIM</h2>
                <a href="${pageContext.request.contextPath}/admin/movie-add" class="btn btn-danger fw-bold">
                    <i class="fa-solid fa-plus me-1"></i><span data-i18n="admin.movies.addNew">Thêm Phim Mới</span>
                </a>
            </div>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <c:choose>
                        <c:when test="${param.error == 'invalid_duration'}">Thời lượng phim không hợp lệ (Phải từ 1 đến 1440 phút / tối đa 24 giờ)!</c:when>
                        <c:when test="${param.error == 'invalid_dates'}">Ngày khởi chiếu hoặc ngày kết thúc không hợp lệ (Ngày kết thúc không được trước ngày khởi chiếu)!</c:when>
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
                                <th data-i18n="admin.movies.colPoster">POSTER</th>
                                <th data-i18n="admin.movies.colTitle">TÊN PHIM</th>
                                <th data-i18n="admin.movies.colGenre">THỂ LOẠI</th>
                                <th data-i18n="admin.movies.colDuration">THỜI LƯỢNG</th>
                                <th data-i18n="admin.movies.colRelease">KHỞI CHIẾU</th>
                                <th data-i18n="admin.movies.colAgeRating">GIỚI HẠN TUỔI</th>
                                <th data-i18n="admin.movies.colStatus">TRẠNG THÁI</th>
                                <th class="text-end" data-i18n="admin.movies.colActions">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${movies}" var="m">
                                <tr>
                                    <td>
                                        <img src="${m.posterUrl}" style="width: 48px; height: 68px; object-fit: cover; border-radius: 6px;" onerror="this.src='https://placehold.co/48x68/222/fff?text=N/A'">
                                    </td>
                                    <td class="fw-bold text-white"><span class="movie-title" data-original-title="${m.title}">${m.title}</span></td>
                                    <td><span class="movie-genre" data-original-genre="${m.genre}">${m.genre}</span></td>
                                    <td>${m.duration} <span data-i18n="admin.movies.minutes">phút</span></td>
                                    <td><fmt:formatDate value="${m.releaseDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><span class="badge bg-secondary">${m.ageRating}</span></td>
                                    <td>
                                        <span class="badge badge-status ${m.status == 'NOW_SHOWING' ? 'bg-danger' : (m.status == 'COMING_SOON' ? 'bg-warning text-dark' : 'bg-secondary')}" data-status-code="${m.status}">
                                            ${m.status}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <div class="action-btns justify-content-end">
                                            <a href="${pageContext.request.contextPath}/admin/movie-edit?id=${m.movieId}" class="btn btn-sm btn-outline-info" data-i18n-title="admin.movies.editTitle" title="Chỉnh sửa phim">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/movie-delete?id=${m.movieId}" 
                                               class="btn btn-sm btn-outline-danger btn-swal-confirm" 
                                               data-title="Xác nhận xóa phim" 
                                               data-confirm="Bạn có chắc chắn muốn xóa phim này không? Mọi suất chiếu liên quan cũng sẽ bị xóa!"
                                               data-i18n-confirm-title="admin.movies.deleteConfirmTitle"
                                               data-i18n-confirm="admin.movies.deleteConfirm"
                                               data-i18n-title="admin.movies.deleteTitle"
                                               title="Xóa phim">
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
                            <span data-i18n="common.page">Trang</span> <strong>${currentPage}</strong> / <strong>${totalPages}</strong> (<span data-i18n="common.total">Tổng</span> <strong>${totalItems}</strong> <span data-i18n="admin.movies.titleUnit">bộ phim</span>)
                        </div>
                        <nav aria-label="Pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/movies?page=${currentPage - 1}"><i class="fa-solid fa-angle-left"></i></a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                        <li class="page-item ${currentPage == p ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/movies?page=${p}">${p}</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${(p == 2 && currentPage - 2 > 2) || (p == totalPages - 1 && currentPage + 2 < totalPages - 1)}">
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/movies?page=${currentPage + 1}"><i class="fa-solid fa-angle-right"></i></a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
<jsp:include page="common/admin-footer.jsp"/>