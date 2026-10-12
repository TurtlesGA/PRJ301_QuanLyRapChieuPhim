package com.cinema.controller.admin;

import com.cinema.dao.BookingDAO;
import com.cinema.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBookingController", urlPatterns = {"/admin/bookings"})
public class AdminBookingController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Booking> bookings = bookingDAO.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
    }
}

