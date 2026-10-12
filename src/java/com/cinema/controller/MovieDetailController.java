package com.cinema.controller;

import com.cinema.dao.MovieDAO;
import com.cinema.dao.ShowtimeDAO;
import com.cinema.model.Movie;
import com.cinema.model.Showtime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MovieDetailController", urlPatterns = {"/movie-detail"})
public class MovieDetailController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();
    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        try {
            int movieId = Integer.parseInt(idParam);
            Movie movie = movieDAO.getMovieById(movieId);
            if (movie == null) {
                response.sendRedirect(request.getContextPath() + "/movies");
                return;
            }

            List<Showtime> showtimes = showtimeDAO.getShowtimesByMovieId(movieId);

            request.setAttribute("movie", movie);
            request.setAttribute("showtimes", showtimes);
            request.getRequestDispatcher("/WEB-INF/views/movie-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movies");
        }
    }
}

