package com.cinema.model;

public class Ticket {
    private int ticketId;
    private int bookingId;
    private int seatId;
    private double price;

    // Quan hệ kết nối hiển thị
    private Seat seat;

    public Ticket() {
    }

    public Ticket(int ticketId, int bookingId, int seatId, double price) {
        this.ticketId = ticketId;
        this.bookingId = bookingId;
        this.seatId = seatId;
        this.price = price;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Seat getSeat() {
        return seat;
    }

    public void setSeat(Seat seat) {
        this.seat = seat;
    }
}
