/**
 * CineStar Admin Portal - Scripts
 * Includes SweetAlert2 Confirmation & Flash Notifications, Responsive Sidebar & Theme Toggle
 */

document.addEventListener('DOMContentLoaded', function () {
    const isDarkMode = () => document.documentElement.getAttribute('data-bs-theme') !== 'light';
    const isEn = () => (localStorage.getItem('cinema_lang') || 'vi') === 'en';

    // 1. SweetAlert2 Confirmation for Action Buttons
    document.addEventListener('click', function (e) {
        const targetBtn = e.target.closest('.btn-swal-confirm, [data-confirm]');
        if (!targetBtn) return;

        e.preventDefault();

        const url = targetBtn.getAttribute('href') || targetBtn.getAttribute('data-url');
        const formId = targetBtn.getAttribute('data-form');
        const title = targetBtn.getAttribute('data-title') || (isEn() ? 'Confirm Action' : 'X\u00e1c nh\u1eadn thao t\u00e1c');
        const message = targetBtn.getAttribute('data-confirm') || (isEn() ? 'Are you sure you want to perform this action?' : 'B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n th\u1ef1c hi\u1ec7n h\u00e0nh \u0111\u1ed9ng n\u00e0y?');
        const icon = targetBtn.getAttribute('data-icon') || 'warning';
        const confirmText = targetBtn.getAttribute('data-confirm-text') || (isEn() ? '<i class="fa-solid fa-check me-1"></i> Confirm' : '<i class="fa-solid fa-check me-1"></i> X\u00e1c nh\u1eadn');
        const cancelButtonText = targetBtn.getAttribute('data-cancel-text') || (isEn() ? '<i class="fa-solid fa-xmark me-1"></i> Cancel' : '<i class="fa-solid fa-xmark me-1"></i> H\u1ee7y b\u1ecf');
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
            cancelButtonText: cancelButtonText,
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
        const en = isEn();
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
            Toast.fire({ icon: 'success', title: en ? 'Added successfully!' : 'Th\u00eam m\u1edbi th\u00e0nh c\u00f4ng!' });
        } else if (msg === 'update_success') {
            Toast.fire({ icon: 'success', title: en ? 'Updated successfully!' : 'C\u1eadp nh\u1eadt th\u00f4ng tin th\u00e0nh c\u00f4ng!' });
        } else if (msg === 'delete_success') {
            Toast.fire({ icon: 'success', title: en ? 'Deleted successfully!' : '\u0110\u00e3 x\u00f3a d\u1eef li\u1ec7u th\u00e0nh c\u00f4ng!' });
        } else if (err === 'self_delete') {
            Toast.fire({ icon: 'error', title: en ? 'Cannot delete your currently logged-in account!' : 'Kh\u00f4ng th\u1ec3 x\u00f3a t\u00e0i kho\u1ea3n \u0111ang \u0111\u0103ng nh\u1eadp!' });
        } else if (err === 'invalid_duration') {
            Toast.fire({ icon: 'error', title: en ? 'Invalid duration! (Must be between 1 and 1440 minutes / 24h)' : 'Th\u1eddi l\u01b0\u1ee3ng phim kh\u00f4ng h\u1ee3p l\u1ec7! (Ph\u1ea3i t\u1eeb 1 \u0111\u1ebfn 1440 ph\u00fat / 24 gi\u1edd)' });
        } else if (err === 'invalid_dates') {
            Toast.fire({ icon: 'error', title: en ? 'Invalid release/end dates!' : 'Ng\u00e0y kh\u1edfi chi\u1ebfu ho\u1eb7c ng\u00e0y k\u1ebft th\u00fac kh\u00f4ng h\u1ee3p l\u1ec7!' });
        } else if (err === 'showtime_past') {
            Toast.fire({ icon: 'error', title: en ? 'Cannot schedule showtime in the past!' : 'Kh\u00f4ng th\u1ec3 t\u1ea1o su\u1ea5t chi\u1ebfu trong qu\u00e1 kh\u1ee9!' });
        } else if (err === 'showtime_duration') {
            Toast.fire({ icon: 'error', title: en ? 'Showtime interval must be greater than or equal to movie duration!' : 'Kho\u1ea3ng th\u1eddi gian chi\u1ebfu ph\u1ea3i l\u1edbn h\u01a1n ho\u1eb7c b\u1eb1ng th\u1eddi l\u01b0\u1ee3ng c\u1ee7a phim!' });
        } else if (err === 'room_conflict') {
            Toast.fire({ icon: 'error', title: en ? 'Screening room conflict detected!' : 'Ph\u00f2ng chi\u1ebfu \u0111\u00e3 c\u00f3 su\u1ea5t chi\u1ebfu kh\u00e1c trong khung gi\u1edd n\u00e0y!' });
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
