package com.cinema.dao;

import com.cinema.context.DBContext;
import com.cinema.model.Language;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LanguageDAO {
    private DBContext db = new DBContext();

    /**
     * Lấy toàn bộ ngôn ngữ đang active
     */
    public List<Language> getAllActiveLanguages() {
        List<Language> list = new ArrayList<>();
        String sql = "SELECT lang_code, country_name, flag_url, is_active, is_default, created_at "
                   + "FROM Languages WHERE is_active = 1 ORDER BY is_default DESC, lang_code ASC";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Language l = new Language();
                l.setLangCode(rs.getString("lang_code"));
                l.setCountryName(rs.getString("country_name"));
                l.setFlagUrl(rs.getString("flag_url"));
                l.setActive(rs.getBoolean("is_active"));
                l.setDefault(rs.getBoolean("is_default"));
                l.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(l);
            }
        } catch (Exception e) {
            System.err.println("LanguageDAO.getAllActiveLanguages error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Kiểm tra mã ngôn ngữ đã tồn tại chưa
     */
    public boolean exists(String langCode) {
        if (langCode == null) return false;
        String sql = "SELECT 1 FROM Languages WHERE LOWER(lang_code) = LOWER(?)";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, langCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.err.println("LanguageDAO.exists error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Thêm mới hoặc cập nhật ngôn ngữ
     */
    public boolean saveLanguage(Language l) {
        if (l == null || l.getLangCode() == null) return false;
        String sql = "IF EXISTS (SELECT 1 FROM Languages WHERE lang_code = ?) "
                   + "UPDATE Languages SET country_name = ?, flag_url = ?, is_active = ?, is_default = ? WHERE lang_code = ? "
                   + "ELSE "
                   + "INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, l.getLangCode());
            ps.setString(2, l.getCountryName());
            ps.setString(3, l.getFlagUrl());
            ps.setBoolean(4, l.isActive());
            ps.setBoolean(5, l.isDefault());
            ps.setString(6, l.getLangCode());

            ps.setString(7, l.getLangCode());
            ps.setString(8, l.getCountryName());
            ps.setString(9, l.getFlagUrl());
            ps.setBoolean(10, l.isActive());
            ps.setBoolean(11, l.isDefault());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("LanguageDAO.saveLanguage error: " + e.getMessage());
            return false;
        }
    }
}
