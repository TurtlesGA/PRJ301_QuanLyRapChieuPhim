package com.cinema.controller;

import com.cinema.dao.BookingDAO;
import com.cinema.dao.RoomDAO;
import com.cinema.dao.ShowtimeDAO;
import com.cinema.model.Booking;
import com.cinema.model.Seat;
import com.cinema.model.Showtime;
import com.cinema.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();
    private RoomDAO roomDAO = new RoomDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
            String selectedSeatsParam = request.getParameter("selectedSeats"); // Comma-separated seat IDs: "1,2"
            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.isEmpty()) {
                paymentMethod = "VNPAY";
            }

            if (selectedSeatsParam == null || selectedSeatsParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seat-selection?showtimeId=" + showtimeId);
                return;
            }

            Showtime showtime = showtimeDAO.getShowtimeById(showtimeId);
            if (showtime == null) {
                response.sendRedirect(request.getContextPath() + "/movies");
                return;
            }

            String[] seatIdStrs = selectedSeatsParam.split(",");
            List<Integer> seatIds = new ArrayList<>();
            List<Double> seatPrices = new ArrayList<>();
            double totalAmount = 0;

            List<Seat> allSeats = roomDAO.getSeatsByRoomId(showtime.getRoomId());

            for (String sIdStr : seatIdStrs) {
                int sId = Integer.parseInt(sIdStr.trim());
                seatIds.add(sId);

                // Tìm giá ghế
                double price = showtime.getBasePrice();
                for (Seat s : allSeats) {
                    if (s.getSeatId() == sId) {
                        price += s.getPriceModifier();
                        break;
                    }
                }
                seatPrices.add(price);
                totalAmount += price;
            }

            // Tạo mã đơn đặt vé ngẫu nhiên
            String bookingCode = "BK" + System.currentTimeMillis() % 10000000;

            Booking booking = new Booking();
            booking.setUserId(currentUser.getUserId());
            booking.setShowtimeId(showtimeId);
            booking.setBookingCode(bookingCode);
            booking.setTotalAmount(totalAmount);
            booking.setPaymentStatus("PAID");
            booking.setPaymentMethod(paymentMethod);

            boolean success = bookingDAO.createBooking(booking, seatIds, seatPrices);

            if (success) {
                Booking createdBooking = bookingDAO.getBookingById(booking.getBookingId());
                request.setAttribute("booking", createdBooking);
                request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Đặt vé thất bại! Ghế có thể vừa được người khác đặt. Vui lòng chọn lại.");
                response.sendRedirect(request.getContextPath() + "/seat-selection?showtimeId=" + showtimeId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/movies");
        }
    }
}

