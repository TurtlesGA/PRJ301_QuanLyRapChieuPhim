package com.cinema.controller;

import com.cinema.dao.BookingDAO;
import com.cinema.model.Booking;
import com.cinema.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyBookingsController", urlPatterns = {"/my-bookings", "/cancel-booking"})
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

        String path = request.getServletPath();
        if (path.equals("/cancel-booking")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int bookingId = Integer.parseInt(idStr);
                bookingDAO.cancelBookingByUser(bookingId, currentUser.getUserId());
            }
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }

        List<Booking> myBookings = bookingDAO.getBookingsByUserId(currentUser.getUserId());
        request.setAttribute("myBookings", myBookings);
        request.getRequestDispatcher("/WEB-INF/views/my-bookings.jsp").forward(request, response);
    }
}

