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
import java.time.LocalDate;
import java.time.LocalTime;
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
            String action = request.getParameter("action");
            if ("count".equalsIgnoreCase(action)) {
                int count = showtimeDAO.countExpiredShowtimes();
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"count\":" + count + "}");
                return;
            }

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
            int expiredCount = showtimeDAO.countExpiredShowtimes();
            int totalPages = (int) Math.ceil((double) totalShowtimes / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            List<Showtime> showtimes = showtimeDAO.getShowtimesByPage(page, pageSize);

            request.setAttribute("showtimes", showtimes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalShowtimes);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("expiredCount", expiredCount);
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
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg)
            throws ServletException, IOException {
        List<Movie> movies = movieDAO.getAllMovies();
        List<Room> rooms = roomDAO.getActiveRooms();
        request.setAttribute("movies", movies);
        request.setAttribute("rooms", rooms);
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/WEB-INF/views/admin/showtime-form.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String movieIdStr = request.getParameter("movieId");
        String roomIdStr = request.getParameter("roomId");
        String showDateStr = request.getParameter("showDate");
        String startStr = request.getParameter("startTime");
        String endStr = request.getParameter("endTime");
        String basePriceStr = request.getParameter("basePrice");

        if (movieIdStr == null || roomIdStr == null || showDateStr == null || 
            startStr == null || endStr == null || basePriceStr == null ||
            movieIdStr.trim().isEmpty() || roomIdStr.trim().isEmpty() || showDateStr.trim().isEmpty()) {
            forwardWithError(request, response, "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            return;
        }

        try {
            int movieId = Integer.parseInt(movieIdStr.trim());
            int roomId = Integer.parseInt(roomIdStr.trim());
            Date showDate = Date.valueOf(showDateStr.trim());

            Movie movie = movieDAO.getMovieById(movieId);
            if (movie == null) {
                forwardWithError(request, response, "Bộ phim được chọn không tồn tại trong hệ thống!");
                return;
            }

            LocalDate showLocalDate = showDate.toLocalDate();
            LocalDate today = LocalDate.now();

            if (showLocalDate.isBefore(today)) {
                forwardWithError(request, response, "Không thể tạo suất chiếu trong quá khứ! Ngày chiếu (" + showDateStr + ") phải từ hôm nay trở đi.");
                return;
            }

            if (showLocalDate.isAfter(today.plusYears(1))) {
                forwardWithError(request, response, "Ngày chiếu (" + showDateStr + ") không được vượt quá 1 năm trong tương lai!");
                return;
            }

            if (movie.getReleaseDate() != null && showDate.before(movie.getReleaseDate())) {
                forwardWithError(request, response, "Ngày chiếu (" + showDateStr + ") không được trước ngày khởi chiếu của phim (" + movie.getReleaseDate() + ")!");
                return;
            }
            if (movie.getEndDate() != null && showDate.after(movie.getEndDate())) {
                forwardWithError(request, response, "Ngày chiếu (" + showDateStr + ") không được sau ngày kết thúc của phim (" + movie.getEndDate() + ")!");
                return;
            }

            startStr = startStr.trim();
            endStr = endStr.trim();
            if (startStr.length() == 5) startStr += ":00";
            if (endStr.length() == 5) endStr += ":00";
            Time startTime = Time.valueOf(startStr);
            Time endTime = Time.valueOf(endStr);

            if (showLocalDate.isEqual(today)) {
                LocalTime nowTime = LocalTime.now();
                if (startTime.toLocalTime().isBefore(nowTime)) {
                    String nowFormatted = String.format("%02d:%02d", nowTime.getHour(), nowTime.getMinute());
                    forwardWithError(request, response, "Giờ bắt đầu (" + startStr.substring(0, 5) + ") không được ở trong quá khứ so với hiện tại (" + nowFormatted + ")!");
                    return;
                }
            }

            if (!endTime.after(startTime)) {
                forwardWithError(request, response, "Giờ kết thúc (" + endStr.substring(0, 5) + ") phải sau giờ bắt đầu (" + startStr.substring(0, 5) + ")!");
                return;
            }

            long diffMinutes = (endTime.getTime() - startTime.getTime()) / (60 * 1000);
            if (diffMinutes < movie.getDuration()) {
                forwardWithError(request, response, "Khoảng thời gian chiếu (" + diffMinutes + " phút) phải lớn hơn hoặc bằng thời lượng của phim (" + movie.getDuration() + " phút)!");
                return;
            }

            if (showtimeDAO.hasRoomConflict(roomId, showDate, startTime, endTime, null)) {
                forwardWithError(request, response, "Phòng chiếu đã có suất chiếu khác trong khung giờ " + startStr.substring(0, 5) + " - " + endStr.substring(0, 5) + " ngày " + showDateStr + "!");
                return;
            }

            double basePrice = Double.parseDouble(basePriceStr.trim());
            if (basePrice < 0) {
                forwardWithError(request, response, "Giá vé cơ bản không thể là số âm!");
                return;
            }

            Showtime st = new Showtime();
            st.setMovieId(movieId);
            st.setRoomId(roomId);
            st.setShowDate(showDate);
            st.setStartTime(startTime);
            st.setEndTime(endTime);
            st.setBasePrice(basePrice);
            st.setStatus("OPEN");

            boolean inserted = showtimeDAO.insertShowtime(st);
            if (inserted) {
                response.sendRedirect(request.getContextPath() + "/admin/showtimes?msg=add_success");
                return;
            } else {
                forwardWithError(request, response, "Không thể lưu suất chiếu vào cơ sở dữ liệu!");
                return;
            }
        } catch (IllegalArgumentException e) {
            forwardWithError(request, response, "Định dạng ngày hoặc giờ không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }
}

