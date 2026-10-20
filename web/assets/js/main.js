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
                        const alertMsg = window.CinemaI18n ? window.CinemaI18n.t('seatSelection.maxSeats', 'Bạn chỉ có thể đặt tối đa 8 ghế trong một lần đặt!') : 'Bạn chỉ có thể đặt tối đa 8 ghế trong một lần đặt!';
                        alert(alertMsg);
                        return;
                    }
                    selectedSeats.push({ id: seatId, code: seatCode, price: seatPrice });
                    this.classList.add('selected');
                }

                updateBookingSummary();
            });
        });

        function updateBookingSummary() {
            const noSeatText = window.CinemaI18n ? window.CinemaI18n.t('seatSelection.noSeatSelected', 'Chưa chọn ghế') : 'Chưa chọn ghế';
            if (selectedSeats.length === 0) {
                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = noSeatText;
                if (totalPriceSpan) totalPriceSpan.textContent = '0 đ';
                if (selectedSeatsInput) selectedSeatsInput.value = '';
                if (checkoutBtn) checkoutBtn.disabled = true;
            } else {
                const codes = selectedSeats.map(s => s.code).join(', ');
                const total = selectedSeats.reduce((sum, s) => sum + s.price, 0);
                const ids = selectedSeats.map(s => s.id).join(',');

                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = codes;
                if (totalPriceSpan) totalPriceSpan.textContent = total.toLocaleString('vi-VN') + ' đ';
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
});
