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

@WebServlet(name = "AdminBookingController", urlPatterns = {"/admin/bookings", "/admin/booking-cancel"})
public class AdminBookingController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/admin/booking-cancel")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int bookingId = Integer.parseInt(idStr);
                bookingDAO.cancelBooking(bookingId);
            }
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
            return;
        }

        int page = 1;
        int pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam.trim()));
        } catch (Exception ignored) {}

        int totalBookings = bookingDAO.countBookings();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Booking> bookings = bookingDAO.getBookingsByPage(page, pageSize);

        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalBookings);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
    }
}

