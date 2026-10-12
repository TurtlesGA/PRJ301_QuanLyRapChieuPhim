package com.cinema.model;

public class Room {
    private int roomId;
    private String roomName;
    private String roomType; // 2D, 3D, IMAX, 4DX
    private int totalRows;
    private int totalCols;
    private boolean status;

    public Room() {
    }

    public Room(int roomId, String roomName, String roomType, int totalRows, int totalCols, boolean status) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.roomType = roomType;
        this.totalRows = totalRows;
        this.totalCols = totalCols;
        this.status = status;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getTotalRows() {
        return totalRows;
    }

    public void setTotalRows(int totalRows) {
        this.totalRows = totalRows;
    }

    public int getTotalCols() {
        return totalCols;
    }

    public void setTotalCols(int totalCols) {
        this.totalCols = totalCols;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
