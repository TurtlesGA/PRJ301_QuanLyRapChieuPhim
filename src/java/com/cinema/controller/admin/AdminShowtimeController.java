package com.cinema.controller.admin;

import com.cinema.dao.MovieDAO;
import com.cinema.dao.RoomDAO;
import com.cinema.dao.ShowtimeDAO;
import com.cinema.model.Movie;
import com.cinema.model.Room;
import com.cinema.model.Showtime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet(name = "AdminShowtimeController", urlPatterns = {"/admin/showtimes", "/admin/showtime-add", "/admin/showtime-delete", "/admin/showtime-cleanup"})
public class AdminShowtimeController extends HttpServlet {

    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();
    private MovieDAO movieDAO = new MovieDAO();
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/showtime-cleanup".equals(servletPath)) {
            int count = showtimeDAO.deleteExpiredShowtimes();
            response.sendRedirect(request.getContextPath() + "/admin/showtimes?msg=cleanup_success&count=" + count);
            return;
        }

        if ("/admin/showtimes".equals(servletPath)) {
            int page = 1;
            int pageSize = 10;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam.trim()));
            } catch (Exception ignored) {}

            int totalShowtimes = showtimeDAO.countShowtimes();
            int totalPages = (int) Math.ceil((double) totalShowtimes / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            List<Showtime> showtimes = showtimeDAO.getShowtimesByPage(page, pageSize);

            request.setAttribute("showtimes", showtimes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalShowtimes);
            request.setAttribute("pageSize", pageSize);
            request.getRequestDispatcher("/WEB-INF/views/admin/showtimes.jsp").forward(request, response);
        } else if ("/admin/showtime-add".equals(servletPath)) {
            List<Movie> movies = movieDAO.getAllMovies();
            List<Room> rooms = roomDAO.getActiveRooms();
            request.setAttribute("movies", movies);
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("/WEB-INF/views/admin/showtime-form.jsp").forward(request, response);
        } else if ("/admin/showtime-delete".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                showtimeDAO.deleteShowtime(id);
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/showtimes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Date showDate = Date.valueOf(request.getParameter("showDate"));
            String startStr = request.getParameter("startTime");
            if (startStr.length() == 5) startStr += ":00"; // HH:mm -> HH:mm:ss
            Time startTime = Time.valueOf(startStr);

            String endStr = request.getParameter("endTime");
            if (endStr.length() == 5) endStr += ":00";
            Time endTime = Time.valueOf(endStr);

            double basePrice = Double.parseDouble(request.getParameter("basePrice"));

            Showtime st = new Showtime();
            st.setMovieId(movieId);
            st.setRoomId(roomId);
            st.setShowDate(showDate);
            st.setStartTime(startTime);
            st.setEndTime(endTime);
            st.setBasePrice(basePrice);
            st.setStatus("OPEN");

            showtimeDAO.insertShowtime(st);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/showtimes");
    }
}

