package com.cinema.controller.admin;

import com.cinema.dao.BookingDAO;
import com.cinema.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
