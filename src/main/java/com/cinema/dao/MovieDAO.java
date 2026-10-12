package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO extends DBContext {

    public List<Movie> getNowShowingMovies() {
        return getMoviesByStatus("NOW_SHOWING");
    }

    public List<Movie> getComingSoonMovies() {
        return getMoviesByStatus("COMING_SOON");
    }

    public List<Movie> getMoviesByStatus(String status) {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movies WHERE status = ? ORDER BY release_date DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMovie(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movies ORDER BY movie_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapMovie(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Movie getMovieById(int movieId) {
        String sql = "SELECT * FROM Movies WHERE movie_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMovie(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Movie> searchMovies(String keyword) {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movies WHERE title LIKE ? OR genre LIKE ? OR director LIKE ? ORDER BY movie_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMovie(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertMovie(Movie movie) {
        String sql = "INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getGenre());
            ps.setInt(3, movie.getDuration());
            ps.setDate(4, movie.getReleaseDate());
            ps.setDate(5, movie.getEndDate());
            ps.setString(6, movie.getDirector());
            ps.setString(7, movie.getCast());
            ps.setString(8, movie.getDescription());
            ps.setString(9, movie.getPosterUrl());
            ps.setString(10, movie.getTrailerUrl());
            ps.setString(11, movie.getAgeRating());
            ps.setString(12, movie.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateMovie(Movie movie) {
        String sql = "UPDATE Movies SET title=?, genre=?, duration=?, release_date=?, end_date=?, director=?, cast=?, description=?, poster_url=?, trailer_url=?, age_rating=?, status=? WHERE movie_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getGenre());
            ps.setInt(3, movie.getDuration());
            ps.setDate(4, movie.getReleaseDate());
            ps.setDate(5, movie.getEndDate());
            ps.setString(6, movie.getDirector());
            ps.setString(7, movie.getCast());
            ps.setString(8, movie.getDescription());
            ps.setString(9, movie.getPosterUrl());
            ps.setString(10, movie.getTrailerUrl());
            ps.setString(11, movie.getAgeRating());
            ps.setString(12, movie.getStatus());
            ps.setInt(13, movie.getMovieId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteMovie(int movieId) {
        String sql = "DELETE FROM Movies WHERE movie_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countMovies() {
        String sql = "SELECT COUNT(*) FROM Movies";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Movie mapMovie(ResultSet rs) throws Exception {
        return new Movie(
                rs.getInt("movie_id"),
                rs.getString("title"),
                rs.getString("genre"),
                rs.getInt("duration"),
                rs.getDate("release_date"),
                rs.getDate("end_date"),
                rs.getString("director"),
                rs.getString("cast"),
                rs.getString("description"),
                rs.getString("poster_url"),
                rs.getString("trailer_url"),
                rs.getString("age_rating"),
                rs.getString("status")
        );
    }
}
