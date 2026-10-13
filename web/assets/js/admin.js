/**
 * CineStar Admin Portal - Scripts
 * Includes SweetAlert2 Confirmation & Flash Notifications, Responsive Sidebar & Theme Toggle
 */

document.addEventListener('DOMContentLoaded', function () {
    const isDarkMode = () => document.documentElement.getAttribute('data-bs-theme') !== 'light';

    // 1. SweetAlert2 Confirmation for Action Buttons
    document.addEventListener('click', function (e) {
        const targetBtn = e.target.closest('.btn-swal-confirm, [data-confirm]');
        if (!targetBtn) return;

        e.preventDefault();

        const url = targetBtn.getAttribute('href') || targetBtn.getAttribute('data-url');
        const formId = targetBtn.getAttribute('data-form');
        const title = targetBtn.getAttribute('data-title') || 'Xác nhận thao tác';
        const message = targetBtn.getAttribute('data-confirm') || 'Bạn có chắc chắn muốn thực hiện hành động này?';
        const icon = targetBtn.getAttribute('data-icon') || 'warning';
        const confirmText = targetBtn.getAttribute('data-confirm-text') || '<i class="fa-solid fa-check me-1"></i> Xác nhận';
        const confirmColor = targetBtn.getAttribute('data-confirm-color') || '#dc2626';

        const dark = isDarkMode();
        Swal.fire({
            title: title,
            text: message,
            icon: icon,
            showCancelButton: true,
            confirmButtonColor: confirmColor,
            cancelButtonColor: '#6b7280',
            confirmButtonText: confirmText,
            cancelButtonText: '<i class="fa-solid fa-xmark me-1"></i> Hủy bỏ',
            background: dark ? '#1e1e1e' : '#ffffff',
            color: dark ? '#f5f5f5' : '#0f172a',
            reverseButtons: true,
            focusCancel: true,
            customClass: {
                popup: 'rounded-4 shadow-lg border ' + (dark ? 'border-secondary' : 'border-light-subtle')
            }
        }).then((result) => {
            if (result.isConfirmed) {
                if (formId) {
                    const form = document.getElementById(formId);
                    if (form) form.submit();
                } else if (url && url !== '#') {
                    window.location.href = url;
                }
            }
        });
    });

    // 2. SweetAlert2 Flash Notifications from URL Parameters
    const urlParams = new URLSearchParams(window.location.search);
    const msg = urlParams.get('msg');
    const err = urlParams.get('error');

    if (msg || err) {
        const dark = isDarkMode();
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3500,
            timerProgressBar: true,
            background: dark ? '#1e1e1e' : '#ffffff',
            color: dark ? '#f5f5f5' : '#0f172a',
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer);
                toast.addEventListener('mouseleave', Swal.resumeTimer);
            }
        });

        if (msg === 'add_success') {
            Toast.fire({ icon: 'success', title: 'Thêm mới thành công!' });
        } else if (msg === 'update_success') {
            Toast.fire({ icon: 'success', title: 'Cập nhật thông tin thành công!' });
        } else if (msg === 'delete_success') {
            Toast.fire({ icon: 'success', title: 'Đã xóa dữ liệu thành công!' });
        } else if (err === 'self_delete') {
            Toast.fire({ icon: 'error', title: 'Không thể xóa tài khoản đang đăng nhập!' });
        } else if (err) {
            Toast.fire({ icon: 'error', title: err });
        }
    }

    // 3. Admin Theme Toggle (Dark / Light Mode)
    const themeToggleBtn = document.getElementById('themeToggle');
    if (themeToggleBtn) {
        const lightIcon = themeToggleBtn.querySelector('.theme-icon.light');
        const darkIcon = themeToggleBtn.querySelector('.theme-icon.dark');

        function updateThemeIcons(theme) {
            if (theme === 'light') {
                if (lightIcon) lightIcon.classList.add('active');
                if (darkIcon) darkIcon.classList.remove('active');
            } else {
                if (darkIcon) darkIcon.classList.add('active');
                if (lightIcon) lightIcon.classList.remove('active');
            }
        }

        const initialTheme = document.documentElement.getAttribute('data-bs-theme') || localStorage.getItem('cinema_theme') || 'dark';
        updateThemeIcons(initialTheme);

        themeToggleBtn.addEventListener('click', function () {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'dark';
            const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';

            document.documentElement.setAttribute('data-bs-theme', nextTheme);
            localStorage.setItem('cinema_theme', nextTheme);
            updateThemeIcons(nextTheme);
        });
    }
});
