/**
 * Cinema System - Main Frontend Scripts
 */

document.addEventListener('DOMContentLoaded', function () {
    const seatButtons = document.querySelectorAll('.seat-btn:not(.booked)');
    const selectedSeatsInput = document.getElementById('selectedSeatsInput');
    const selectedSeatCodesSpan = document.getElementById('selectedSeatCodes');
    const totalPriceSpan = document.getElementById('totalPrice');
    const checkoutBtn = document.getElementById('checkoutBtn');

    if (seatButtons.length > 0 && selectedSeatsInput) {
        let selectedSeats = [];

        seatButtons.forEach(btn => {
            btn.addEventListener('click', function () {
                const seatId = parseInt(this.getAttribute('data-seat-id'));
                const seatCode = this.getAttribute('data-seat-code');
                const seatPrice = parseFloat(this.getAttribute('data-price'));

                const index = selectedSeats.findIndex(s => s.id === seatId);
                if (index > -1) {
                    selectedSeats.splice(index, 1);
                    this.classList.remove('selected');
                } else {
                    if (selectedSeats.length >= 8) {
                        const defaultMaxMsg = 'B\u1ea1n ch\u1ec9 c\u00f3 th\u1ec3 \u0111\u1eb7t t\u1ed1i \u0111a 8 gh\u1ebf trong m\u1ed9t l\u1ea7n \u0111\u1eb7t!';
                        const alertMsg = (window.CinemaI18n && window.CinemaI18n.t) ? window.CinemaI18n.t('seatSelection.maxSeats', defaultMaxMsg) : defaultMaxMsg;
                        if (typeof Swal !== 'undefined') {
                            const dark = document.documentElement.getAttribute('data-bs-theme') !== 'light';
                            const isEn = (window.CinemaI18n && window.CinemaI18n.getLang() === 'en');
                            Swal.fire({
                                icon: 'warning',
                                title: isEn ? 'Seat Limit' : 'Gi\u1edbi h\u1ea1n gh\u1ebf ng\u1ed3i',
                                text: alertMsg,
                                confirmButtonColor: '#e50914',
                                confirmButtonText: isEn ? 'OK' : '\u0110\u00e3 hi\u1ec3u',
                                background: dark ? '#1e1e1e' : '#ffffff',
                                color: dark ? '#f5f5f5' : '#0f172a',
                                customClass: {
                                    popup: 'rounded-4 shadow-lg border ' + (dark ? 'border-secondary' : 'border-light-subtle')
                                }
                            });
                        } else {
                            alert(alertMsg);
                        }
                        return;
                    }
                    selectedSeats.push({ id: seatId, code: seatCode, price: seatPrice });
                    this.classList.add('selected');
                }

                updateBookingSummary();
            });
        });

        function updateBookingSummary() {
            const defaultNoSeat = 'Ch\u01b0a ch\u1ecdn gh\u1ebf';
            const noSeatText = (window.CinemaI18n && window.CinemaI18n.t) ? window.CinemaI18n.t('seatSelection.noSeatSelected', defaultNoSeat) : defaultNoSeat;
            const currencySymbol = (window.CinemaI18n && window.CinemaI18n.t) ? window.CinemaI18n.t('seatSelection.currency', '\u0111') : '\u0111';

            if (selectedSeats.length === 0) {
                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = noSeatText;
                if (totalPriceSpan) totalPriceSpan.textContent = '0 ' + currencySymbol;
                if (selectedSeatsInput) selectedSeatsInput.value = '';
                if (checkoutBtn) checkoutBtn.disabled = true;
            } else {
                const codes = selectedSeats.map(s => s.code).join(', ');
                const total = selectedSeats.reduce((sum, s) => sum + s.price, 0);
                const ids = selectedSeats.map(s => s.id).join(',');

                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = codes;
                if (totalPriceSpan) totalPriceSpan.textContent = total.toLocaleString('vi-VN') + ' ' + currencySymbol;
                if (selectedSeatsInput) selectedSeatsInput.value = ids;
                if (checkoutBtn) checkoutBtn.disabled = false;
            }
        }

        window.addEventListener('cinema:langChanged', function () {
            updateBookingSummary();
        });
    }

    const themeToggleBtns = document.querySelectorAll('.theme-toggle-btn');
    if (themeToggleBtns.length > 0) {
        function updateAllThemeIcons(theme) {
            themeToggleBtns.forEach(btn => {
                const lightIcon = btn.querySelector('.theme-icon.light');
                const darkIcon = btn.querySelector('.theme-icon.dark');
                if (theme === 'light') {
                    if (lightIcon) lightIcon.classList.add('active');
                    if (darkIcon) darkIcon.classList.remove('active');
                } else {
                    if (darkIcon) darkIcon.classList.add('active');
                    if (lightIcon) lightIcon.classList.remove('active');
                }
            });
        }

        const initialTheme = document.documentElement.getAttribute('data-bs-theme') || localStorage.getItem('cinema_theme') || 'dark';
        updateAllThemeIcons(initialTheme);

        themeToggleBtns.forEach(btn => {
            btn.addEventListener('click', function () {
                const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'dark';
                const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';

                document.documentElement.setAttribute('data-bs-theme', nextTheme);
                localStorage.setItem('cinema_theme', nextTheme);
                updateAllThemeIcons(nextTheme);
            });
        });
    }

    // SweetAlert2 Confirmation for Client Action Buttons (e.g. My Bookings Cancel)
    document.addEventListener('click', function (e) {
        const targetBtn = e.target.closest('.btn-swal-confirm, [data-confirm]');
        if (!targetBtn) return;
        if (window.location.pathname.includes('/admin/')) return; // handled by admin.js

        e.preventDefault();

        const url = targetBtn.getAttribute('href') || targetBtn.getAttribute('data-url');
        const formId = targetBtn.getAttribute('data-form');
        const isEn = (window.CinemaI18n && window.CinemaI18n.getLang() === 'en');
        const title = targetBtn.getAttribute('data-title') || (isEn ? 'Confirm Action' : 'X\u00e1c nh\u1eadn thao t\u00e1c');
        const message = targetBtn.getAttribute('data-confirm') || (isEn ? 'Are you sure you want to perform this action?' : 'B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n th\u1ef1c hi\u1ec7n h\u00e0nh \u0111\u1ed9ng n\u00e0y?');
        const icon = targetBtn.getAttribute('data-icon') || 'warning';
        const confirmText = targetBtn.getAttribute('data-confirm-text') || (isEn ? '<i class="fa-solid fa-check me-1"></i> Confirm' : '<i class="fa-solid fa-check me-1"></i> X\u00e1c nh\u1eadn');
        const cancelButtonText = targetBtn.getAttribute('data-cancel-text') || (isEn ? '<i class="fa-solid fa-xmark me-1"></i> Cancel' : '<i class="fa-solid fa-xmark me-1"></i> H\u1ee7y b\u1ecf');
        const confirmColor = targetBtn.getAttribute('data-confirm-color') || '#dc2626';

        const dark = document.documentElement.getAttribute('data-bs-theme') !== 'light';
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                title: title,
                text: message,
                icon: icon,
                showCancelButton: true,
                confirmButtonColor: confirmColor,
                cancelButtonColor: '#6b7280',
                confirmButtonText: confirmText,
                cancelButtonText: cancelButtonText,
                reverseButtons: true,
                background: dark ? '#1e1e1e' : '#ffffff',
                color: dark ? '#f5f5f5' : '#0f172a',
                customClass: {
                    popup: 'rounded-4 shadow-lg border ' + (dark ? 'border-secondary' : 'border-light-subtle')
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    if (formId) {
                        const form = document.getElementById(formId);
                        if (form) form.submit();
                    } else if (url && url !== '#' && !url.startsWith('javascript:')) {
                        window.location.href = url;
                    }
                }
            });
        } else {
            if (confirm(message)) {
                if (formId) {
                    const form = document.getElementById(formId);
                    if (form) form.submit();
                } else if (url && url !== '#' && !url.startsWith('javascript:')) {
                    window.location.href = url;
                }
            }
        }
    });
});

