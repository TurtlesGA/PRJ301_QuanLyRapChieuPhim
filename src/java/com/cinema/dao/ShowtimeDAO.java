package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Showtime;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeDAO extends DBContext {

    private MovieDAO movieDAO = new MovieDAO();
    private RoomDAO roomDAO = new RoomDAO();

    public List<Showtime> getShowtimesByMovieId(int movieId) {
        List<Showtime> list = new ArrayList<>();
        String sql = "SELECT * FROM Showtimes WHERE movie_id = ? AND show_date >= CAST(GETDATE() AS DATE) AND status = 'OPEN' ORDER BY show_date ASC, start_time ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Showtime st = mapShowtime(rs);
                    st.setMovie(movieDAO.getMovieById(st.getMovieId()));
                    st.setRoom(roomDAO.getRoomById(st.getRoomId()));
                    list.add(st);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Showtime> getAllShowtimes() {
        List<Showtime> list = new ArrayList<>();
        String sql = "SELECT * FROM Showtimes ORDER BY show_date DESC, start_time DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Showtime st = mapShowtime(rs);
                st.setMovie(movieDAO.getMovieById(st.getMovieId()));
                st.setRoom(roomDAO.getRoomById(st.getRoomId()));
                list.add(st);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Showtime getShowtimeById(int showtimeId) {
        String sql = "SELECT * FROM Showtimes WHERE showtime_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Showtime st = mapShowtime(rs);
                    st.setMovie(movieDAO.getMovieById(st.getMovieId()));
                    st.setRoom(roomDAO.getRoomById(st.getRoomId()));
                    return st;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertShowtime(Showtime st) {
        String sql = "INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, st.getMovieId());
            ps.setInt(2, st.getRoomId());
            ps.setDate(3, st.getShowDate());
            ps.setTime(4, st.getStartTime());
            ps.setTime(5, st.getEndTime());
            ps.setDouble(6, st.getBasePrice());
            ps.setString(7, st.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteShowtime(int showtimeId) {
        String sql = "DELETE FROM Showtimes WHERE showtime_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countShowtimes() {
        String sql = "SELECT COUNT(*) FROM Showtimes";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Showtime mapShowtime(ResultSet rs) throws Exception {
        return new Showtime(
                rs.getInt("showtime_id"),
                rs.getInt("movie_id"),
                rs.getInt("room_id"),
                rs.getDate("show_date"),
                rs.getTime("start_time"),
                rs.getTime("end_time"),
                rs.getDouble("base_price"),
                rs.getString("status")
        );
    }
}
