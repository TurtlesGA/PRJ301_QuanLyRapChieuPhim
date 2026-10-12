package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Room;
import com.cinema.model.Seat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class RoomDAO extends DBContext {

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Rooms ORDER BY room_id ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRoom(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM Rooms WHERE room_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRoom(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Seat> getSeatsByRoomId(int roomId) {
        List<Seat> list = new ArrayList<>();
        String sql = "SELECT * FROM Seats WHERE room_id = ? ORDER BY seat_row ASC, seat_number ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSeat(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách ghế của phòng theo suất chiếu và đánh dấu ghế nào đã có người đặt
     */
    public List<Seat> getSeatsWithBookingStatus(int roomId, int showtimeId) {
        List<Seat> seats = getSeatsByRoomId(roomId);
        
        // Lấy danh sách seat_id đã được đặt cho showtime này
        Set<Integer> bookedSeatIds = new HashSet<>();
        String sql = "SELECT t.seat_id FROM Tickets t " +
                     "JOIN Bookings b ON t.booking_id = b.booking_id " +
                     "WHERE b.showtime_id = ? AND b.payment_status != 'CANCELLED'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookedSeatIds.add(rs.getInt("seat_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Đánh dấu ghế đã đặt
        for (Seat seat : seats) {
            if (bookedSeatIds.contains(seat.getSeatId())) {
                seat.setBooked(true);
            }
        }
        return seats;
    }

    private Room mapRoom(ResultSet rs) throws Exception {
        return new Room(
                rs.getInt("room_id"),
                rs.getString("room_name"),
                rs.getString("room_type"),
                rs.getInt("total_rows"),
                rs.getInt("total_cols"),
                rs.getBoolean("status")
        );
    }

    private Seat mapSeat(ResultSet rs) throws Exception {
        return new Seat(
                rs.getInt("seat_id"),
                rs.getInt("room_id"),
                rs.getString("seat_row"),
                rs.getInt("seat_number"),
                rs.getString("seat_type"),
                rs.getDouble("price_modifier")
        );
    }
}
