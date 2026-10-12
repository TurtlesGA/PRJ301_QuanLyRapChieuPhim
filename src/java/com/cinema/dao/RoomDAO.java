package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Room;
import com.cinema.model.Seat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

    public List<Room> getActiveRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE status = 1 ORDER BY room_id ASC";
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

    public boolean insertRoom(Room room) {
        String sqlRoom = "INSERT INTO Rooms (room_name, room_type, total_rows, total_cols, status) VALUES (?, ?, ?, ?, ?)";
        String sqlSeat = "INSERT INTO Seats (room_id, seat_row, seat_number, seat_type, price_modifier) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sqlRoom, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, room.getRoomName());
            ps.setString(2, room.getRoomType());
            ps.setInt(3, room.getTotalRows());
            ps.setInt(4, room.getTotalCols());
            ps.setBoolean(5, room.isStatus());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                int newRoomId = 0;
                if (rs.next()) {
                    newRoomId = rs.getInt(1);
                }
                if (newRoomId > 0) {
                    PreparedStatement psSeat = conn.prepareStatement(sqlSeat);
                    for (int r = 0; r < room.getTotalRows(); r++) {
                        char rowChar = (char) ('A' + r);
                        String rowStr = String.valueOf(rowChar);
                        for (int c = 1; c <= room.getTotalCols(); c++) {
                            String seatType = "STANDARD";
                            double priceMod = 0.0;
                            if (r >= 2 && r < 4) {
                                seatType = "VIP";
                                priceMod = 15000.0;
                            } else if (r >= 4) {
                                seatType = "COUPLE";
                                priceMod = 30000.0;
                            }
                            psSeat.setInt(1, newRoomId);
                            psSeat.setString(2, rowStr);
                            psSeat.setInt(3, c);
                            psSeat.setString(4, seatType);
                            psSeat.setDouble(5, priceMod);
                            psSeat.addBatch();
                        }
                    }
                    psSeat.executeBatch();
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE Rooms SET room_name = ?, room_type = ?, status = ? WHERE room_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomName());
            ps.setString(2, room.getRoomType());
            ps.setBoolean(3, room.isStatus());
            ps.setInt(4, room.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleRoomStatus(int roomId, boolean currentStatus) {
        String sql = "UPDATE Rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM Rooms WHERE room_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
