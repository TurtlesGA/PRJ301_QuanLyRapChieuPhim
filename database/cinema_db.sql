-- ================================================================
-- DATABASE EXPORT: Cinema Management System (CinemaDB)
-- Course: PRJ302 / PRJ301 - Java Web Application
-- Export Date: Tue Nov 03 17:27:04 ICT 2026
-- Database Engine: Microsoft SQL Server
-- Note: UTF-8 encoding with N'' prefix for full Vietnamese unicode support
-- ================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CinemaDB')
BEGIN
    CREATE DATABASE CinemaDB;
END
GO

USE CinemaDB;
GO

-- Drop existing tables in reverse dependency order
IF OBJECT_ID('MovieTranslations', 'U') IS NOT NULL DROP TABLE MovieTranslations;
IF OBJECT_ID('Languages', 'U') IS NOT NULL DROP TABLE Languages;
IF OBJECT_ID('SystemSettings', 'U') IS NOT NULL DROP TABLE SystemSettings;
IF OBJECT_ID('Tickets', 'U') IS NOT NULL DROP TABLE Tickets;
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
IF OBJECT_ID('Showtimes', 'U') IS NOT NULL DROP TABLE Showtimes;
IF OBJECT_ID('Seats', 'U') IS NOT NULL DROP TABLE Seats;
IF OBJECT_ID('Rooms', 'U') IS NOT NULL DROP TABLE Rooms;
IF OBJECT_ID('Movies', 'U') IS NOT NULL DROP TABLE Movies;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- 1. Table: Users
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    status BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 2. Table: Movies
CREATE TABLE Movies (
    movie_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    genre NVARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    release_date DATE NOT NULL,
    end_date DATE,
    director NVARCHAR(100),
    cast NVARCHAR(255),
    description NVARCHAR(MAX),
    poster_url VARCHAR(500),
    trailer_url VARCHAR(500),
    age_rating VARCHAR(10) DEFAULT 'P',
    status VARCHAR(20) DEFAULT 'NOW_SHOWING'
);
GO

-- 3. Table: Rooms
CREATE TABLE Rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_name NVARCHAR(50) NOT NULL,
    room_type VARCHAR(20) DEFAULT '2D',
    total_rows INT NOT NULL DEFAULT 8,
    total_cols INT NOT NULL DEFAULT 10,
    status BIT DEFAULT 1
);
GO

-- 4. Table: Seats
CREATE TABLE Seats (
    seat_id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT FOREIGN KEY REFERENCES Rooms(room_id) ON DELETE CASCADE,
    seat_row CHAR(1) NOT NULL,
    seat_number INT NOT NULL,
    seat_type VARCHAR(20) DEFAULT 'STANDARD',
    price_modifier DECIMAL(10,2) DEFAULT 0.00
);
GO

-- 5. Table: Showtimes
CREATE TABLE Showtimes (
    showtime_id INT IDENTITY(1,1) PRIMARY KEY,
    movie_id INT FOREIGN KEY REFERENCES Movies(movie_id) ON DELETE CASCADE,
    room_id INT FOREIGN KEY REFERENCES Rooms(room_id) ON DELETE CASCADE,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    base_price DECIMAL(10,2) NOT NULL DEFAULT 80000,
    status VARCHAR(20) DEFAULT 'OPEN'
);
GO

-- 6. Table: Bookings
CREATE TABLE Bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
    showtime_id INT FOREIGN KEY REFERENCES Showtimes(showtime_id),
    booking_code VARCHAR(20) UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    payment_method VARCHAR(50) DEFAULT 'VNPAY',
    booking_time DATETIME DEFAULT GETDATE()
);
GO

-- 7. Table: Tickets
CREATE TABLE Tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT FOREIGN KEY REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    seat_id INT FOREIGN KEY REFERENCES Seats(seat_id),
    price DECIMAL(10,2) NOT NULL
);
GO

-- 8. Table: SystemSettings
CREATE TABLE SystemSettings (
    setting_key VARCHAR(50) PRIMARY KEY,
    setting_value NVARCHAR(MAX),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- 9. Table: Languages
CREATE TABLE Languages (
    lang_code VARCHAR(10) PRIMARY KEY,
    country_name NVARCHAR(100) NOT NULL,
    flag_url NVARCHAR(255) NOT NULL,
    is_active BIT DEFAULT 1,
    is_default BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 10. Table: MovieTranslations
CREATE TABLE MovieTranslations (
    translation_id INT IDENTITY(1,1) PRIMARY KEY,
    movie_id INT NOT NULL,
    lang_code VARCHAR(10) NOT NULL,
    title NVARCHAR(255) NOT NULL,
    genre NVARCHAR(255),
    description NVARCHAR(MAX),
    director NVARCHAR(100),
    cast NVARCHAR(255),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_MovieTranslations_Movies FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT UQ_Movie_Lang UNIQUE(movie_id, lang_code)
);
GO

-- ================================================================
-- DATA INSERTION (DML)
-- ================================================================

-- Insert Data for [Users] (4 rows)
SET IDENTITY_INSERT [Users] ON;
INSERT INTO [Users] ([user_id], [username], [password], [full_name], [email], [phone], [role], [status], [created_at]) VALUES
(1, 'admin', '123456', N'Chim Béo', 'admin@cinema.vn', '0901234567', 'ADMIN', 1, '2026-10-12 14:30:19.043'),
(2, 'staff', '123456', N'Nhân Viên Rạp', 'staff@cinema.vn', '0902345678', 'STAFF', 1, '2026-10-12 14:30:19.043'),
(3, 'customer', '123456', N'Nguyễn Văn A', 'customer@gmail.com', '0903456789', 'CUSTOMER', 1, '2026-10-12 14:30:19.043'),
(4, 'user2', '123456', N'Trần Thị B', 'user2@gmail.com', '0904567890', 'CUSTOMER', 1, '2026-10-12 14:30:19.043');
SET IDENTITY_INSERT [Users] OFF;
GO

-- Insert Data for [Movies] (6 rows)
SET IDENTITY_INSERT [Movies] ON;
INSERT INTO [Movies] ([movie_id], [title], [genre], [duration], [release_date], [end_date], [director], [cast], [description], [poster_url], [trailer_url], [age_rating], [status]) VALUES
(1, N'Dune: Hành Tinh Cát - Phần Hai', N'Khoa Học Viễn Tưởng, Phiêu Lưu', 166, '2026-03-01', '2026-05-30', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya', N'Hành trình huyền thoại của Paul Atreides khi anh đoàn tụ cùng Chani và người Fremen.', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500&q=80', 'https://www.youtube.com/watch?v=Way9Dexny3w', 'T16', 'NOW_SHOWING'),
(2, N'Dune: Hành Tinh Cát 2', N'Khoa Học Viễn Tưởng, Phiêu Lưu', 166, '2026-03-01', '2026-12-30', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson', N'Hành trình của Paul Atreides khi anh hợp nhất với Chani và người Fremen để trả thù những kẻ đã hủy hoại gia đình mình.', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500', 'https://www.youtube.com/watch?v=Way9Dexny3w', 'T16', 'NOW_SHOWING'),
(3, N'Godzilla x Kong: Đế Chế Mới', N'Hành Động, Viễn Tưởng', 115, '2026-03-29', '2026-12-30', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens', N'Hai thực thể hùng mạnh Godzilla và Kong phải hợp sức chống lại mối hiểm họa khổng lồ tiềm ẩn sâu trong lòng Trái Đất.', 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=500', 'https://www.youtube.com/watch?v=qqrpMRDuPfc', 'T13', 'NOW_SHOWING'),
(4, N'Kung Fu Panda 4', N'Hoạt Hình, Hài Hước', 94, '2026-03-08', '2026-12-30', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis', N'Po chuẩn bị trở thành Thủ lĩnh Tinh thần của Thung lũng Bình Yên nhưng phải đối đầu với phù thủy Tắc Kè Hoa có khả năng biến hình nguy hiểm.', 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500', 'https://www.youtube.com/watch?v=_inKs4eeHiI', 'P', 'NOW_SHOWING'),
(5, N'Lật Mặt 7: Một Điều Ước', N'Gia Đình, Tâm Lý', 138, '2026-04-26', '2026-12-30', N'Lý Hải', N'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung', N'Câu chuyện cảm động về gia đình bà Hai và 5 người con, phản ánh tình mẫu tử thiêng liêng và thực trạng đạo hiếu trong xã hội hiện đại.', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500', 'https://www.youtube.com/watch?v=d9MyW72ELq0', 'K', 'COMING_SOON'),
(6, N'Deadpool & Wolverine', N'Hành Động, Siêu Anh Hùng', 127, '2026-07-26', '2026-12-30', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin', N'Deadpool và Wolverine bất đắc dĩ hợp tác để bảo vệ dòng thời gian và vũ trụ khỏi sự sụp đổ.', 'https://images.unsplash.com/photo-1563089145-599997674d42?w=500', 'https://www.youtube.com/watch?v=73_1biulkYk', 'T18', 'COMING_SOON');
SET IDENTITY_INSERT [Movies] OFF;
GO

-- Insert Data for [Rooms] (3 rows)
SET IDENTITY_INSERT [Rooms] ON;
INSERT INTO [Rooms] ([room_id], [room_name], [room_type], [total_rows], [total_cols], [status]) VALUES
(1, N'Phòng Cinema 01 (2D)', '2D', 5, 8, 1),
(2, N'Phòng Cinema 02 (3D)', '3D', 5, 8, 1),
(3, N'Phòng Cinema 03 (IMAX)', 'IMAX', 6, 10, 1);
SET IDENTITY_INSERT [Rooms] OFF;
GO

-- Insert Data for [Seats] (80 rows)
SET IDENTITY_INSERT [Seats] ON;
INSERT INTO [Seats] ([seat_id], [room_id], [seat_row], [seat_number], [seat_type], [price_modifier]) VALUES
(1, 1, 'A', 1, 'STANDARD', 0.00),
(2, 2, 'A', 1, 'STANDARD', 0.00),
(3, 1, 'A', 2, 'STANDARD', 0.00),
(4, 2, 'A', 2, 'STANDARD', 0.00),
(5, 1, 'A', 3, 'STANDARD', 0.00),
(6, 2, 'A', 3, 'STANDARD', 0.00),
(7, 1, 'A', 4, 'STANDARD', 0.00),
(8, 2, 'A', 4, 'STANDARD', 0.00),
(9, 1, 'A', 5, 'STANDARD', 0.00),
(10, 2, 'A', 5, 'STANDARD', 0.00),
(11, 1, 'A', 6, 'STANDARD', 0.00),
(12, 2, 'A', 6, 'STANDARD', 0.00),
(13, 1, 'A', 7, 'STANDARD', 0.00),
(14, 2, 'A', 7, 'STANDARD', 0.00),
(15, 1, 'A', 8, 'STANDARD', 0.00),
(16, 2, 'A', 8, 'STANDARD', 0.00),
(17, 1, 'B', 1, 'STANDARD', 0.00),
(18, 2, 'B', 1, 'STANDARD', 0.00),
(19, 1, 'B', 2, 'STANDARD', 0.00),
(20, 2, 'B', 2, 'STANDARD', 0.00),
(21, 1, 'B', 3, 'STANDARD', 0.00),
(22, 2, 'B', 3, 'STANDARD', 0.00),
(23, 1, 'B', 4, 'STANDARD', 0.00),
(24, 2, 'B', 4, 'STANDARD', 0.00),
(25, 1, 'B', 5, 'STANDARD', 0.00),
(26, 2, 'B', 5, 'STANDARD', 0.00),
(27, 1, 'B', 6, 'STANDARD', 0.00),
(28, 2, 'B', 6, 'STANDARD', 0.00),
(29, 1, 'B', 7, 'STANDARD', 0.00),
(30, 2, 'B', 7, 'STANDARD', 0.00),
(31, 1, 'B', 8, 'STANDARD', 0.00),
(32, 2, 'B', 8, 'STANDARD', 0.00),
(33, 1, 'C', 1, 'VIP', 15000.00),
(34, 2, 'C', 1, 'VIP', 15000.00),
(35, 1, 'C', 2, 'VIP', 15000.00),
(36, 2, 'C', 2, 'VIP', 15000.00),
(37, 1, 'C', 3, 'VIP', 15000.00),
(38, 2, 'C', 3, 'VIP', 15000.00),
(39, 1, 'C', 4, 'VIP', 15000.00),
(40, 2, 'C', 4, 'VIP', 15000.00),
(41, 1, 'C', 5, 'VIP', 15000.00),
(42, 2, 'C', 5, 'VIP', 15000.00),
(43, 1, 'C', 6, 'VIP', 15000.00),
(44, 2, 'C', 6, 'VIP', 15000.00),
(45, 1, 'C', 7, 'VIP', 15000.00),
(46, 2, 'C', 7, 'VIP', 15000.00),
(47, 1, 'C', 8, 'VIP', 15000.00),
(48, 2, 'C', 8, 'VIP', 15000.00),
(49, 1, 'D', 1, 'VIP', 15000.00),
(50, 2, 'D', 1, 'VIP', 15000.00);
INSERT INTO [Seats] ([seat_id], [room_id], [seat_row], [seat_number], [seat_type], [price_modifier]) VALUES
(51, 1, 'D', 2, 'VIP', 15000.00),
(52, 2, 'D', 2, 'VIP', 15000.00),
(53, 1, 'D', 3, 'VIP', 15000.00),
(54, 2, 'D', 3, 'VIP', 15000.00),
(55, 1, 'D', 4, 'VIP', 15000.00),
(56, 2, 'D', 4, 'VIP', 15000.00),
(57, 1, 'D', 5, 'VIP', 15000.00),
(58, 2, 'D', 5, 'VIP', 15000.00),
(59, 1, 'D', 6, 'VIP', 15000.00),
(60, 2, 'D', 6, 'VIP', 15000.00),
(61, 1, 'D', 7, 'VIP', 15000.00),
(62, 2, 'D', 7, 'VIP', 15000.00),
(63, 1, 'D', 8, 'VIP', 15000.00),
(64, 2, 'D', 8, 'VIP', 15000.00),
(65, 1, 'E', 1, 'COUPLE', 30000.00),
(66, 2, 'E', 1, 'COUPLE', 30000.00),
(67, 1, 'E', 2, 'COUPLE', 30000.00),
(68, 2, 'E', 2, 'COUPLE', 30000.00),
(69, 1, 'E', 3, 'COUPLE', 30000.00),
(70, 2, 'E', 3, 'COUPLE', 30000.00),
(71, 1, 'E', 4, 'COUPLE', 30000.00),
(72, 2, 'E', 4, 'COUPLE', 30000.00),
(73, 1, 'E', 5, 'COUPLE', 30000.00),
(74, 2, 'E', 5, 'COUPLE', 30000.00),
(75, 1, 'E', 6, 'COUPLE', 30000.00),
(76, 2, 'E', 6, 'COUPLE', 30000.00),
(77, 1, 'E', 7, 'COUPLE', 30000.00),
(78, 2, 'E', 7, 'COUPLE', 30000.00),
(79, 1, 'E', 8, 'COUPLE', 30000.00),
(80, 2, 'E', 8, 'COUPLE', 30000.00);
SET IDENTITY_INSERT [Seats] OFF;
GO

-- Insert Data for [Showtimes] (7 rows)
SET IDENTITY_INSERT [Showtimes] ON;
INSERT INTO [Showtimes] ([showtime_id], [movie_id], [room_id], [show_date], [start_time], [end_time], [base_price], [status]) VALUES
(1, 1, 1, CAST(GETDATE() AS DATE), '09:00:00', '11:15:00', 80000.00, 'OPEN'),
(2, 1, 1, CAST(GETDATE() AS DATE), '14:00:00', '16:15:00', 90000.00, 'OPEN'),
(3, 1, 1, CAST(GETDATE() AS DATE), '19:30:00', '21:45:00', 100000.00, 'OPEN'),
(4, 2, 2, CAST(GETDATE() AS DATE), '10:00:00', '12:45:00', 95000.00, 'OPEN'),
(5, 2, 2, CAST(GETDATE() AS DATE), '18:00:00', '20:45:00', 110000.00, 'OPEN'),
(6, 3, 1, CAST(DATEADD(day, 1, GETDATE()) AS DATE), '13:00:00', '15:00:00', 85000.00, 'OPEN'),
(7, 4, 2, CAST(DATEADD(day, 1, GETDATE()) AS DATE), '16:00:00', '17:35:00', 80000.00, 'OPEN');
SET IDENTITY_INSERT [Showtimes] OFF;
GO

-- Insert Data for [Bookings] (3 rows)
SET IDENTITY_INSERT [Bookings] ON;
INSERT INTO [Bookings] ([booking_id], [user_id], [showtime_id], [booking_code], [total_amount], [payment_status], [payment_method], [booking_time]) VALUES
(1, 3, 1, 'BK2026101201', 190000.00, 'CANCELLED', N'VNPAY', '2026-10-12 14:30:19.38'),
(2, 1, 6, 'BK4578825', 800000.00, 'CANCELLED', N'VNPAY', '2026-10-13 13:56:18.9'),
(3, 1, 7, 'BK4719470', 110000.00, 'CANCELLED', N'VNPAY', '2026-10-13 13:58:39.49');
SET IDENTITY_INSERT [Bookings] OFF;
GO

-- Insert Data for [Tickets] (11 rows)
SET IDENTITY_INSERT [Tickets] ON;
INSERT INTO [Tickets] ([ticket_id], [booking_id], [seat_id], [price]) VALUES
(1, 1, 37, 95000.00),
(2, 1, 39, 95000.00),
(1002, 2, 57, 100000.00),
(1003, 2, 55, 100000.00),
(1004, 2, 53, 100000.00),
(1005, 2, 51, 100000.00),
(1006, 2, 49, 100000.00),
(1007, 2, 59, 100000.00),
(1008, 2, 61, 100000.00),
(1009, 2, 63, 100000.00),
(1010, 3, 80, 110000.00);
SET IDENTITY_INSERT [Tickets] OFF;
GO

-- Insert Data for [SystemSettings] (15 rows)
INSERT INTO [SystemSettings] ([setting_key], [setting_value], [updated_at]) VALUES
('footer_brand', N'CINESTAR CINEMA', '2026-10-20 21:39:20.133'),
('footer_copyright', N'2026 CineStar Luxury Cinema', '2026-10-20 21:57:59.377'),
('footer_description', N'He thong rap chieu phim chuan quoc te CineStar.', '2026-10-20 21:57:59.317'),
('footer_email', N'contact@cinestar.vn', '2026-10-20 21:57:59.43'),
('footer_hotline', N'1900 8888', '2026-10-20 21:57:59.307'),
('footer_hours', N'8:30 - 23:00 Hang ngay', '2026-10-20 21:57:59.33'),
('header_brand_name', N'CINESTAR LUXURY', '2026-10-20 21:57:59.363'),
('header_brand_prefix', N'CINE', '2026-10-20 21:39:20.13'),
('header_brand_suffix', N'STAR', '2026-10-20 21:39:20.133'),
('header_slogan', N'Dinh Cao Dien Anh', '2026-10-20 21:57:59.293'),
('script_body', N'<!-- Body Tracker -->', '2026-10-20 21:57:59.343'),
('script_foot', N'<!-- Foot Tracker -->', '2026-10-20 21:57:59.39'),
('script_head', N'<!-- Google Analytics Tag -->', '2026-10-20 21:57:59.353'),
('site_favicon', N'/assets/images/favicon.ico', '2026-10-20 21:57:59.417'),
('site_title', N'CineStar Luxury Cinema', '2026-10-20 21:57:59.403');
GO

-- Insert Data for [Languages] (2 rows)
INSERT INTO [Languages] ([lang_code], [country_name], [flag_url], [is_active], [is_default], [created_at]) VALUES
('en', N'United States', N'/assets/images/flags/us.svg', 1, 0, '2026-10-20 21:39:20.123'),
('vi', N'Việt Nam', N'/assets/images/flags/vn.svg', 1, 1, '2026-10-20 21:39:20.123');
GO

-- Insert Data for [MovieTranslations] (12 rows)
SET IDENTITY_INSERT [MovieTranslations] ON;
INSERT INTO [MovieTranslations] ([translation_id], [movie_id], [lang_code], [title], [genre], [description], [director], [cast], [updated_at]) VALUES
(1, 1, 'vi', N'Dune: Hành Tinh Cát - Phần Hai', N'Khoa Học Viễn Tưởng, Phiêu Lưu', N'Hành trình huyền thoại của Paul Atreides khi anh đoàn tụ cùng Chani và người Fremen.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya', '2026-10-20 21:59:04.303'),
(2, 1, 'en', N'Dune: Part Two', N'Sci-Fi, Adventure', N'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya', '2026-10-20 21:59:04.313'),
(3, 2, 'vi', N'Dune: Hành Tinh Cát 2', N'Khoa Học Viễn Tưởng, Phiêu Lưu', N'Hành trình của Paul Atreides khi anh hợp nhất với Chani và người Fremen để trả thù những kẻ đã hủy hoại gia đình mình.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson', '2026-10-20 21:39:20.16'),
(4, 2, 'en', N'Dune: Part Two', N'Sci-Fi, Adventure', N'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson', '2026-10-20 21:39:20.16'),
(5, 3, 'vi', N'Godzilla x Kong: Đế Chế Mới', N'Hành Động, Viễn Tưởng', N'Hai thực thể hùng mạnh Godzilla và Kong phải hợp sức chống lại mối hiểm họa khổng lồ tiềm ẩn sâu trong lòng Trái Đất.', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens', '2026-10-20 21:39:20.16'),
(6, 3, 'en', N'Godzilla x Kong: The New Empire', N'Action, Sci-Fi', N'Two ancient titans, Godzilla and Kong, clash in an epic battle as humans unravel their intertwined origins and connection to Skull Island''s mysteries.', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens', '2026-10-20 21:39:20.16'),
(7, 4, 'vi', N'Kung Fu Panda 4', N'Hoạt Hình, Hài Hước', N'Po chuẩn bị trở thành Thủ lĩnh Tinh thần của Thung lũng Bình Yên nhưng phải đối đầu với phù thủy Tắc Kè Hoa có khả năng biến hình nguy hiểm.', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis', '2026-10-20 21:39:20.16'),
(8, 4, 'en', N'Kung Fu Panda 4', N'Animation, Comedy', N'Po must train a new Dragon Warrior while facing a wicked chameleon sorceress who can shapeshift into any creature.', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis', '2026-10-20 21:39:20.163'),
(9, 5, 'vi', N'Lật Mặt 7: Một Điều Ước', N'Gia Đình, Tâm Lý', N'Câu chuyện cảm động về gia đình bà Hai và 5 người con, phản ánh tình mẫu tử thiêng liêng và thực trạng đạo hiếu trong xã hội hiện đại.', N'Lý Hải', N'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung', '2026-10-20 21:39:20.163'),
(10, 5, 'en', N'Face Off 7: One Wish', N'Family, Drama', N'A touching story about Mrs. Hai and her five children, reflecting sacred maternal love and filial piety in modern society.', N'Ly Hai', N'Thanh Hien, Truong Minh Cuong, Dinh Y Nhung', '2026-10-20 21:39:20.163'),
(11, 6, 'vi', N'Deadpool & Wolverine', N'Hành Động, Siêu Anh Hùng', N'Deadpool và Wolverine bất đắc dĩ hợp tác để bảo vệ dòng thời gian và vũ trụ khỏi sự sụp đổ.', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin', '2026-10-20 21:39:20.163'),
(12, 6, 'en', N'Deadpool & Wolverine', N'Action, Superhero', N'Deadpool and Wolverine reluctantly team up to protect the timeline and the multiverse from collapse.', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin', '2026-10-20 21:39:20.163');
SET IDENTITY_INSERT [MovieTranslations] OFF;
GO

