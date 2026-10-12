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
