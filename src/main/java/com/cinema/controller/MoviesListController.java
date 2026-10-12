package com.cinema.controller;

import com.cinema.dao.MovieDAO;
import com.cinema.model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MoviesListController", urlPatterns = {"/movies"})
public class MoviesListController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        String filter = request.getParameter("filter"); // "now", "soon", or null

        List<Movie> movies;
        if (keyword != null && !keyword.trim().isEmpty()) {
            movies = movieDAO.searchMovies(keyword.trim());
            request.setAttribute("searchKeyword", keyword.trim());
        } else if ("soon".equalsIgnoreCase(filter)) {
            movies = movieDAO.getComingSoonMovies();
            request.setAttribute("activeFilter", "soon");
        } else if ("now".equalsIgnoreCase(filter)) {
            movies = movieDAO.getNowShowingMovies();
            request.setAttribute("activeFilter", "now");
        } else {
            movies = movieDAO.getAllMovies();
            request.setAttribute("activeFilter", "all");
        }

        request.setAttribute("movies", movies);
        request.getRequestDispatcher("/WEB-INF/views/movies.jsp").forward(request, response);
    }
}
