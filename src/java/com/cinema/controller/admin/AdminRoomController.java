package com.cinema.controller.admin;

import com.cinema.dao.RoomDAO;
import com.cinema.model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminRoomController", urlPatterns = {"/admin/rooms", "/admin/room-add", "/admin/room-edit", "/admin/room-toggle", "/admin/room-delete"})
public class AdminRoomController extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/rooms".equals(servletPath)) {
            List<Room> rooms = roomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("/WEB-INF/views/admin/rooms.jsp").forward(request, response);
        } else if ("/admin/room-add".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/room-form.jsp").forward(request, response);
        } else if ("/admin/room-edit".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Room room = roomDAO.getRoomById(id);
                if (room != null) {
                    request.setAttribute("room", room);
                    request.getRequestDispatcher("/WEB-INF/views/admin/room-form.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/rooms");
        } else if ("/admin/room-toggle".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Room room = roomDAO.getRoomById(id);
                if (room != null) {
                    roomDAO.toggleRoomStatus(id, room.isStatus());
                }
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/rooms");
        } else if ("/admin/room-delete".equals(servletPath)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                roomDAO.deleteRoom(id);
            } catch (Exception ignored) {
            }
            response.sendRedirect(request.getContextPath() + "/admin/rooms");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("roomId");
            String roomName = request.getParameter("roomName");
            String roomType = request.getParameter("roomType");
            String statusStr = request.getParameter("status");
            boolean status = true;
            if ("0".equals(statusStr) || "false".equalsIgnoreCase(statusStr)) {
                status = false;
            }

            if (idStr != null && !idStr.isEmpty()) {
                int roomId = Integer.parseInt(idStr);
                Room room = new Room();
                room.setRoomId(roomId);
                room.setRoomName(roomName);
                room.setRoomType(roomType);
                room.setStatus(status);
                roomDAO.updateRoom(room);
            } else {
                int totalRows = Integer.parseInt(request.getParameter("totalRows"));
                int totalCols = Integer.parseInt(request.getParameter("totalCols"));
                Room room = new Room();
                room.setRoomName(roomName);
                room.setRoomType(roomType);
                room.setTotalRows(totalRows);
                room.setTotalCols(totalCols);
                room.setStatus(status);
                roomDAO.insertRoom(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/rooms");
    }
}
