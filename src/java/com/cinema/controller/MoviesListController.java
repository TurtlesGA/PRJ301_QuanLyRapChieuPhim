package com.cinema.controller;

import com.cinema.dao.MovieDAO;
import com.cinema.model.Movie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MoviesListController", urlPatterns = {"/movies"})
public class MoviesListController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        String genre = request.getParameter("genre");
        String filter = request.getParameter("filter");

        int page = 1;
        int pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam.trim()));
        } catch (Exception ignored) {}

        int totalMovies = movieDAO.countFilterMovies(keyword, genre, filter);
        int totalPages = (int) Math.ceil((double) totalMovies / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Movie> movies = movieDAO.filterMovies(keyword, genre, filter, page, pageSize);
        List<String> genres = movieDAO.getAllGenres();

        request.setAttribute("movies", movies);
        request.setAttribute("genres", genres);
        request.setAttribute("searchKeyword", keyword != null ? keyword.trim() : "");
        request.setAttribute("selectedGenre", genre != null ? genre.trim() : "");
        request.setAttribute("activeFilter", (filter != null && !filter.trim().isEmpty()) ? filter.trim() : "all");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalMovies);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/WEB-INF/views/movies.jsp").forward(request, response);
    }
}
