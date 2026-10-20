package com.cinema.context;

import java.sql.Connection;
import java.sql.Statement;

public class MigrateDB {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection(); Statement stmt = conn.createStatement()) {
            System.out.println("Executing database migration...");

            // 1. Table: SystemSettings
            String sqlSettings = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemSettings' AND xtype='U')\n"
                    + "CREATE TABLE SystemSettings (\n"
                    + "    setting_key VARCHAR(50) PRIMARY KEY,\n"
                    + "    setting_value NVARCHAR(MAX),\n"
                    + "    updated_at DATETIME DEFAULT GETDATE()\n"
                    + ");";
            stmt.execute(sqlSettings);
            System.out.println(" - Table SystemSettings ensured.");

            // 2. Table: Languages
            String sqlLanguages = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Languages' AND xtype='U')\n"
                    + "CREATE TABLE Languages (\n"
                    + "    lang_code VARCHAR(10) PRIMARY KEY,\n"
                    + "    country_name NVARCHAR(100) NOT NULL,\n"
                    + "    flag_url NVARCHAR(255) NOT NULL,\n"
                    + "    is_active BIT DEFAULT 1,\n"
                    + "    is_default BIT DEFAULT 0,\n"
                    + "    created_at DATETIME DEFAULT GETDATE()\n"
                    + ");";
            stmt.execute(sqlLanguages);
            System.out.println(" - Table Languages ensured.");

            // 3. Table: MovieTranslations
            String sqlTranslations = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='MovieTranslations' AND xtype='U')\n"
                    + "CREATE TABLE MovieTranslations (\n"
                    + "    translation_id INT IDENTITY(1,1) PRIMARY KEY,\n"
                    + "    movie_id INT NOT NULL,\n"
                    + "    lang_code VARCHAR(10) NOT NULL,\n"
                    + "    title NVARCHAR(255) NOT NULL,\n"
                    + "    genre NVARCHAR(255),\n"
                    + "    description NVARCHAR(MAX),\n"
                    + "    director NVARCHAR(100),\n"
                    + "    cast NVARCHAR(255),\n"
                    + "    updated_at DATETIME DEFAULT GETDATE(),\n"
                    + "    CONSTRAINT FK_MovieTranslations_Movies FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,\n"
                    + "    CONSTRAINT UQ_Movie_Lang UNIQUE(movie_id, lang_code)\n"
                    + ");";
            stmt.execute(sqlTranslations);
            System.out.println(" - Table MovieTranslations ensured.");

            // Seed Languages
            String seedLanguages = "IF NOT EXISTS (SELECT * FROM Languages WHERE lang_code='vi')\n"
                    + "INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('vi', N'Việt Nam', '/assets/images/flags/vn.svg', 1, 1);\n"
                    + "IF NOT EXISTS (SELECT * FROM Languages WHERE lang_code='en')\n"
                    + "INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('en', N'United States', '/assets/images/flags/us.svg', 1, 0);";
            stmt.execute(seedLanguages);
            System.out.println(" - Seeded default languages (vi, en).");

            // Seed SystemSettings
            String[] defaultSettings = {
                "site_title", "CineStar - Đặt Vé Xem Phim Trực Tuyến",
                "site_favicon", "/assets/images/favicon.ico",
                "header_brand_prefix", "CINE",
                "header_brand_suffix", "STAR",
                "footer_brand", "CINESTAR CINEMA",
                "footer_description", "Hệ thống rạp chiếu phim hiện đại chuẩn quốc tế. Mang đến trải nghiệm điện ảnh chân thực và sống động nhất cho khán giả.",
                "footer_hotline", "1900 6017",
                "footer_email", "support@cinestar.vn",
                "footer_hours", "8:00 - 22:00 Hàng ngày",
                "footer_copyright", "© 2026 CineStar Cinema - PRJ302 Quản Lý Rạp Chiếu Phim. Thiết kế & phát triển bởi Nhóm Dự Án.",
                "script_head", "",
                "script_body", "",
                "script_foot", ""
            };
            for (int i = 0; i < defaultSettings.length; i += 2) {
                String k = defaultSettings[i];
                String v = defaultSettings[i + 1].replace("'", "''");
                String sql = "IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='" + k + "')\n"
                        + "INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('" + k + "', N'" + v + "');";
                stmt.execute(sql);
            }
            System.out.println(" - Seeded default system settings.");

            // Seed MovieTranslations for existing movies
            // 1: Mai
            String seedT = "IF EXISTS (SELECT * FROM Movies WHERE movie_id=1)\n"
                    + "BEGIN\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=1 AND lang_code='vi')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (1, 'vi', N'Mai', N'Tâm Lý, Tình Cảm', N'Mai xoay quanh cuộc đời của người phụ nữ cùng tên. Số phận đưa đẩy cô gặp gỡ Dương - chàng trai trẻ tuổi, đào hoa, mở ra mối tình vừa ngọt ngào vừa đầy thử thách.', N'Trấn Thành', N'Phương Anh Đào, Tuấn Trần, Trấn Thành, Hồng Đào');\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=1 AND lang_code='en')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (1, 'en', N'Mai', N'Drama, Romance', N'Mai revolves around the life of a woman of the same name. Fate brings her together with Duong - a young, charming man, unfolding a romance that is both sweet and challenging.', N'Tran Thanh', N'Phuong Anh Dao, Tuan Tran, Tran Thanh, Hong Dao');\n"
                    + "END\n"
                    // 2: Dune 2
                    + "IF EXISTS (SELECT * FROM Movies WHERE movie_id=2)\n"
                    + "BEGIN\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=2 AND lang_code='vi')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (2, 'vi', N'Dune: Hành Tinh Cát 2', N'Khoa Học Viễn Tưởng, Phiêu Lưu', N'Hành trình của Paul Atreides khi anh hợp nhất với Chani và người Fremen để trả thù những kẻ đã hủy hoại gia đình mình.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson');\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=2 AND lang_code='en')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (2, 'en', N'Dune: Part Two', N'Sci-Fi, Adventure', N'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson');\n"
                    + "END\n"
                    // 3: Godzilla x Kong
                    + "IF EXISTS (SELECT * FROM Movies WHERE movie_id=3)\n"
                    + "BEGIN\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=3 AND lang_code='vi')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (3, 'vi', N'Godzilla x Kong: Đế Chế Mới', N'Hành Động, Viễn Tưởng', N'Hai thực thể hùng mạnh Godzilla và Kong phải hợp sức chống lại mối hiểm họa khổng lồ tiềm ẩn sâu trong lòng Trái Đất.', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens');\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=3 AND lang_code='en')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (3, 'en', N'Godzilla x Kong: The New Empire', N'Action, Sci-Fi', N'Two ancient titans, Godzilla and Kong, clash in an epic battle as humans unravel their intertwined origins and connection to Skull Island''s mysteries.', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens');\n"
                    + "END\n"
                    // 4: Kung Fu Panda 4
                    + "IF EXISTS (SELECT * FROM Movies WHERE movie_id=4)\n"
                    + "BEGIN\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=4 AND lang_code='vi')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (4, 'vi', N'Kung Fu Panda 4', N'Hoạt Hình, Hài Hước', N'Po chuẩn bị trở thành Thủ lĩnh Tinh thần của Thung lũng Bình Yên nhưng phải đối đầu với phù thủy Tắc Kè Hoa có khả năng biến hình nguy hiểm.', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis');\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=4 AND lang_code='en')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (4, 'en', N'Kung Fu Panda 4', N'Animation, Comedy', N'Po must train a new Dragon Warrior while facing a wicked chameleon sorceress who can shapeshift into any creature.', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis');\n"
                    + "END\n"
                    // 5: Lat Mat 7
                    + "IF EXISTS (SELECT * FROM Movies WHERE movie_id=5)\n"
                    + "BEGIN\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=5 AND lang_code='vi')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (5, 'vi', N'Lật Mặt 7: Một Điều Ước', N'Gia Đình, Tâm Lý', N'Câu chuyện cảm động về gia đình bà Hai và 5 người con, phản ánh tình mẫu tử thiêng liêng và thực trạng đạo hiếu trong xã hội hiện đại.', N'Lý Hải', N'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung');\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=5 AND lang_code='en')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (5, 'en', N'Face Off 7: One Wish', N'Family, Drama', N'A touching story about Mrs. Hai and her five children, reflecting sacred maternal love and filial piety in modern society.', N'Ly Hai', N'Thanh Hien, Truong Minh Cuong, Dinh Y Nhung');\n"
                    + "END\n"
                    // 6: Deadpool & Wolverine
                    + "IF EXISTS (SELECT * FROM Movies WHERE movie_id=6)\n"
                    + "BEGIN\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=6 AND lang_code='vi')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (6, 'vi', N'Deadpool & Wolverine', N'Hành Động, Siêu Anh Hùng', N'Deadpool và Wolverine bất đắc dĩ hợp tác để bảo vệ dòng thời gian và vũ trụ khỏi sự sụp đổ.', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin');\n"
                    + "  IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=6 AND lang_code='en')\n"
                    + "    INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast) "
                    + "    VALUES (6, 'en', N'Deadpool & Wolverine', N'Action, Superhero', N'Deadpool and Wolverine reluctantly team up to protect the timeline and the multiverse from collapse.', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin');\n"
                    + "END;";
            stmt.execute(seedT);
            System.out.println(" - Seeded movie translations in database.");

            System.out.println("Migration completed successfully!");
        } catch (Exception e) {
            System.err.println("Migration failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
