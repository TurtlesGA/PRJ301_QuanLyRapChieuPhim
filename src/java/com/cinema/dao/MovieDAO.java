package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Movie;
import com.cinema.model.MovieTranslation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        attachTranslations(list);
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
        attachTranslations(list);
        return list;
    }

    public Movie getMovieById(int movieId) {
        String sql = "SELECT * FROM Movies WHERE movie_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Movie movie = mapMovie(rs);
                    movie.setTranslations(getTranslationsMapByMovieId(movieId));
                    return movie;
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
        attachTranslations(list);
        return list;
    }

    public boolean insertMovie(Movie movie) {
        return insertMovieAndGetId(movie) > 0;
    }

    public int insertMovieAndGetId(Movie movie) {
        String sql = "INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
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
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
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

    // ================= MOVIE TRANSLATIONS =================

    public List<MovieTranslation> getTranslationsByMovieId(int movieId) {
        List<MovieTranslation> list = new ArrayList<>();
        String sql = "SELECT * FROM MovieTranslations WHERE movie_id = ? ORDER BY lang_code ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MovieTranslation t = new MovieTranslation();
                    t.setTranslationId(rs.getInt("translation_id"));
                    t.setMovieId(rs.getInt("movie_id"));
                    t.setLangCode(rs.getString("lang_code"));
                    t.setTitle(rs.getString("title"));
                    t.setGenre(rs.getString("genre"));
                    t.setDescription(rs.getString("description"));
                    t.setDirector(rs.getString("director"));
                    t.setCast(rs.getString("cast"));
                    t.setUpdatedAt(rs.getTimestamp("updated_at"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, MovieTranslation> getTranslationsMapByMovieId(int movieId) {
        Map<String, MovieTranslation> map = new HashMap<>();
        for (MovieTranslation t : getTranslationsByMovieId(movieId)) {
            if (t.getLangCode() != null) {
                map.put(t.getLangCode().toLowerCase(), t);
            }
        }
        return map;
    }

    public boolean saveMovieTranslation(MovieTranslation t) {
        if (t == null || t.getLangCode() == null || t.getLangCode().trim().isEmpty()) return false;
        String lang = t.getLangCode().trim().toLowerCase();
        String sql = "IF EXISTS (SELECT 1 FROM MovieTranslations WHERE movie_id = ? AND LOWER(lang_code) = ?) "
                   + "UPDATE MovieTranslations SET title = ?, genre = ?, description = ?, director = ?, cast = ?, updated_at = GETDATE() WHERE movie_id = ? AND LOWER(lang_code) = ? "
                   + "ELSE "
                   + "INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getMovieId());
            ps.setString(2, lang);
            ps.setString(3, t.getTitle());
            ps.setString(4, t.getGenre());
            ps.setString(5, t.getDescription());
            ps.setString(6, t.getDirector());
            ps.setString(7, t.getCast());
            ps.setInt(8, t.getMovieId());
            ps.setString(9, lang);

            ps.setInt(10, t.getMovieId());
            ps.setString(11, lang);
            ps.setString(12, t.getTitle());
            ps.setString(13, t.getGenre());
            ps.setString(14, t.getDescription());
            ps.setString(15, t.getDirector());
            ps.setString(16, t.getCast());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void attachTranslations(List<Movie> movies) {
        if (movies == null || movies.isEmpty()) return;
        StringBuilder sb = new StringBuilder("SELECT * FROM MovieTranslations WHERE movie_id IN (");
        for (int i = 0; i < movies.size(); i++) {
            sb.append(i == 0 ? "?" : ", ?");
        }
        sb.append(")");
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < movies.size(); i++) {
                ps.setInt(i + 1, movies.get(i).getMovieId());
            }
            try (ResultSet rs = ps.executeQuery()) {
                Map<Integer, Map<String, MovieTranslation>> map = new HashMap<>();
                while (rs.next()) {
                    MovieTranslation t = new MovieTranslation();
                    t.setTranslationId(rs.getInt("translation_id"));
                    int mId = rs.getInt("movie_id");
                    t.setMovieId(mId);
                    t.setLangCode(rs.getString("lang_code"));
                    t.setTitle(rs.getString("title"));
                    t.setGenre(rs.getString("genre"));
                    t.setDescription(rs.getString("description"));
                    t.setDirector(rs.getString("director"));
                    t.setCast(rs.getString("cast"));
                    t.setUpdatedAt(rs.getTimestamp("updated_at"));

                    map.computeIfAbsent(mId, k -> new HashMap<>()).put(t.getLangCode().toLowerCase(), t);
                }
                for (Movie m : movies) {
                    if (map.containsKey(m.getMovieId())) {
                        m.setTranslations(map.get(m.getMovieId()));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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