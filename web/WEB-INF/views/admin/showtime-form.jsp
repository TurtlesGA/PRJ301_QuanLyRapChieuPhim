<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Thêm Suất Chiếu Mới - CineStar Admin" scope="request" />
<jsp:include page="common/admin-header.jsp">
    <jsp:param name="title" value="Thêm Suất Chiếu Mới - CineStar Admin"/>
    <jsp:param name="activeMenu" value="showtimes"/>
</jsp:include>

            <div class="d-flex justify-content-between align-items-center pb-2 mb-4 border-bottom border-secondary">
                <h2 class="h3 fw-bold text-white" data-i18n="admin.showtimeForm.title">THÊM SUẤT CHIẾU MỚI</h2>
                <a href="${pageContext.request.contextPath}/admin/showtimes" class="btn btn-admin-back btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i><span data-i18n="admin.showtimeForm.back">Quay Lại</span>
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i><strong>Lỗi:</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card bg-dark border-secondary rounded-4 p-4 shadow">
                <form id="showtimeForm" action="${pageContext.request.contextPath}/admin/showtimes" method="POST">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.showtimeForm.selectMovie">Chọn phim *</label>
                            <select class="form-select" name="movieId" id="movieSelect" required>
                                <option value="">-- Chọn phim --</option>
                                <c:forEach items="${movies}" var="m">
                                    <option value="${m.movieId}" class="movie-option" 
                                            ${param.movieId == m.movieId ? 'selected' : ''}
                                            data-original-title="${m.title}" 
                                            data-duration="${m.duration}" 
                                            data-release="${m.releaseDate}" 
                                            data-end="${m.endDate != null ? m.endDate : ''}">
                                        ${m.title} (${m.duration} phút)
                                    </option>
                                </c:forEach>
                            </select>
                            <div id="movieInfoNotice" class="form-text small text-info mt-1"></div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.showtimeForm.selectRoom">Chọn phòng chiếu *</label>
                            <select class="form-select" name="roomId" id="roomSelect" required>
                                <option value="">-- Chọn phòng chiếu --</option>
                                <c:forEach items="${rooms}" var="r">
                                    <option value="${r.roomId}" class="room-option" ${param.roomId == r.roomId ? 'selected' : ''} data-original-room="${r.roomName}">
                                        ${r.roomName} (${r.roomType})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.showtimeForm.showDate">Ngày chiếu *</label>
                            <input type="date" class="form-control" name="showDate" id="showDateInput" value="${param.showDate}" required>
                            <div id="showDateHint" class="form-text small text-muted mt-1"></div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.showtimeForm.startTime">Giờ bắt đầu *</label>
                            <input type="time" class="form-control" name="startTime" id="startTimeInput" value="${param.startTime}" required>
                            <div id="startTimeHint" class="form-text small text-muted mt-1"></div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.showtimeForm.endTime">Giờ kết thúc *</label>
                            <input type="time" class="form-control" name="endTime" id="endTimeInput" value="${param.endTime}" required>
                            <div id="endTimeHint" class="form-text small text-muted mt-1"></div>
                        </div>

                        <div class="col-12" id="timeDiffBox" style="display: none;">
                            <div class="p-3 rounded-3 border bg-dark-subtle d-flex align-items-center gap-2" id="timeDiffContainer">
                                <i id="timeDiffIcon" class="fa-solid fa-circle-info"></i>
                                <span id="timeDiffText" class="small fw-semibold"></span>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-light small fw-semibold" data-i18n="admin.showtimeForm.basePrice">Giá vé cơ bản (VNĐ) *</label>
                            <input type="number" step="5000" class="form-control" name="basePrice" id="basePriceInput" value="${not empty param.basePrice ? param.basePrice : '85000'}" min="0" required>
                        </div>

                        <div class="col-12 mt-4 d-flex gap-2">
                            <button type="button" id="btnSubmitShowtime" class="btn btn-danger fw-bold px-4 py-2">
                                <i class="fa-solid fa-calendar-plus me-1"></i><span data-i18n="admin.showtimeForm.submit">Thêm Suất Chiếu</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/showtimes" class="btn btn-admin-back px-4 py-2" data-i18n="admin.showtimeForm.cancel">
                                Hủy
                            </a>
                        </div>
                    </div>
                </form>
            </div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var form = document.getElementById('showtimeForm');
    var movieSelect = document.getElementById('movieSelect');
    var showDateInput = document.getElementById('showDateInput');
    var startTimeInput = document.getElementById('startTimeInput');
    var endTimeInput = document.getElementById('endTimeInput');
    var movieInfoNotice = document.getElementById('movieInfoNotice');
    var startTimeHint = document.getElementById('startTimeHint');
    var endTimeHint = document.getElementById('endTimeHint');
    var timeDiffBox = document.getElementById('timeDiffBox');
    var timeDiffContainer = document.getElementById('timeDiffContainer');
    var timeDiffIcon = document.getElementById('timeDiffIcon');
    var timeDiffText = document.getElementById('timeDiffText');
    var btnSubmit = document.getElementById('btnSubmitShowtime');

    var todayStr = new Date().toISOString().split('T')[0];
    showDateInput.min = todayStr;

    function getSelectedMovieData() {
        var opt = movieSelect.options[movieSelect.selectedIndex];
        if (!opt || !opt.value) return null;
        return {
            id: opt.value,
            title: opt.getAttribute('data-original-title') || opt.text,
            duration: parseInt(opt.getAttribute('data-duration'), 10) || 0,
            release: opt.getAttribute('data-release') || '',
            end: opt.getAttribute('data-end') || ''
        };
    }

    function toMins(t) {
        if (!t) return -1;
        var p = t.split(':');
        return parseInt(p[0], 10) * 60 + parseInt(p[1], 10);
    }

    function toTimeStr(m) {
        var h = Math.floor(m / 60) % 24;
        var min = m % 60;
        return (h < 10 ? '0' + h : h) + ':' + (min < 10 ? '0' + min : min);
    }

    function updateMovieNotice() {
        var m = getSelectedMovieData();
        if (!m) {
            movieInfoNotice.innerHTML = '';
            showDateInput.min = todayStr;
            showDateInput.removeAttribute('max');
            return;
        }
        showDateInput.min = (m.release && m.release > todayStr) ? m.release : todayStr;
        if (m.end) showDateInput.max = m.end; else showDateInput.removeAttribute('max');

        var note = '<i class="fa-solid fa-circle-info me-1"></i>Thời lượng: <strong>' + m.duration + ' phút</strong>';
        if (m.release) note += ' | Khởi chiếu: ' + m.release;
        if (m.end) note += ' - Kết thúc: ' + m.end;
        movieInfoNotice.innerHTML = note;

        if (startTimeInput.value && (!endTimeInput.value || endTimeInput.dataset.autoSet === 'true')) {
            var sM = toMins(startTimeInput.value);
            if (sM >= 0 && m.duration > 0) {
                endTimeInput.value = toTimeStr(sM + m.duration);
                endTimeInput.dataset.autoSet = 'true';
            }
        }
        validateTimes();
    }

    function validateTimes() {
        var m = getSelectedMovieData();
        var sVal = startTimeInput.value, eVal = endTimeInput.value;
        startTimeHint.innerHTML = '';
        endTimeHint.innerHTML = '';
        if (!sVal || !eVal) { timeDiffBox.style.display = 'none'; return; }

        if (showDateInput.value === todayStr && sVal) {
            var now = new Date();
            if (toMins(sVal) <= (now.getHours() * 60 + now.getMinutes())) {
                startTimeHint.innerHTML = '<span class="text-danger"><i class="fa-solid fa-triangle-exclamation me-1"></i>Giờ bắt đầu không được ở trong quá khứ!</span>';
            }
        }

        var sM = toMins(sVal), eM = toMins(eVal);
        timeDiffBox.style.display = 'block';

        if (eM <= sM) {
            timeDiffContainer.className = 'p-3 rounded-3 border border-danger bg-danger bg-opacity-10 d-flex align-items-center gap-2';
            timeDiffIcon.className = 'fa-solid fa-triangle-exclamation text-danger fs-5';
            timeDiffText.className = 'small fw-semibold text-danger';
            timeDiffText.innerHTML = 'Giờ kết thúc (' + eVal + ') phải sau giờ bắt đầu (' + sVal + ')!';
            return;
        }

        var diff = eM - sM, dur = m ? m.duration : 0;
        if (dur > 0 && diff < dur) {
            timeDiffContainer.className = 'p-3 rounded-3 border border-warning bg-warning bg-opacity-10 d-flex align-items-center gap-2';
            timeDiffIcon.className = 'fa-solid fa-triangle-exclamation text-warning fs-5';
            timeDiffText.className = 'small fw-semibold text-warning';
            timeDiffText.innerHTML = 'Khoảng cách chiếu: <strong>' + diff + ' phút</strong> (Không đủ thời lượng phim: <strong>' + dur + ' phút</strong>)!';
        } else {
            timeDiffContainer.className = 'p-3 rounded-3 border border-success bg-success bg-opacity-10 d-flex align-items-center gap-2';
            timeDiffIcon.className = 'fa-solid fa-circle-check text-success fs-5';
            timeDiffText.className = 'small fw-semibold text-success';
            timeDiffText.innerHTML = 'Khoảng cách chiếu: <strong>' + diff + ' phút</strong> (Hợp lệ, ≥ ' + dur + ' phút thời lượng phim).';
        }
    }

    movieSelect.addEventListener('change', updateMovieNotice);
    startTimeInput.addEventListener('input', function () {
        var m = getSelectedMovieData();
        if (m && m.duration > 0 && startTimeInput.value) {
            var sM = toMins(startTimeInput.value);
            if (sM >= 0) {
                endTimeInput.value = toTimeStr(sM + m.duration);
                endTimeInput.dataset.autoSet = 'true';
            }
        }
        validateTimes();
    });
    endTimeInput.addEventListener('input', function () {
        endTimeInput.dataset.autoSet = 'false';
        validateTimes();
    });
    showDateInput.addEventListener('change', validateTimes);
    updateMovieNotice();

    if (btnSubmit) {
        btnSubmit.addEventListener('click', function (e) {
            e.preventDefault();

            var movie = getSelectedMovieData();
            if (!movie) {
                Swal.fire({ icon: 'warning', title: 'Chưa chọn phim', text: 'Vui lòng chọn bộ phim cho suất chiếu!', confirmButtonColor: '#dc2626' });
                movieSelect.focus();
                return;
            }

            var roomVal = document.getElementById('roomSelect').value;
            if (!roomVal) {
                Swal.fire({ icon: 'warning', title: 'Chưa chọn phòng chiếu', text: 'Vui lòng chọn phòng chiếu!', confirmButtonColor: '#dc2626' });
                return;
            }

            var showDate = showDateInput.value;
            if (!showDate) {
                Swal.fire({ icon: 'warning', title: 'Thiếu ngày chiếu', text: 'Vui lòng chọn ngày chiếu!', confirmButtonColor: '#dc2626' });
                showDateInput.focus();
                return;
            }

            if (showDate < todayStr) {
                Swal.fire({ icon: 'error', title: 'Ngày chiếu không hợp lệ', text: 'Không thể tạo suất chiếu trong quá khứ (' + showDate + ')!', confirmButtonColor: '#dc2626' });
                showDateInput.focus();
                return;
            }

            if (movie.release && showDate < movie.release) {
                Swal.fire({ icon: 'error', title: 'Ngày chiếu trước ngày khởi chiếu', text: 'Phim bắt đầu khởi chiếu từ ' + movie.release + '. Không thể lên lịch chiếu trước ngày này!', confirmButtonColor: '#dc2626' });
                showDateInput.focus();
                return;
            }
            if (movie.end && showDate > movie.end) {
                Swal.fire({ icon: 'error', title: 'Ngày chiếu sau ngày ngừng chiếu', text: 'Phim kết thúc chiếu từ ngày ' + movie.end + '. Không thể lên lịch chiếu sau ngày này!', confirmButtonColor: '#dc2626' });
                showDateInput.focus();
                return;
            }

            var sVal = startTimeInput.value;
            var eVal = endTimeInput.value;
            if (!sVal || !eVal) {
                Swal.fire({ icon: 'warning', title: 'Thiếu thời gian chiếu', text: 'Vui lòng nhập đầy đủ giờ bắt đầu và giờ kết thúc!', confirmButtonColor: '#dc2626' });
                return;
            }

            if (showDate === todayStr) {
                var now = new Date();
                if (toMins(sVal) <= (now.getHours() * 60 + now.getMinutes())) {
                    Swal.fire({ icon: 'error', title: 'Giờ bắt đầu không hợp lệ', text: 'Giờ bắt đầu (' + sVal + ') không được ở trong quá khứ so với thời điểm hiện tại!', confirmButtonColor: '#dc2626' });
                    startTimeInput.focus();
                    return;
                }
            }

            var sM = toMins(sVal);
            var eM = toMins(eVal);

            if (eM <= sM) {
                Swal.fire({ icon: 'error', title: 'Khoảng thời gian không hợp lệ', text: 'Giờ kết thúc (' + eVal + ') phải sau giờ bắt đầu (' + sVal + ')!', confirmButtonColor: '#dc2626' });
                endTimeInput.focus();
                return;
            }

            var diff = eM - sM;
            if (diff < movie.duration) {
                Swal.fire({
                    icon: 'error',
                    title: 'Thời gian chiếu không đủ',
                    html: 'Khoảng thời gian giữa giờ bắt đầu và kết thúc là <strong>' + diff + ' phút</strong>, nhỏ hơn thời lượng của phim (<strong>' + movie.duration + ' phút</strong>)!<br>Vui lòng điều chỉnh lại giờ kết thúc hợp lý.',
                    confirmButtonColor: '#dc2626'
                });
                endTimeInput.focus();
                return;
            }

            var isDark = document.documentElement.getAttribute('data-bs-theme') !== 'light';
            Swal.fire({
                title: 'Xác nhận tạo suất chiếu',
                html: 'Tạo suất chiếu cho phim <strong>' + movie.title + '</strong><br>' +
                      'Ngày: <strong>' + showDate + '</strong> | Khung giờ: <strong>' + sVal + ' - ' + eVal + '</strong> (' + diff + ' phút)?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#dc2626',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fa-solid fa-check me-1"></i> Xác nhận tạo',
                cancelButtonText: '<i class="fa-solid fa-xmark me-1"></i> Hủy',
                background: isDark ? '#1e1e1e' : '#ffffff',
                color: isDark ? '#f5f5f5' : '#0f172a',
                reverseButtons: true
            }).then(function (result) {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
        });
    }
});
</script>

<jsp:include page="common/admin-footer.jsp"/>