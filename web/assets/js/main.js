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
                        alert('B\u1EA1n ch\u1EC9 c\u00F3 th\u1EC3 \u0111\u1EB7t t\u1ED1i \u0111a 8 gh\u1EBF trong m\u1ED9t l\u1EA7n \u0111\u1EB7t!');
                        return;
                    }
                    selectedSeats.push({ id: seatId, code: seatCode, price: seatPrice });
                    this.classList.add('selected');
                }

                updateBookingSummary();
            });
        });

        function updateBookingSummary() {
            if (selectedSeats.length === 0) {
                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = 'Ch\u01B0a ch\u1ECDn gh\u1EBF';
                if (totalPriceSpan) totalPriceSpan.textContent = '0 \u0111';
                if (selectedSeatsInput) selectedSeatsInput.value = '';
                if (checkoutBtn) checkoutBtn.disabled = true;
            } else {
                const codes = selectedSeats.map(s => s.code).join(', ');
                const total = selectedSeats.reduce((sum, s) => sum + s.price, 0);
                const ids = selectedSeats.map(s => s.id).join(',');

                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = codes;
                if (totalPriceSpan) totalPriceSpan.textContent = total.toLocaleString('vi-VN') + ' \u0111';
                if (selectedSeatsInput) selectedSeatsInput.value = ids;
                if (checkoutBtn) checkoutBtn.disabled = false;
            }
        }
    }

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
