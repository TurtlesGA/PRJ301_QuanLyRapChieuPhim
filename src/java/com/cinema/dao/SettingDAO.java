package com.cinema.dao;

import com.cinema.context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class SettingDAO {
    private DBContext db = new DBContext();

    /**
     * Lấy toàn bộ settings dạng key-value
     */
    public Map<String, String> getAllSettings() {
        Map<String, String> map = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM SystemSettings";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (Exception e) {
            System.err.println("SettingDAO.getAllSettings error: " + e.getMessage());
        }
        return map;
    }

    /**
     * Lấy giá trị của một setting cụ thể
     */
    public String getSetting(String key, String defaultVal) {
        String sql = "SELECT setting_value FROM SystemSettings WHERE setting_key = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String val = rs.getString("setting_value");
                    return val != null ? val : defaultVal;
                }
            }
        } catch (Exception e) {
            System.err.println("SettingDAO.getSetting error: " + e.getMessage());
        }
        return defaultVal;
    }

    /**
     * Cập nhật hoặc thêm mới một setting
     */
    public boolean saveSetting(String key, String value) {
        String sql = "IF EXISTS (SELECT 1 FROM SystemSettings WHERE setting_key = ?) "
                   + "UPDATE SystemSettings SET setting_value = ?, updated_at = GETDATE() WHERE setting_key = ? "
                   + "ELSE "
                   + "INSERT INTO SystemSettings (setting_key, setting_value) VALUES (?, ?)";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.setString(3, key);
            ps.setString(4, key);
            ps.setString(5, value);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("SettingDAO.saveSetting error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Lưu hàng loạt settings
     */
    public boolean saveAll(Map<String, String> settings) {
        if (settings == null || settings.isEmpty()) return true;
        for (Map.Entry<String, String> entry : settings.entrySet()) {
            saveSetting(entry.getKey(), entry.getValue());
        }
        return true;
    }
}
