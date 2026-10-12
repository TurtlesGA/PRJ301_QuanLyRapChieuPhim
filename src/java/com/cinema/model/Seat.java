package com.cinema.model;

public class Seat {
    private int seatId;
    private int roomId;
    private String seatRow; // A, B, C...
    private int seatNumber; // 1, 2, 3...
    private String seatType; // STANDARD, VIP, COUPLE
    private double priceModifier;
    
    // Thuộc tính tiện ích khi chọn ghế
    private boolean isBooked;

    public Seat() {
    }

    public Seat(int seatId, int roomId, String seatRow, int seatNumber, String seatType, double priceModifier) {
        this.seatId = seatId;
        this.roomId = roomId;
        this.seatRow = seatRow;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.priceModifier = priceModifier;
    }

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getSeatRow() {
        return seatRow;
    }

    public void setSeatRow(String seatRow) {
        this.seatRow = seatRow;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public double getPriceModifier() {
        return priceModifier;
    }

    public void setPriceModifier(double priceModifier) {
        this.priceModifier = priceModifier;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public void setBooked(boolean booked) {
        isBooked = booked;
    }

    public String getSeatCode() {
        return seatRow + seatNumber;
    }
}
