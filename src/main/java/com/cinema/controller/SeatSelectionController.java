package com.cinema.controller;

import com.cinema.dao.RoomDAO;
import com.cinema.dao.ShowtimeDAO;
import com.cinema.model.Room;
import com.cinema.model.Seat;
import com.cinema.model.Showtime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SeatSelectionController", urlPatterns = {"/seat-selection"})
public class SeatSelectionController extends HttpServlet {

    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String showtimeIdParam = request.getParameter("showtimeId");
        if (showtimeIdParam == null || showtimeIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        try {
            int showtimeId = Integer.parseInt(showtimeIdParam);
            Showtime showtime = showtimeDAO.getShowtimeById(showtimeId);
            if (showtime == null) {
                response.sendRedirect(request.getContextPath() + "/movies");
                return;
            }

            Room room = roomDAO.getRoomById(showtime.getRoomId());
            List<Seat> seats = roomDAO.getSeatsWithBookingStatus(room.getRoomId(), showtimeId);

            request.setAttribute("showtime", showtime);
            request.setAttribute("room", room);
            request.setAttribute("seats", seats);
            request.getRequestDispatcher("/WEB-INF/views/seat-selection.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movies");
        }
    }
}
