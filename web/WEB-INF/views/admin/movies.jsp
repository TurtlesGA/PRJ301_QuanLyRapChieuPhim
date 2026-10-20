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
            </div>
<jsp:include page="common/admin-footer.jsp"/>