package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Booking;
import com.cinema.model.Seat;
import com.cinema.model.Ticket;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBContext {

    private UserDAO userDAO = new UserDAO();
    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();

    /**
     * Tạo hóa đơn đặt vé và danh sách vé trong 1 Transaction
     */
    public boolean createBooking(Booking booking, List<Integer> seatIds, List<Double> seatPrices) {
        String insertBookingSql = "INSERT INTO Bookings (user_id, showtime_id, booking_code, total_amount, payment_status, payment_method, booking_time) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        String insertTicketSql = "INSERT INTO Tickets (booking_id, seat_id, price) VALUES (?, ?, ?)";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            int bookingId = -1;
            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, booking.getUserId());
                ps.setInt(2, booking.getShowtimeId());
                ps.setString(3, booking.getBookingCode());
                ps.setDouble(4, booking.getTotalAmount());
                ps.setString(5, booking.getPaymentStatus());
                ps.setString(6, booking.getPaymentMethod());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        bookingId = rs.getInt(1);
                    }
                }
            }

            if (bookingId <= 0) {
                conn.rollback();
                return false;
            }

            // Lưu từng vé
            try (PreparedStatement psTicket = conn.prepareStatement(insertTicketSql)) {
                for (int i = 0; i < seatIds.size(); i++) {
                    psTicket.setInt(1, bookingId);
                    psTicket.setInt(2, seatIds.get(i));
                    psTicket.setDouble(3, seatPrices.get(i));
                    psTicket.addBatch();
                }
                psTicket.executeBatch();
            }

            conn.commit(); // Commit Transaction thành công
            booking.setBookingId(bookingId);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE user_id = ? ORDER BY booking_time DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = mapBooking(rs);
                    b.setShowtime(showtimeDAO.getShowtimeById(b.getShowtimeId()));
                    b.setTickets(getTicketsByBookingId(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Bookings ORDER BY booking_time DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking b = mapBooking(rs);
                b.setUser(userDAO.getUserById(b.getUserId()));
                b.setShowtime(showtimeDAO.getShowtimeById(b.getShowtimeId()));
                b.setTickets(getTicketsByBookingId(b.getBookingId()));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM Bookings WHERE booking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = mapBooking(rs);
                    b.setUser(userDAO.getUserById(b.getUserId()));
                    b.setShowtime(showtimeDAO.getShowtimeById(b.getShowtimeId()));
                    b.setTickets(getTicketsByBookingId(b.getBookingId()));
                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Ticket> getTicketsByBookingId(int bookingId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, s.seat_row, s.seat_number, s.seat_type, s.room_id " +
                     "FROM Tickets t " +
                     "JOIN Seats s ON t.seat_id = s.seat_id " +
                     "WHERE t.booking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ticket ticket = new Ticket(
                            rs.getInt("ticket_id"),
                            rs.getInt("booking_id"),
                            rs.getInt("seat_id"),
                            rs.getDouble("price")
                    );
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("seat_id"));
                    seat.setRoomId(rs.getInt("room_id"));
                    seat.setSeatRow(rs.getString("seat_row"));
                    seat.setSeatNumber(rs.getInt("seat_number"));
                    seat.setSeatType(rs.getString("seat_type"));
                    ticket.setSeat(seat);
                    list.add(ticket);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM Bookings WHERE payment_status = 'PAID'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalTicketsSold() {
        String sql = "SELECT COUNT(*) FROM Tickets t JOIN Bookings b ON t.booking_id = b.booking_id WHERE b.payment_status = 'PAID'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Booking mapBooking(ResultSet rs) throws Exception {
        return new Booking(
                rs.getInt("booking_id"),
                rs.getInt("user_id"),
                rs.getInt("showtime_id"),
                rs.getString("booking_code"),
                rs.getDouble("total_amount"),
                rs.getString("payment_status"),
                rs.getString("payment_method"),
                rs.getTimestamp("booking_time")
        );
    }
}
