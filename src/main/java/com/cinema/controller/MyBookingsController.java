package com.cinema.controller;

import com.cinema.dao.BookingDAO;
import com.cinema.model.Booking;
import com.cinema.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyBookingsController", urlPatterns = {"/my-bookings"})
public class MyBookingsController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Booking> myBookings = bookingDAO.getBookingsByUserId(currentUser.getUserId());
        request.setAttribute("myBookings", myBookings);
        request.getRequestDispatcher("/WEB-INF/views/my-bookings.jsp").forward(request, response);
    }
}
