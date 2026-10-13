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

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/payment", "/payment-confirm"})
public class CheckoutController extends HttpServlet {

    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();
    private RoomDAO roomDAO = new RoomDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/payment".equals(path)) {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }

            try {
                int bookingId = Integer.parseInt(bookingIdParam.trim());
                Booking booking = bookingDAO.getBookingById(bookingId);
                if (booking == null) {
                    response.sendRedirect(request.getContextPath() + "/my-bookings");
                    return;
                }

                if (booking.getUserId() != currentUser.getUserId() && !currentUser.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/my-bookings");
                    return;
                }

                if ("PAID".equals(booking.getPaymentStatus())) {
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);
                    return;
                }

                if ("CANCELLED".equals(booking.getPaymentStatus())) {
                    response.sendRedirect(request.getContextPath() + "/my-bookings");
                    return;
                }

                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/my-bookings");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/movies");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/checkout".equals(path)) {
            handleCheckout(request, response);
        } else if ("/payment-confirm".equals(path)) {
            handlePaymentConfirm(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/movies");
        }
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
            String selectedSeatsParam = request.getParameter("selectedSeats");
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

            String bookingCode = "BK" + (System.currentTimeMillis() % 10000000);

            Booking booking = new Booking();
            booking.setUserId(currentUser.getUserId());
            booking.setShowtimeId(showtimeId);
            booking.setBookingCode(bookingCode);
            booking.setTotalAmount(totalAmount);
            booking.setPaymentMethod(paymentMethod);

            if ("CASH".equals(paymentMethod)) {
                booking.setPaymentStatus("PAID");
                boolean success = bookingDAO.createBooking(booking, seatIds, seatPrices);
                if (success) {
                    Booking createdBooking = bookingDAO.getBookingById(booking.getBookingId());
                    request.setAttribute("booking", createdBooking);
                    request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);
                } else {
                    session.setAttribute("error", "Đặt vé thất bại! Ghế bạn chọn vừa có người khác đặt trước. Vui lòng chọn ghế khác.");
                    response.sendRedirect(request.getContextPath() + "/seat-selection?showtimeId=" + showtimeId);
                }
            } else {
                booking.setPaymentStatus("PENDING");
                boolean success = bookingDAO.createBooking(booking, seatIds, seatPrices);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + booking.getBookingId());
                } else {
                    session.setAttribute("error", "Đặt vé thất bại! Ghế bạn chọn vừa có người khác đặt trước. Vui lòng chọn ghế khác.");
                    response.sendRedirect(request.getContextPath() + "/seat-selection?showtimeId=" + showtimeId);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/movies");
        }
    }

    private void handlePaymentConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        String action = request.getParameter("action");

        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam.trim());
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }

            if (booking.getUserId() != currentUser.getUserId() && !currentUser.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }

            if ("confirm".equals(action)) {
                boolean ok = bookingDAO.updatePaymentStatus(bookingId, "PAID");
                if (ok) {
                    Booking updatedBooking = bookingDAO.getBookingById(bookingId);
                    request.setAttribute("booking", updatedBooking);
                    request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId);
                }
            } else if ("cancel".equals(action)) {
                bookingDAO.cancelBookingByUser(bookingId, currentUser.getUserId());
                response.sendRedirect(request.getContextPath() + "/my-bookings");
            } else {
                response.sendRedirect(request.getContextPath() + "/my-bookings");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/my-bookings");
        }
    }
}

