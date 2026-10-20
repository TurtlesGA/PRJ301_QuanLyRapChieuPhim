package com.cinema.controller.admin;

import com.cinema.dao.LanguageDAO;
import com.cinema.dao.MovieDAO;
import com.cinema.model.Language;
import com.cinema.model.Movie;
import com.cinema.model.MovieTranslation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminMovieController", urlPatterns = {"/admin/movies", "/admin/movie-add", "/admin/movie-edit", "/admin/movie-delete"})
public class AdminMovieController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();
    private LanguageDAO languageDAO = new LanguageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/movies".equals(servletPath)) {
            List<Movie> movies = movieDAO.getAllMovies();
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("/WEB-INF/views/admin/movies.jsp").forward(request, response);
        } else if ("/admin/movie-add".equals(servletPath)) {
            List<Language> activeLanguages = languageDAO.getAllActiveLanguages();
            request.setAttribute("activeLanguages", activeLanguages);
            request.getRequestDispatcher("/WEB-INF/views/admin/movie-form.jsp").forward(request, response);
        } else if ("/admin/movie-edit".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Movie movie = movieDAO.getMovieById(id);
                if (movie != null) {
                    List<Language> activeLanguages = languageDAO.getAllActiveLanguages();
                    request.setAttribute("movie", movie);
                    request.setAttribute("activeLanguages", activeLanguages);
                    request.getRequestDispatcher("/WEB-INF/views/admin/movie-form.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/movies");
        } else if ("/admin/movie-delete".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                movieDAO.deleteMovie(id);
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/movies?msg=delete_success");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            String idStr = request.getParameter("movieId");
            int duration = Integer.parseInt(request.getParameter("duration"));
            Date releaseDate = Date.valueOf(request.getParameter("releaseDate"));
            String endDateStr = request.getParameter("endDate");
            Date endDate = (endDateStr != null && !endDateStr.trim().isEmpty()) ? Date.valueOf(endDateStr.trim()) : null;
            String posterUrl = request.getParameter("posterUrl");
            String trailerUrl = request.getParameter("trailerUrl");
            String ageRating = request.getParameter("ageRating");
            String status = request.getParameter("status");

            // Selected languages for this movie
            String[] selectedLanguages = request.getParameterValues("selectedLanguages");
            if (selectedLanguages == null || selectedLanguages.length == 0) {
                // Fallback to "vi" if not checked
                selectedLanguages = new String[]{"vi"};
            }

            // Determine primary language data (prefer vi if selected, else first selected)
            String primaryLang = "vi";
            boolean hasVi = false;
            for (String lang : selectedLanguages) {
                if ("vi".equalsIgnoreCase(lang)) {
                    hasVi = true;
                    break;
                }
            }
            if (!hasVi && selectedLanguages.length > 0) {
                primaryLang = selectedLanguages[0].toLowerCase();
            }

            String mainTitle = request.getParameter("title_" + primaryLang);
            if (mainTitle == null || mainTitle.trim().isEmpty()) {
                mainTitle = request.getParameter("title"); // legacy fallback
            }
            String mainGenre = request.getParameter("genre_" + primaryLang);
            if (mainGenre == null || mainGenre.trim().isEmpty()) {
                mainGenre = request.getParameter("genre");
            }
            String mainDirector = request.getParameter("director_" + primaryLang);
            if (mainDirector == null) mainDirector = request.getParameter("director");
            String mainCast = request.getParameter("cast_" + primaryLang);
            if (mainCast == null) mainCast = request.getParameter("cast");
            String mainDesc = request.getParameter("description_" + primaryLang);
            if (mainDesc == null) mainDesc = request.getParameter("description");

            Movie movie = new Movie();
            movie.setTitle(mainTitle != null ? mainTitle.trim() : "Chưa đặt tên");
            movie.setGenre(mainGenre != null ? mainGenre.trim() : "Chưa phân loại");
            movie.setDuration(duration);
            movie.setReleaseDate(releaseDate);
            movie.setEndDate(endDate);
            movie.setDirector(mainDirector != null ? mainDirector.trim() : "");
            movie.setCast(mainCast != null ? mainCast.trim() : "");
            movie.setDescription(mainDesc != null ? mainDesc.trim() : "");
            movie.setPosterUrl(posterUrl);
            movie.setTrailerUrl(trailerUrl);
            movie.setAgeRating(ageRating);
            movie.setStatus(status);

            int savedMovieId;
            boolean isEdit = (idStr != null && !idStr.trim().isEmpty());
            if (isEdit) {
                savedMovieId = Integer.parseInt(idStr.trim());
                movie.setMovieId(savedMovieId);
                movieDAO.updateMovie(movie);
            } else {
                savedMovieId = movieDAO.insertMovieAndGetId(movie);
            }

            if (savedMovieId > 0) {
                // Save translations for each selected language
                for (String rawLang : selectedLanguages) {
                    if (rawLang == null || rawLang.trim().isEmpty()) continue;
                    String lang = rawLang.trim().toLowerCase();

                    String tTitle = request.getParameter("title_" + lang);
                    String tGenre = request.getParameter("genre_" + lang);
                    String tDirector = request.getParameter("director_" + lang);
                    String tCast = request.getParameter("cast_" + lang);
                    String tDesc = request.getParameter("description_" + lang);

                    if (tTitle != null && !tTitle.trim().isEmpty()) {
                        MovieTranslation trans = new MovieTranslation();
                        trans.setMovieId(savedMovieId);
                        trans.setLangCode(lang);
                        trans.setTitle(tTitle.trim());
                        trans.setGenre(tGenre != null ? tGenre.trim() : "");
                        trans.setDirector(tDirector != null ? tDirector.trim() : "");
                        trans.setCast(tCast != null ? tCast.trim() : "");
                        trans.setDescription(tDesc != null ? tDesc.trim() : "");

                        movieDAO.saveMovieTranslation(trans);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/movies?msg=" + (isEdit ? "update_success" : "add_success"));
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/movies?error=save_failed");
    }
}
