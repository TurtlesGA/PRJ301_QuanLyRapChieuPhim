package com.cinema.model;

import java.sql.Timestamp;
import java.util.List;

public class Booking {
    private int bookingId;
    private int userId;
    private int showtimeId;
    private String bookingCode;
    private double totalAmount;
    private String paymentStatus; // PAID, PENDING, CANCELLED
    private String paymentMethod; // VNPAY, MOMO, CASH
    private Timestamp bookingTime;

    // Quan hệ kết nối hiển thị
    private User user;
    private Showtime showtime;
    private List<Ticket> tickets;

    public Booking() {
    }

    public Booking(int bookingId, int userId, int showtimeId, String bookingCode, double totalAmount,
                   String paymentStatus, String paymentMethod, Timestamp bookingTime) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.showtimeId = showtimeId;
        this.bookingCode = bookingCode;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
        this.paymentMethod = paymentMethod;
        this.bookingTime = bookingTime;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Timestamp bookingTime) {
        this.bookingTime = bookingTime;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Showtime getShowtime() {
        return showtime;
    }

    public void setShowtime(Showtime showtime) {
        this.showtime = showtime;
    }

    public List<Ticket> getTickets() {
        return tickets;
    }

    public void setTickets(List<Ticket> tickets) {
        this.tickets = tickets;
    }
}
