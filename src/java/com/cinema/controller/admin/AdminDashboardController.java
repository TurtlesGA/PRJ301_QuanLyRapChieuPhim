package com.cinema.controller.admin;

import com.cinema.dao.BookingDAO;
import com.cinema.dao.MovieDAO;
import com.cinema.dao.ShowtimeDAO;
import com.cinema.dao.UserDAO;
import com.cinema.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    private MovieDAO movieDAO = new MovieDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        double totalRevenue = bookingDAO.getTotalRevenue();
        int totalTickets = bookingDAO.getTotalTicketsSold();
        int totalMovies = movieDAO.countMovies();
        int totalUsers = userDAO.countUsers();
        List<Booking> recentBookings = bookingDAO.getAllBookings();

        // Lấy tối đa 10 đơn gần nhất
        if (recentBookings.size() > 10) {
            recentBookings = recentBookings.subList(0, 10);
        }

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("totalMovies", totalMovies);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("recentBookings", recentBookings);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}

