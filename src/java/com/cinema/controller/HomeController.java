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

@WebServlet(name = "HomeController", urlPatterns = {"", "/home"})
public class HomeController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Movie> nowShowing = movieDAO.getNowShowingMovies();
        List<Movie> comingSoon = movieDAO.getComingSoonMovies();

        request.setAttribute("nowShowing", nowShowing);
        request.setAttribute("comingSoon", comingSoon);
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}

