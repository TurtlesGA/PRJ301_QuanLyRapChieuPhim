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
                l.setCountryName(MovieDAO.fixEncoding(rs.getString("country_name")));
                l.setFlagUrl(rs.getString("flag_url"));
                l.setActive(rs.getBoolean("is_active"));
                l.setDefault(rs.getBoolean("is_default"));
                l.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(l);
            }
        } catch (Exception e) {
            System.err.println("LanguageDAO.getAllActiveLanguages error: " + e.getMessage());
        }

        if (list.isEmpty()) {
            ensureDefaultLanguages();
            try (Connection conn = db.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Language l = new Language();
                    l.setLangCode(rs.getString("lang_code"));
                    l.setCountryName(MovieDAO.fixEncoding(rs.getString("country_name")));
                    l.setFlagUrl(rs.getString("flag_url"));
                    l.setActive(rs.getBoolean("is_active"));
                    l.setDefault(rs.getBoolean("is_default"));
                    l.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(l);
                }
            } catch (Exception ex) {
                System.err.println("LanguageDAO.getAllActiveLanguages retry error: " + ex.getMessage());
            }
        }

        return list;
    }

    private void ensureDefaultLanguages() {
        try (Connection conn = db.getConnection()) {
            String checkTable = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Languages' AND xtype='U') "
                              + "CREATE TABLE Languages ("
                              + "  lang_code VARCHAR(10) PRIMARY KEY,"
                              + "  country_name NVARCHAR(100) NOT NULL,"
                              + "  flag_url VARCHAR(255) NOT NULL,"
                              + "  is_active BIT DEFAULT 1,"
                              + "  is_default BIT DEFAULT 0,"
                              + "  created_at DATETIME DEFAULT GETDATE()"
                              + ");";
            try (PreparedStatement ps = conn.prepareStatement(checkTable)) {
                ps.executeUpdate();
            }

            String seedSql = "IF NOT EXISTS (SELECT 1 FROM Languages WHERE lang_code = 'vi') "
                           + "INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('vi', N'Việt Nam', '/assets/images/flags/vn.svg', 1, 1); "
                           + "ELSE UPDATE Languages SET country_name = N'Việt Nam' WHERE lang_code = 'vi'; "
                           + "IF NOT EXISTS (SELECT 1 FROM Languages WHERE lang_code = 'en') "
                           + "INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('en', N'United States', '/assets/images/flags/us.svg', 1, 0); "
                           + "IF NOT EXISTS (SELECT 1 FROM Languages WHERE lang_code = 'fr') "
                           + "INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('fr', N'France', '/assets/images/flags/fr.svg', 1, 0);";
            try (PreparedStatement ps = conn.prepareStatement(seedSql)) {
                ps.executeUpdate();
            }
        } catch (Exception ex) {
            System.err.println("LanguageDAO.ensureDefaultLanguages error: " + ex.getMessage());
        }
    }

    /**
     * Lấy thông tin một ngôn ngữ cụ thể theo mã
     */
    public Language getLanguageByCode(String langCode) {
        if (langCode == null) return null;
        String sql = "SELECT lang_code, country_name, flag_url, is_active, is_default, created_at "
                   + "FROM Languages WHERE LOWER(lang_code) = LOWER(?)";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, langCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Language l = new Language();
                    l.setLangCode(rs.getString("lang_code"));
                    l.setCountryName(rs.getString("country_name"));
                    l.setFlagUrl(rs.getString("flag_url"));
                    l.setActive(rs.getBoolean("is_active"));
                    l.setDefault(rs.getBoolean("is_default"));
                    l.setCreatedAt(rs.getTimestamp("created_at"));
                    return l;
                }
            }
        } catch (Exception e) {
            System.err.println("LanguageDAO.getLanguageByCode error: " + e.getMessage());
        }
        return null;
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

    /**
     * Đặt một ngôn ngữ làm mặc định (và hủy mặc định của các ngôn ngữ khác)
     */
    public boolean setDefaultLanguage(String langCode) {
        if (langCode == null) return false;
        String resetSql = "UPDATE Languages SET is_default = 0";
        String setSql = "UPDATE Languages SET is_default = 1 WHERE LOWER(lang_code) = LOWER(?)";
        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psReset = conn.prepareStatement(resetSql);
                 PreparedStatement psSet = conn.prepareStatement(setSql)) {
                psReset.executeUpdate();
                psSet.setString(1, langCode.trim());
                int updated = psSet.executeUpdate();
                conn.commit();
                return updated > 0;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.err.println("LanguageDAO.setDefaultLanguage error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Xóa một gói ngôn ngữ khỏi cơ sở dữ liệu
     * Không cho phép xóa ngôn ngữ mặc định (is_default = 1)
     */
    public boolean deleteLanguage(String langCode) {
        if (langCode == null) return false;
        String sql = "DELETE FROM Languages WHERE LOWER(lang_code) = LOWER(?) AND is_default = 0";
        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Xóa các bản dịch phim phụ thuộc nếu có
                try (PreparedStatement psTrans = conn.prepareStatement("DELETE FROM MovieTranslations WHERE LOWER(lang_code) = LOWER(?)")) {
                    psTrans.setString(1, langCode.trim());
                    psTrans.executeUpdate();
                } catch (Exception ignore) {
                }

                int deleted;
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, langCode.trim());
                    deleted = ps.executeUpdate();
                }
                conn.commit();
                return deleted > 0;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.err.println("LanguageDAO.deleteLanguage error: " + e.getMessage());
            return false;
        }
    }
}
