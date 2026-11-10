package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Movie;
import com.cinema.model.Room;
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

    private static long lastAutoCleanup = 0;
    private static final long CLEANUP_INTERVAL_MS = 5 * 60 * 1000; // 5 minutes

    /**
     * Tự động dọn dẹp các suất chiếu hết hạn nếu đã đến chu kỳ
     */
    public void autoCleanupIfDue() {
        long now = System.currentTimeMillis();
        if (now - lastAutoCleanup > CLEANUP_INTERVAL_MS) {
            lastAutoCleanup = now;
            deleteExpiredShowtimes();
        }
    }

    /**
     * Xóa toàn bộ các suất chiếu đã kết thúc trong quá khứ khỏi CSDL
     * Kèm theo giải phóng an toàn các vé và đơn đặt vé liên quan
     * @return số lượng suất chiếu đã được xóa
     */
    public int deleteExpiredShowtimes() {
        String condition = "WHERE show_date < CAST(GETDATE() AS DATE) "
                         + "   OR (show_date = CAST(GETDATE() AS DATE) AND end_time < CAST(GETDATE() AS TIME))";

        String deleteTicketsSql = "DELETE t FROM Tickets t "
                                + "JOIN Bookings b ON t.booking_id = b.booking_id "
                                + "WHERE b.showtime_id IN (SELECT showtime_id FROM Showtimes " + condition + ")";

        String deleteBookingsSql = "DELETE FROM Bookings "
                                 + "WHERE showtime_id IN (SELECT showtime_id FROM Showtimes " + condition + ")";

        String deleteShowtimesSql = "DELETE FROM Showtimes " + condition;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psTickets = conn.prepareStatement(deleteTicketsSql);
                 PreparedStatement psBookings = conn.prepareStatement(deleteBookingsSql);
                 PreparedStatement psShowtimes = conn.prepareStatement(deleteShowtimesSql)) {

                psTickets.executeUpdate();
                psBookings.executeUpdate();
                int deletedCount = psShowtimes.executeUpdate();

                conn.commit();
                if (deletedCount > 0) {
                    System.out.println("[ShowtimeDAO] Đã tự động dọn dẹp " + deletedCount + " suất chiếu hết hạn.");
                }
                return deletedCount;
            } catch (Exception ex) {
                conn.rollback();
                System.err.println("[ShowtimeDAO] Lỗi khi dọn dẹp suất chiếu hết hạn: " + ex.getMessage());
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Showtime> getShowtimesByMovieId(int movieId) {
        autoCleanupIfDue();
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
        autoCleanupIfDue();
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
        String deleteTicketsSql = "DELETE t FROM Tickets t JOIN Bookings b ON t.booking_id = b.booking_id WHERE b.showtime_id = ?";
        String deleteBookingsSql = "DELETE FROM Bookings WHERE showtime_id = ?";
        String deleteShowtimeSql = "DELETE FROM Showtimes WHERE showtime_id = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psTickets = conn.prepareStatement(deleteTicketsSql);
                 PreparedStatement psBookings = conn.prepareStatement(deleteBookingsSql);
                 PreparedStatement psShowtime = conn.prepareStatement(deleteShowtimeSql)) {

                psTickets.setInt(1, showtimeId);
                psTickets.executeUpdate();

                psBookings.setInt(1, showtimeId);
                psBookings.executeUpdate();

                psShowtime.setInt(1, showtimeId);
                int affected = psShowtime.executeUpdate();

                conn.commit();
                return affected > 0;
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countShowtimes() {
        autoCleanupIfDue();
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

    public List<Showtime> getShowtimesByPage(int page, int pageSize) {
        List<Showtime> list = new ArrayList<>();
        if (page < 1) page = 1;
        int offset = (page - 1) * pageSize;
        String sql = "SELECT s.*, m.title AS movie_title, m.poster_url AS movie_poster, m.age_rating AS movie_age, m.duration AS movie_duration, "
                   + "r.room_name, r.room_type, r.total_rows, r.total_cols "
                   + "FROM Showtimes s "
                   + "JOIN Movies m ON s.movie_id = m.movie_id "
                   + "JOIN Rooms r ON s.room_id = r.room_id "
                   + "ORDER BY s.show_date DESC, s.start_time DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Showtime st = mapShowtime(rs);
                    Movie m = new Movie();
                    m.setMovieId(st.getMovieId());
                    m.setTitle(MovieDAO.fixEncoding(rs.getString("movie_title")));
                    m.setPosterUrl(rs.getString("movie_poster"));
                    m.setAgeRating(rs.getString("movie_age"));
                    m.setDuration(rs.getInt("movie_duration"));
                    st.setMovie(m);

                    Room r = new Room();
                    r.setRoomId(st.getRoomId());
                    r.setRoomName(rs.getString("room_name"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setTotalRows(rs.getInt("total_rows"));
                    r.setTotalCols(rs.getInt("total_cols"));
                    st.setRoom(r);

                    list.add(st);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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
