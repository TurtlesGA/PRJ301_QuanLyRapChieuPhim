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
        let selectedSeats = []; // [{id: 1, code: 'A1', price: 80000}]

        seatButtons.forEach(btn => {
            btn.addEventListener('click', function () {
                const seatId = parseInt(this.getAttribute('data-seat-id'));
                const seatCode = this.getAttribute('data-seat-code');
                const seatPrice = parseFloat(this.getAttribute('data-price'));

                const index = selectedSeats.findIndex(s => s.id === seatId);
                if (index > -1) {
                    // Deselect
                    selectedSeats.splice(index, 1);
                    this.classList.remove('selected');
                } else {
                    // Select (Max 8 seats per booking)
                    if (selectedSeats.length >= 8) {
                        alert('Bạn chỉ có thể đặt tối đa 8 ghế trong một lần đặt!');
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
                if (selectedSeatCodesSpan) selectedSeatCodesSpan.textContent = 'Chưa chọn ghế';
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
    }
});
