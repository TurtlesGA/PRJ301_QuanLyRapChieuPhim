package com.cinema.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String role; // 'ADMIN', 'STAFF', 'CUSTOMER'
    private boolean status; // true: Active, false: Locked
    private Timestamp createdAt;

    public User() {
    }

    public User(int userId, String username, String password, String fullName, String email, String phone, String role, boolean status, Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fixEncoding(fullName);
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    private static String fixEncoding(String str) {
        if (str == null) return null;
        if (str.contains("áº") || str.contains("á»") || str.contains("Ã") || str.contains("Quáº£n")) {
            try {
                return new String(str.getBytes(java.nio.charset.Charset.forName("windows-1252")), java.nio.charset.StandardCharsets.UTF_8);
            } catch (Exception ignored) {
            }
        }
        return str;
    }

    public String getFullName() {
        return fixEncoding(fullName);
    }

    public void setFullName(String fullName) {
        this.fullName = fixEncoding(fullName);
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }
}
