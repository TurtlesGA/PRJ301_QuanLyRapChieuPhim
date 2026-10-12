package com.cinema.controller.admin;

import com.cinema.dao.MovieDAO;
import com.cinema.model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminMovieController", urlPatterns = {"/admin/movies", "/admin/movie-add", "/admin/movie-edit", "/admin/movie-delete"})
public class AdminMovieController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/movies".equals(servletPath)) {
            List<Movie> movies = movieDAO.getAllMovies();
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("/WEB-INF/views/admin/movies.jsp").forward(request, response);
        } else if ("/admin/movie-add".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/movie-form.jsp").forward(request, response);
        } else if ("/admin/movie-edit".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Movie movie = movieDAO.getMovieById(id);
                if (movie != null) {
                    request.setAttribute("movie", movie);
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
            response.sendRedirect(request.getContextPath() + "/admin/movies");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("movieId");
            String title = request.getParameter("title");
            String genre = request.getParameter("genre");
            int duration = Integer.parseInt(request.getParameter("duration"));
            Date releaseDate = Date.valueOf(request.getParameter("releaseDate"));
            String endDateStr = request.getParameter("endDate");
            Date endDate = (endDateStr != null && !endDateStr.isEmpty()) ? Date.valueOf(endDateStr) : null;
            String director = request.getParameter("director");
            String cast = request.getParameter("cast");
            String description = request.getParameter("description");
            String posterUrl = request.getParameter("posterUrl");
            String trailerUrl = request.getParameter("trailerUrl");
            String ageRating = request.getParameter("ageRating");
            String status = request.getParameter("status");

            Movie movie = new Movie();
            movie.setTitle(title);
            movie.setGenre(genre);
            movie.setDuration(duration);
            movie.setReleaseDate(releaseDate);
            movie.setEndDate(endDate);
            movie.setDirector(director);
            movie.setCast(cast);
            movie.setDescription(description);
            movie.setPosterUrl(posterUrl);
            movie.setTrailerUrl(trailerUrl);
            movie.setAgeRating(ageRating);
            movie.setStatus(status);

            if (idStr != null && !idStr.isEmpty()) {
                movie.setMovieId(Integer.parseInt(idStr));
                movieDAO.updateMovie(movie);
            } else {
                movieDAO.insertMovie(movie);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/movies");
    }
}
