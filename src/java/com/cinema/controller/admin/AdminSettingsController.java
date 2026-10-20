package com.cinema.controller.admin;

import com.cinema.dao.LanguageDAO;
import com.cinema.dao.SettingDAO;
import com.cinema.model.Language;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "AdminSettingsController", urlPatterns = {"/admin/settings"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 10 * 1024 * 1024,       // 10 MB
        maxRequestSize = 25 * 1024 * 1024     // 25 MB
)
public class AdminSettingsController extends HttpServlet {

    private SettingDAO settingDAO = new SettingDAO();
    private LanguageDAO languageDAO = new LanguageDAO();

    private static final Set<String> ALLOWED_IMAGE_EXTS = new HashSet<>(
            Arrays.asList(".png", ".jpg", ".jpeg", ".svg", ".webp")
    );

    private static final String[] REQUIRED_JSON_KEYS = {
            "\"common\"", "\"nav\"", "\"footer\"", "\"home\"", "\"status\""
    };

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Action: Tải file template mẫu
        if ("download-template".equalsIgnoreCase(action)) {
            downloadTemplate(request, response);
            return;
        }

        // Mặc định: Hiển thị trang Admin Settings
        Map<String, String> settings = settingDAO.getAllSettings();
        List<Language> languages = languageDAO.getAllActiveLanguages();

        request.setAttribute("settings", settings);
        request.setAttribute("languages", languages);
        request.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("saveSettings".equalsIgnoreCase(action)) {
            handleSaveSettings(request, response);
        } else if ("uploadLanguage".equalsIgnoreCase(action)) {
            handleUploadLanguage(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/settings");
        }
    }

    private void handleSaveSettings(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Map<String, String> settings = new HashMap<>();

        settings.put("site_title", getParam(request, "site_title", "CineStar - Đặt Vé Xem Phim Trực Tuyến"));
        settings.put("site_favicon", getParam(request, "site_favicon", ""));
        settings.put("header_brand_name", getParam(request, "header_brand_name", "CINESTAR"));
        settings.put("header_slogan", getParam(request, "header_slogan", "Trải nghiệm điện ảnh đỉnh cao"));

        settings.put("footer_description", getParam(request, "footer_description", "Hệ thống rạp chiếu phim hiện đại chuẩn quốc tế. Mang đến trải nghiệm điện ảnh chân thực và sống động nhất cho khán giả."));
        settings.put("footer_hotline", getParam(request, "footer_hotline", "1900 6017"));
        settings.put("footer_email", getParam(request, "footer_email", "support@cinestar.vn"));
        settings.put("footer_hours", getParam(request, "footer_hours", "8:00 - 22:00 Hàng ngày"));
        settings.put("footer_copyright", getParam(request, "footer_copyright", "© 2026 CineStar Cinema - PRJ302 Quản Lý Rạp Chiếu Phim."));

        settings.put("script_head", getParam(request, "script_head", ""));
        settings.put("script_body", getParam(request, "script_body", ""));
        settings.put("script_foot", getParam(request, "script_foot", ""));

        boolean success = settingDAO.saveAll(settings);

        if (success) {
            // Update ServletContext applicationScope cache
            request.getServletContext().setAttribute("siteSettings", settings);
            response.sendRedirect(request.getContextPath() + "/admin/settings?msg=settings_saved");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/settings?error=settings_save_failed");
        }
    }

    private void handleUploadLanguage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String countryName = getParam(request, "countryName", "");
        String rawLangCode = getParam(request, "langCode", "");

        if (countryName.isEmpty() || rawLangCode.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=missing_fields");
            return;
        }

        // Chuẩn hóa mã ngôn ngữ
        String langCode = rawLangCode.trim().toLowerCase().replaceAll("[^a-z0-9_-]", "");
        if (langCode.length() < 2 || langCode.length() > 10) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=invalid_lang_code");
            return;
        }

        // 1. Kiểm tra trùng lặp mã ngôn ngữ
        if (languageDAO.exists(langCode)) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=lang_exists&code=" + langCode);
            return;
        }

        // 2. Validate và lưu ảnh cờ
        Part flagPart = request.getPart("flagImage");
        if (flagPart == null || flagPart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=missing_flag");
            return;
        }

        String flagFileName = Paths.get(flagPart.getSubmittedFileName()).getFileName().toString();
        String flagExt = "";
        int dotIdx = flagFileName.lastIndexOf('.');
        if (dotIdx > 0) {
            flagExt = flagFileName.substring(dotIdx).toLowerCase();
        }

        if (!ALLOWED_IMAGE_EXTS.contains(flagExt)) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=invalid_image_format");
            return;
        }

        String flagContentType = flagPart.getContentType();
        if (flagContentType == null || (!flagContentType.startsWith("image/") && !flagContentType.contains("svg"))) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=invalid_image_mime");
            return;
        }

        // 3. Validate và đọc file JSON bản dịch
        Part jsonPart = request.getPart("jsonFile");
        if (jsonPart == null || jsonPart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=missing_json");
            return;
        }

        String jsonFileName = Paths.get(jsonPart.getSubmittedFileName()).getFileName().toString();
        if (!jsonFileName.toLowerCase().endsWith(".json")) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=invalid_json_extension");
            return;
        }

        byte[] jsonBytes = jsonPart.getInputStream().readAllBytes();
        String jsonContent = new String(jsonBytes, StandardCharsets.UTF_8).trim();

        if (!jsonContent.startsWith("{") || !jsonContent.endsWith("}")) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=json_syntax_invalid");
            return;
        }

        // Kiểm tra các trường bắt buộc của template
        for (String key : REQUIRED_JSON_KEYS) {
            if (!jsonContent.contains(key)) {
                response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=json_missing_keys&missing=" + key.replace("\"", ""));
                return;
            }
        }

        // 4. Lưu file cờ vào cả thư mục build và web nguồn
        String flagSavedName = langCode + flagExt;
        saveFileToDisk(request, flagPart.getInputStream(), "assets/images/flags", flagSavedName);

        // 5. Lưu file json vào cả thư mục build và web nguồn
        String jsonSavedName = langCode + ".json";
        saveContentToDisk(request, jsonBytes, "assets/i18n", jsonSavedName);

        // 6. Lưu thông tin ngôn ngữ vào Database
        Language lang = new Language();
        lang.setLangCode(langCode);
        lang.setCountryName(countryName.trim());
        lang.setFlagUrl("/assets/images/flags/" + flagSavedName);
        lang.setActive(true);
        lang.setDefault(false);
        boolean dbSaved = languageDAO.saveLanguage(lang);

        if (dbSaved) {
            // 7. Đồng bộ file languages.json và cache ServletContext
            List<Language> allLangs = languageDAO.getAllActiveLanguages();
            request.getServletContext().setAttribute("activeLanguages", allLangs);
            updateLanguagesJson(request, allLangs);

            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&msg=lang_added&code=" + langCode);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/settings?tab=languages&error=lang_db_failed");
        }
    }

    private void downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String templatePath = request.getServletContext().getRealPath("/assets/i18n/template.json");
        File file = new File(templatePath);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Template file not found");
            return;
        }

        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"template.json\"");
        response.setContentLengthLong(file.length());

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buf = new byte[8192];
            int len;
            while ((len = in.read(buf)) != -1) {
                out.write(buf, 0, len);
            }
        }
    }

    private void saveFileToDisk(HttpServletRequest request, InputStream in, String relativeDir, String fileName) throws IOException {
        byte[] bytes = in.readAllBytes();
        saveContentToDisk(request, bytes, relativeDir, fileName);
    }

    private void saveContentToDisk(HttpServletRequest request, byte[] content, String relativeDir, String fileName) throws IOException {
        // 1. Thư mục deployed của Tomcat
        String deployPath = request.getServletContext().getRealPath("/" + relativeDir);
        if (deployPath != null) {
            File dir = new File(deployPath);
            if (!dir.exists()) dir.mkdirs();
            File file = new File(dir, fileName);
            try (FileOutputStream fos = new FileOutputStream(file)) {
                fos.write(content);
            }
        }

        // 2. Thư mục project nguồn web/ (để code không bị mất khi build lại)
        try {
            String appPath = request.getServletContext().getRealPath("/");
            // appPath typically: D:\Java Coding\PRJ302_QuanLyRapChieuPhim\build\web\
            File appDir = new File(appPath);
            File projectRoot = appDir.getParentFile().getParentFile(); // Back up to project root
            File srcWebDir = new File(projectRoot, "web" + File.separator + relativeDir.replace('/', File.separatorChar));
            if (srcWebDir.exists() || srcWebDir.mkdirs()) {
                File srcFile = new File(srcWebDir, fileName);
                try (FileOutputStream fos = new FileOutputStream(srcFile)) {
                    fos.write(content);
                }
            }
        } catch (Exception ignored) {
        }
    }

    private void updateLanguagesJson(HttpServletRequest request, List<Language> languages) {
        StringBuilder sb = new StringBuilder("[\n");
        for (int i = 0; i < languages.size(); i++) {
            Language l = languages.get(i);
            sb.append("  {\n");
            sb.append("    \"code\": \"").append(escapeJson(l.getLangCode())).append("\",\n");
            sb.append("    \"name\": \"").append(escapeJson(l.getCountryName())).append("\",\n");
            sb.append("    \"country\": \"").append(escapeJson(l.getCountryName())).append("\",\n");
            sb.append("    \"flag\": \"").append(escapeJson(l.getFlagUrl())).append("\",\n");
            sb.append("    \"isDefault\": ").append(l.isDefault()).append("\n");
            sb.append("  }").append(i < languages.size() - 1 ? ",\n" : "\n");
        }
        sb.append("]\n");

        byte[] bytes = sb.toString().getBytes(StandardCharsets.UTF_8);
        try {
            saveContentToDisk(request, bytes, "assets/i18n", "languages.json");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private String getParam(HttpServletRequest request, String name, String defaultVal) {
        String val = request.getParameter(name);
        return (val != null) ? val.trim() : defaultVal;
    }
}
