-- ================================================================
-- DATABASE: Cinema Management System (Hệ thống Quản lý Rạp chiếu phim)
-- Course: PRJ302 / PRJ301 - Java Web Application
-- Database Engine: Microsoft SQL Server
-- ================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CinemaDB')
BEGIN
    CREATE DATABASE CinemaDB;
END
GO

USE CinemaDB;
GO

-- Drop tables if exists to allow clean re-runs
IF OBJECT_ID('Tickets', 'U') IS NOT NULL DROP TABLE Tickets;
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
IF OBJECT_ID('Seats', 'U') IS NOT NULL DROP TABLE Seats;
IF OBJECT_ID('Showtimes', 'U') IS NOT NULL DROP TABLE Showtimes;
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
    role VARCHAR(20) DEFAULT 'CUSTOMER', -- 'ADMIN', 'STAFF', 'CUSTOMER'
    status BIT DEFAULT 1,                -- 1: Active, 0: Locked
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 2. Table: Movies
CREATE TABLE Movies (
    movie_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    genre NVARCHAR(100) NOT NULL,
    duration INT NOT NULL, -- minutes
    release_date DATE NOT NULL,
    end_date DATE,
    director NVARCHAR(100),
    cast NVARCHAR(255),
    description NVARCHAR(MAX),
    poster_url VARCHAR(500),
    trailer_url VARCHAR(500),
    age_rating VARCHAR(10) DEFAULT 'P', -- P, K, T13, T16, T18, C
    status VARCHAR(20) DEFAULT 'NOW_SHOWING' -- NOW_SHOWING, COMING_SOON, STOPPED
);
GO

-- 3. Table: Rooms (Phòng chiếu)
CREATE TABLE Rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_name NVARCHAR(50) NOT NULL,
    room_type VARCHAR(20) DEFAULT '2D', -- 2D, 3D, IMAX, 4DX
    total_rows INT NOT NULL DEFAULT 8,  -- Row A -> H
    total_cols INT NOT NULL DEFAULT 10, -- 10 seats per row
    status BIT DEFAULT 1
);
GO

-- 4. Table: Seats (Ghế ngồi)
CREATE TABLE Seats (
    seat_id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT FOREIGN KEY REFERENCES Rooms(room_id) ON DELETE CASCADE,
    seat_row CHAR(1) NOT NULL,          -- 'A', 'B', 'C', ...
    seat_number INT NOT NULL,           -- 1, 2, 3, ...
    seat_type VARCHAR(20) DEFAULT 'STANDARD', -- STANDARD, VIP, COUPLE
    price_modifier DECIMAL(10,2) DEFAULT 0.00 -- Phụ thu: STANDARD=0, VIP=15000, COUPLE=30000
);
GO

-- 5. Table: Showtimes (Suất chiếu)
CREATE TABLE Showtimes (
    showtime_id INT IDENTITY(1,1) PRIMARY KEY,
    movie_id INT FOREIGN KEY REFERENCES Movies(movie_id) ON DELETE CASCADE,
    room_id INT FOREIGN KEY REFERENCES Rooms(room_id) ON DELETE CASCADE,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    base_price DECIMAL(10,2) NOT NULL DEFAULT 80000, -- Giá vé gốc (VND)
    status VARCHAR(20) DEFAULT 'OPEN' -- OPEN, CANCELLED, COMPLETED
);
GO

-- 6. Table: Bookings (Đơn đặt vé)
CREATE TABLE Bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    showtime_id INT FOREIGN KEY REFERENCES Showtimes(showtime_id),
    booking_code VARCHAR(20) UNIQUE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PAID', -- PAID, PENDING, CANCELLED
    payment_method NVARCHAR(50) DEFAULT 'VNPAY', -- VNPAY, MOMO, CASH
    booking_time DATETIME DEFAULT GETDATE()
);
GO

-- 7. Table: Tickets (Chi tiết từng ghế trong đơn vé)
CREATE TABLE Tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT FOREIGN KEY REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    seat_id INT FOREIGN KEY REFERENCES Seats(seat_id),
    price DECIMAL(10,2) NOT NULL
);
GO

-- ================================================================
-- INSERT SAMPLE DATA (DỮ LIỆU MẪU)
-- ================================================================

-- 1. Insert Users (Password: 123456)
INSERT INTO Users (username, password, full_name, email, phone, role, status) VALUES
('admin', '123456', N'Quản Trị Viên', 'admin@cinema.vn', '0901234567', 'ADMIN', 1),
('staff', '123456', N'Nhân Viên Rạp', 'staff@cinema.vn', '0902345678', 'STAFF', 1),
('customer', '123456', N'Nguyễn Văn A', 'customer@gmail.com', '0903456789', 'CUSTOMER', 1),
('user2', '123456', N'Trần Thị B', 'user2@gmail.com', '0904567890', 'CUSTOMER', 1);
GO

-- 2. Insert Movies
INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status) VALUES
(N'Mai', N'Tâm Lý, Tình Cảm', 131, '2026-02-10', '2026-12-30', N'Trấn Thành', N'Phương Anh Đào, Tuấn Trần, Trấn Thành, Hồng Đào', 
 N'Mai xoay quanh cuộc đời của người phụ nữ cùng tên. Số phận đưa đẩy cô gặp gỡ Dương - chàng trai trẻ tuổi, đào hoa, mở ra mối tình vừa ngọt ngào vừa đầy thử thách.',
 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500', 'https://www.youtube.com/watch?v=HKb0z8kYw3c', 'T18', 'NOW_SHOWING'),

(N'Dune: Hành Tinh Cát 2', N'Khoa Học Viễn Tưởng, Phiêu Lưu', 166, '2026-03-01', '2026-12-30', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson', 
 N'Hành trình của Paul Atreides khi anh hợp nhất với Chani và người Fremen để trả thù những kẻ đã hủy hoại gia đình mình.',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500', 'https://www.youtube.com/watch?v=Way9Dexny3w', 'T16', 'NOW_SHOWING'),

(N'Godzilla x Kong: Đế Chế Mới', N'Hành Động, Viễn Tưởng', 115, '2026-03-29', '2026-12-30', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens', 
 N'Hai thực thể hùng mạnh Godzilla và Kong phải hợp sức chống lại mối hiểm họa khổng lồ tiềm ẩn sâu trong lòng Trái Đất.',
 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=500', 'https://www.youtube.com/watch?v=qqrpMRDuPfc', 'T13', 'NOW_SHOWING'),

(N'Kung Fu Panda 4', N'Hoạt Hình, Hài Hước', 94, '2026-03-08', '2026-12-30', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis', 
 N'Po chuẩn bị trở thành Thủ lĩnh Tinh thần của Thung lũng Bình Yên nhưng phải đối đầu với phù thủy Tắc Kè Hoa có khả năng biến hình nguy hiểm.',
 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500', 'https://www.youtube.com/watch?v=_inKs4eeHiI', 'P', 'NOW_SHOWING'),

(N'Lật Mặt 7: Một Điều Ước', N'Gia Đình, Tâm Lý', 138, '2026-04-26', '2026-12-30', N'Lý Hải', N'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung', 
 N'Câu chuyện cảm động về gia đình bà Hai và 5 người con, phản ánh tình mẫu tử thiêng liêng và thực trạng đạo hiếu trong xã hội hiện đại.',
 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500', 'https://www.youtube.com/watch?v=d9MyW72ELq0', 'K', 'COMING_SOON'),

(N'Deadpool & Wolverine', N'Hành Động, Siêu Anh Hùng', 127, '2026-07-26', '2026-12-30', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin', 
 N'Deadpool và Wolverine bất đắc dĩ hợp tác để bảo vệ dòng thời gian và vũ trụ khỏi sự sụp đổ.',
 'https://images.unsplash.com/photo-1563089145-599997674d42?w=500', 'https://www.youtube.com/watch?v=73_1biulkYk', 'T18', 'COMING_SOON');
GO

-- 3. Insert Rooms
INSERT INTO Rooms (room_name, room_type, total_rows, total_cols, status) VALUES
(N'Phòng Cinema 01 (2D)', '2D', 5, 8, 1),
(N'Phòng Cinema 02 (3D)', '3D', 5, 8, 1),
(N'Phòng Cinema 03 (IMAX)', 'IMAX', 6, 10, 1);
GO

-- 4. Generate Seats for Room 1 (5 rows: A-E, 8 cols: 1-8)
-- A, B: STANDARD | C, D: VIP | E: COUPLE
DECLARE @r INT, @c INT;
DECLARE @rows TABLE (idx INT, label CHAR(1));
INSERT INTO @rows VALUES (1, 'A'), (2, 'B'), (3, 'C'), (4, 'D'), (5, 'E');

DECLARE @row_label CHAR(1);
DECLARE @seat_type VARCHAR(20);
DECLARE @price_mod DECIMAL(10,2);

DECLARE cur CURSOR FOR SELECT label, idx FROM @rows ORDER BY idx;
OPEN cur;
FETCH NEXT FROM cur INTO @row_label, @r;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @c = 1;
    WHILE @c <= 8
    BEGIN
        IF @r <= 2
        BEGIN
            SET @seat_type = 'STANDARD';
            SET @price_mod = 0.00;
        END
        ELSE IF @r <= 4
        BEGIN
            SET @seat_type = 'VIP';
            SET @price_mod = 15000.00;
        END
        ELSE
        BEGIN
            SET @seat_type = 'COUPLE';
            SET @price_mod = 30000.00;
        END

        -- Insert into Room 1
        INSERT INTO Seats (room_id, seat_row, seat_number, seat_type, price_modifier)
        VALUES (1, @row_label, @c, @seat_type, @price_mod);

        -- Insert into Room 2
        INSERT INTO Seats (room_id, seat_row, seat_number, seat_type, price_modifier)
        VALUES (2, @row_label, @c, @seat_type, @price_mod);

        SET @c = @c + 1;
    END
    FETCH NEXT FROM cur INTO @row_label, @r;
END
CLOSE cur;
DEALLOCATE cur;
GO

-- 5. Insert Showtimes (Suất chiếu hôm nay & các ngày tới)
INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status) VALUES
(1, 1, CAST(GETDATE() AS DATE), '09:00:00', '11:15:00', 80000, 'OPEN'),
(1, 1, CAST(GETDATE() AS DATE), '14:00:00', '16:15:00', 90000, 'OPEN'),
(1, 1, CAST(GETDATE() AS DATE), '19:30:00', '21:45:00', 100000, 'OPEN'),
(2, 2, CAST(GETDATE() AS DATE), '10:00:00', '12:45:00', 95000, 'OPEN'),
(2, 2, CAST(GETDATE() AS DATE), '18:00:00', '20:45:00', 110000, 'OPEN'),
(3, 1, CAST(DATEADD(day, 1, GETDATE()) AS DATE), '13:00:00', '15:00:00', 85000, 'OPEN'),
(4, 2, CAST(DATEADD(day, 1, GETDATE()) AS DATE), '16:00:00', '17:35:00', 80000, 'OPEN');
GO

-- 6. Insert Sample Bookings and Tickets
INSERT INTO Bookings (user_id, showtime_id, booking_code, total_amount, payment_status, payment_method, booking_time) VALUES
(3, 1, 'BK2026101201', 190000, 'PAID', 'VNPAY', GETDATE());

-- Insert tickets for Booking 1 (Ghế C3 and C4 - VIP)
INSERT INTO Tickets (booking_id, seat_id, price) VALUES
(1, (SELECT seat_id FROM Seats WHERE room_id = 1 AND seat_row = 'C' AND seat_number = 3), 95000),
(1, (SELECT seat_id FROM Seats WHERE room_id = 1 AND seat_row = 'C' AND seat_number = 4), 95000);
GO

-- Cập nhật đồng bộ Tiếng Việt có dấu chính xác (fix lỗi font nếu chạy trên môi trường cũ)
UPDATE Users SET full_name = N'Quản Trị Viên' WHERE username = 'admin';
UPDATE Users SET full_name = N'Nhân Viên Rạp' WHERE username = 'staff';
UPDATE Users SET full_name = N'Nguyễn Văn A' WHERE username = 'customer';
UPDATE Users SET full_name = N'Trần Thị B' WHERE username = 'user2';
GO

