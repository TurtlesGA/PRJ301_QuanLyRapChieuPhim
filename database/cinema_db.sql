-- ================================================================
-- DATABASE: Cinema Management System (Hệ thống Quản lý Rạp chiếu phim)
-- Course: PRJ301 - Java Web Application
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
IF OBJECT_ID('MovieTranslations', 'U') IS NOT NULL DROP TABLE MovieTranslations;
IF OBJECT_ID('Tickets', 'U') IS NOT NULL DROP TABLE Tickets;
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
IF OBJECT_ID('Seats', 'U') IS NOT NULL DROP TABLE Seats;
IF OBJECT_ID('Showtimes', 'U') IS NOT NULL DROP TABLE Showtimes;
IF OBJECT_ID('Rooms', 'U') IS NOT NULL DROP TABLE Rooms;
IF OBJECT_ID('Movies', 'U') IS NOT NULL DROP TABLE Movies;
IF OBJECT_ID('Languages', 'U') IS NOT NULL DROP TABLE Languages;
IF OBJECT_ID('SystemSettings', 'U') IS NOT NULL DROP TABLE SystemSettings;
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
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
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
('user2', '123456', N'Trần Thị B', 'user2@gmail.com', '0904567890', 'CUSTOMER', 1),
('hoangnam', '123456', N'Hoàng Nam', 'hoangnam@gmail.com', '0912345671', 'CUSTOMER', 1),
('linhchi', '123456', N'Đỗ Linh Chi', 'linhchi@gmail.com', '0912345672', 'CUSTOMER', 1),
('minhtuan', '123456', N'Lê Minh Tuấn', 'minhtuan@gmail.com', '0912345673', 'CUSTOMER', 1),
('phuonganh', '123456', N'Vũ Phương Anh', 'phuonganh@gmail.com', '0912345674', 'CUSTOMER', 1),
('ducthang', '123456', N'Phạm Đức Thắng', 'ducthang@gmail.com', '0912345675', 'CUSTOMER', 1),
('khanhly', '123456', N'Nguyễn Khánh Ly', 'khanhly@gmail.com', '0912345676', 'CUSTOMER', 1),
('quanghuy', '123456', N'Bùi Quang Huy', 'quanghuy@gmail.com', '0912345677', 'CUSTOMER', 1),
('thuytien', '123456', N'Phan Thủy Tiên', 'thuytien@gmail.com', '0912345678', 'CUSTOMER', 1),
('staff2', '123456', N'Đặng Thu Hà', 'thuha@cinema.vn', '0909988771', 'STAFF', 1),
('baolong', '123456', N'Trương Bảo Long', 'baolong@gmail.com', '0988776655', 'CUSTOMER', 1);
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
 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500', 'https://www.youtube.com/watch?v=d9MyW72ELq0', 'K', 'NOW_SHOWING'),

(N'Deadpool & Wolverine', N'Hành Động, Siêu Anh Hùng, Hài Hước', 127, '2026-07-26', '2026-12-30', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin', 
 N'Deadpool và Wolverine bất đắc dĩ hợp tác cùng Cơ quan Quản lý Phương sai Thời gian (TVA) để bảo vệ dòng thời gian và vũ trụ khỏi sự sụp đổ.',
 'https://images.unsplash.com/photo-1563089145-599997674d42?w=500', 'https://www.youtube.com/watch?v=73_1biulkYk', 'T18', 'NOW_SHOWING'),

(N'Exhuma: Quật Mộ Trùng Ma', N'Kinh Dị, Bí Ẩn', 134, '2026-03-15', '2026-12-30', N'Jang Jae-hyun', N'Choi Min-sik, Kim Go-eun, Lee Do-hyun, Yoo Hae-jin', 
 N'Quá trình khai quật một ngôi mộ bí ẩn đem lại hậu quả kinh hoàng khi giải phóng thế lực hắc ám cổ xưa.',
 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500', 'https://www.youtube.com/watch?v=73_1biulkYk', 'T18', 'NOW_SHOWING'),

(N'Kẻ Trộm Mặt Trăng 4 (Despicable Me 4)', N'Hoạt Hình, Hài Hước, Gia Đình', 95, '2026-07-05', '2026-12-30', N'Chris Renaud', N'Steve Carell, Kristen Wiig, Will Ferrell, Sofia Vergara', 
 N'Gru và gia đình bước vào cuộc sống mới cùng thành viên nhí Gru Jr., nhưng sớm đối mặt với kẻ thù mới nguy hiểm Maxime Le Mal.',
 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500', 'https://www.youtube.com/watch?v=qQlr9-rF32A', 'P', 'NOW_SHOWING'),

(N'Furiosa: Câu Chuyện Từ Max Điên', N'Hành Động, Viễn Tưởng, Phiêu Lưu', 148, '2026-05-24', '2026-12-30', N'George Miller', N'Anya Taylor-Joy, Chris Hemsworth, Tom Burke', 
 N'Khi thế giới sụp đổ, Furiosa trẻ tuổi bị bắt cóc khỏi Nơi Xanh và rơi vào tay Băng Đảng Xe Máy do Lãnh chúa Dementus chỉ huy.',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500', 'https://www.youtube.com/watch?v=XJMuhwVlca4', 'T18', 'NOW_SHOWING'),

(N'Hành Tinh Khỉ: Vương Quốc Mới', N'Khoa Học Viễn Tưởng, Hành Động', 145, '2026-05-10', '2026-12-30', N'Wes Ball', N'Owen Teague, Freya Allan, Kevin Durand, Peter Macon', 
 N'Nhiều thế hệ sau thời kỳ của Caesar, loài khỉ trở thành giống loài thống trị hài hòa cùng thiên nhiên trong khi con người bị đẩy vào thế giới hoang dã.',
 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=500', 'https://www.youtube.com/watch?v=XtFI7SNtVpY', 'T13', 'NOW_SHOWING'),

(N'Vây Hãm: Kẻ Trừng Phạt (The Roundup 4)', N'Hành Động, Tội Phạm, Hài Hước', 109, '2026-04-26', '2026-12-30', N'Heo Myeong-haeng', N'Ma Dong-seok, Kim Mu-yeol, Park Ji-hwan, Lee Dong-hwi', 
 N'Thanh tra Ma Seok-do tham gia đội điều tra không gian mạng để triệt phá tổ chức cờ bạc trực tuyến xuyên quốc gia phi pháp.',
 'https://images.unsplash.com/photo-1563089145-599997674d42?w=500', 'https://www.youtube.com/watch?v=s1X9e_m394g', 'T18', 'NOW_SHOWING'),

(N'Transformers: Một (Transformers One)', N'Hoạt Hình, Hành Động, Viễn Tưởng', 104, '2026-12-15', '2027-02-28', N'Josh Cooley', N'Chris Hemsworth, Brian Tyree Henry, Scarlett Johansson', 
 N'Câu chuyện khởi nguồn chưa từng kể về mối quan hệ huynh đệ giữa Optimus Prime và Megatron trước khi trở thành kẻ thù truyền kiếp.',
 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500', 'https://www.youtube.com/watch?v=u2NuUVbfzmA', 'P', 'COMING_SOON'),

(N'Moana 2: Hành Trình Mới', N'Hoạt Hình, Âm Nhạc, Phiêu Lưu', 100, '2026-11-27', '2027-02-15', N'David G. Derrick Jr.', N'Auli''i Cravalho, Dwayne Johnson, Alan Tudyk', 
 N'Sau khi nhận được lời kêu gọi bất ngờ từ tổ tiên, Moana cùng Maui và thủy thủ đoàn mới bắt đầu cuộc thám hiểm vượt xa vùng biển quen thuộc.',
 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500', 'https://www.youtube.com/watch?v=hDZ7y8RP5HE', 'P', 'COMING_SOON'),

(N'Joker: Điên Có Đôi (Folie à Deux)', N'Tâm Lý, Tội Phạm, Ca Nhạc', 138, '2026-12-04', '2027-02-20', N'Todd Phillips', N'Joaquin Phoenix, Lady Gaga, Brendan Gleeson', 
 N'Arthur Fleck bị giam giữ tại Arkham chờ ngày xét xử. Tại đây, anh gặp gỡ tình yêu định mệnh Harley Quinn và tìm thấy bản hòa âm bên trong tâm hồn.',
 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500', 'https://www.youtube.com/watch?v=_OKAwz2NiJs', 'T18', 'COMING_SOON');
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

-- 4b. Generate Seats for Room 3 (IMAX: 6 rows A-F, 10 cols: 1-10)
DECLARE @r3 INT, @c3 INT;
DECLARE @rows3 TABLE (idx INT, label CHAR(1));
INSERT INTO @rows3 VALUES (1, 'A'), (2, 'B'), (3, 'C'), (4, 'D'), (5, 'E'), (6, 'F');

DECLARE @row_label3 CHAR(1);
DECLARE @seat_type3 VARCHAR(20);
DECLARE @price_mod3 DECIMAL(10,2);

DECLARE cur3 CURSOR FOR SELECT label, idx FROM @rows3 ORDER BY idx;
OPEN cur3;
FETCH NEXT FROM cur3 INTO @row_label3, @r3;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @c3 = 1;
    WHILE @c3 <= 10
    BEGIN
        IF @r3 <= 2
        BEGIN
            SET @seat_type3 = 'STANDARD';
            SET @price_mod3 = 0.00;
        END
        ELSE IF @r3 <= 4
        BEGIN
            SET @seat_type3 = 'VIP';
            SET @price_mod3 = 15000.00;
        END
        ELSE
        BEGIN
            SET @seat_type3 = 'COUPLE';
            SET @price_mod3 = 30000.00;
        END

        INSERT INTO Seats (room_id, seat_row, seat_number, seat_type, price_modifier)
        VALUES (3, @row_label3, @c3, @seat_type3, @price_mod3);

        SET @c3 = @c3 + 1;
    END
    FETCH NEXT FROM cur3 INTO @row_label3, @r3;
END
CLOSE cur3;
DEALLOCATE cur3;
GO

-- 5. Insert Showtimes (Tự động sinh lịch chiếu cho 3 tuần tới trên toàn bộ các phòng và phim đang chiếu)
DECLARE @now_movies TABLE (seq INT IDENTITY(1,1), movie_id INT);
INSERT INTO @now_movies (movie_id)
SELECT movie_id FROM Movies WHERE status = 'NOW_SHOWING' ORDER BY movie_id;

DECLARE @movieCount INT;
SELECT @movieCount = COUNT(*) FROM @now_movies;

DECLARE @d INT = 0;
WHILE @d <= 21
BEGIN
    DECLARE @show_date DATE = CAST(DATEADD(day, @d, GETDATE()) AS DATE);

    -- Room 1 (2D) - 4 showtimes/day
    DECLARE @m1_1 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 1 - 1) % @movieCount) + 1);
    DECLARE @m1_2 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 2 - 1) % @movieCount) + 1);
    DECLARE @m1_3 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 3 - 1) % @movieCount) + 1);
    DECLARE @m1_4 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 4 - 1) % @movieCount) + 1);

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 1 AND show_date = @show_date AND start_time = '09:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m1_1, 1, @show_date, '09:00:00', '11:15:00', 80000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 1 AND show_date = @show_date AND start_time = '13:30:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m1_2, 1, @show_date, '13:30:00', '15:45:00', 85000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 1 AND show_date = @show_date AND start_time = '18:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m1_3, 1, @show_date, '18:00:00', '20:15:00', 90000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 1 AND show_date = @show_date AND start_time = '20:45:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m1_4, 1, @show_date, '20:45:00', '23:00:00', 90000, 'OPEN');

    -- Room 2 (3D) - 4 showtimes/day
    DECLARE @m2_1 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 5 - 1) % @movieCount) + 1);
    DECLARE @m2_2 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 6 - 1) % @movieCount) + 1);
    DECLARE @m2_3 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 7 - 1) % @movieCount) + 1);
    DECLARE @m2_4 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 8 - 1) % @movieCount) + 1);

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 2 AND show_date = @show_date AND start_time = '10:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m2_1, 2, @show_date, '10:00:00', '12:30:00', 95000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 2 AND show_date = @show_date AND start_time = '14:30:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m2_2, 2, @show_date, '14:30:00', '17:00:00', 100000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 2 AND show_date = @show_date AND start_time = '19:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m2_3, 2, @show_date, '19:00:00', '21:30:00', 105000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 2 AND show_date = @show_date AND start_time = '22:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m2_4, 2, @show_date, '22:00:00', '00:15:00', 95000, 'OPEN');

    -- Room 3 (IMAX) - 4 showtimes/day
    DECLARE @m3_1 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 9 - 1) % @movieCount) + 1);
    DECLARE @m3_2 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 10 - 1) % @movieCount) + 1);
    DECLARE @m3_3 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 11 - 1) % @movieCount) + 1);
    DECLARE @m3_4 INT = (SELECT movie_id FROM @now_movies WHERE seq = ((@d * 3 + 12 - 1) % @movieCount) + 1);

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 3 AND show_date = @show_date AND start_time = '09:30:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m3_1, 3, @show_date, '09:30:00', '12:00:00', 115000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 3 AND show_date = @show_date AND start_time = '13:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m3_2, 3, @show_date, '13:00:00', '15:45:00', 120000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 3 AND show_date = @show_date AND start_time = '16:30:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m3_3, 3, @show_date, '16:30:00', '19:15:00', 125000, 'OPEN');

    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE room_id = 3 AND show_date = @show_date AND start_time = '20:00:00')
        INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status)
        VALUES (@m3_4, 3, @show_date, '20:00:00', '22:45:00', 130000, 'OPEN');

    SET @d = @d + 1;
END
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
UPDATE Users SET full_name = N'Vũ Quốc Hải' WHERE username = 'kingbone2006';
UPDATE Users SET full_name = N'Hoàng Nam' WHERE username = 'hoangnam';
UPDATE Users SET full_name = N'Đỗ Linh Chi' WHERE username = 'linhchi';
UPDATE Users SET full_name = N'Lê Minh Tuấn' WHERE username = 'minhtuan';
UPDATE Users SET full_name = N'Vũ Phương Anh' WHERE username = 'phuonganh';
UPDATE Users SET full_name = N'Phạm Đức Thắng' WHERE username = 'ducthang';
UPDATE Users SET full_name = N'Nguyễn Khánh Ly' WHERE username = 'khanhly';
UPDATE Users SET full_name = N'Bùi Quang Huy' WHERE username = 'quanghuy';
UPDATE Users SET full_name = N'Phan Thủy Tiên' WHERE username = 'thuytien';
UPDATE Users SET full_name = N'Đặng Thu Hà' WHERE username = 'staff2';
UPDATE Users SET full_name = N'Trương Bảo Long' WHERE username = 'baolong';
GO



-- ================================================================
-- 8. Table: SystemSettings (Cấu hình website & Scripts)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemSettings' AND xtype='U')
CREATE TABLE SystemSettings (
    setting_key VARCHAR(50) PRIMARY KEY,
    setting_value NVARCHAR(MAX),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- ================================================================
-- 9. Table: Languages (Quản lý đa ngôn ngữ website)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Languages' AND xtype='U')
CREATE TABLE Languages (
    lang_code VARCHAR(10) PRIMARY KEY,
    country_name NVARCHAR(100) NOT NULL,
    flag_url NVARCHAR(255) NOT NULL,
    is_active BIT DEFAULT 1,
    is_default BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- ================================================================
-- 10. Table: MovieTranslations (Đa ngôn ngữ động cho chi tiết phim)
-- ================================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='MovieTranslations' AND xtype='U')
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
-- 11. SEED DEFAULT DATA: Languages, SystemSettings, MovieTranslations
-- ================================================================

-- Seed Languages
IF NOT EXISTS (SELECT * FROM Languages WHERE lang_code='vi')
INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('vi', N'Việt Nam', '/assets/images/flags/vn.svg', 1, 1);
IF NOT EXISTS (SELECT * FROM Languages WHERE lang_code='en')
INSERT INTO Languages (lang_code, country_name, flag_url, is_active, is_default) VALUES ('en', N'United States', '/assets/images/flags/us.svg', 1, 0);
GO

-- Seed SystemSettings
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='site_title')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('site_title', N'CineStar - Đặt Vé Xem Phim Trực Tuyến');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='site_favicon')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('site_favicon', N'/assets/images/favicon.ico');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='header_brand_prefix')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('header_brand_prefix', N'CINE');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='header_brand_suffix')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('header_brand_suffix', N'STAR');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='footer_brand')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('footer_brand', N'CINESTAR CINEMA');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='footer_description')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('footer_description', N'Hệ thống rạp chiếu phim hiện đại chuẩn quốc tế. Mang đến trải nghiệm điện ảnh chân thực và sống động nhất cho khán giả.');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='footer_hotline')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('footer_hotline', N'1900 6017');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='footer_email')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('footer_email', N'support@cinestar.vn');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='footer_hours')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('footer_hours', N'8:00 - 22:00 Hàng ngày');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='footer_copyright')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('footer_copyright', N'© 2026 CineStar Cinema - PRJ301 Quản Lý Rạp Chiếu Phim. Thiết kế & phát triển bởi Nhóm Dự Án.');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='script_head')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('script_head', N'');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='script_body')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('script_body', N'');
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE setting_key='script_foot')
INSERT INTO SystemSettings (setting_key, setting_value) VALUES ('script_foot', N'');
GO

-- Seed MovieTranslations
IF EXISTS (SELECT * FROM Movies WHERE movie_id=1)
BEGIN
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=1 AND lang_code='vi')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (1, 'vi', N'Mai', N'Tâm Lý, Tình Cảm', N'Mai xoay quanh cuộc đời của người phụ nữ cùng tên. Số phận đưa đẩy cô gặp gỡ Dương - chàng trai trẻ tuổi, đào hoa, mở ra mối tình vừa ngọt ngào vừa đầy thử thách.', N'Trấn Thành', N'Phương Anh Đào, Tuấn Trần, Trấn Thành, Hồng Đào');
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=1 AND lang_code='en')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (1, 'en', N'Mai', N'Drama, Romance', N'Mai revolves around the life of a woman of the same name. Fate brings her together with Duong - a young, charming man, unfolding a romance that is both sweet and challenging.', N'Tran Thanh', N'Phuong Anh Dao, Tuan Tran, Tran Thanh, Hong Dao');
END
GO

IF EXISTS (SELECT * FROM Movies WHERE movie_id=2)
BEGIN
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=2 AND lang_code='vi')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (2, 'vi', N'Dune: Hành Tinh Cát 2', N'Khoa Học Viễn Tưởng, Phiêu Lưu', N'Hành trình của Paul Atreides khi anh hợp nhất với Chani và người Fremen để trả thù những kẻ đã hủy hoại gia đình mình.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson');
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=2 AND lang_code='en')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (2, 'en', N'Dune: Part Two', N'Sci-Fi, Adventure', N'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya, Rebecca Ferguson');
END
GO

IF EXISTS (SELECT * FROM Movies WHERE movie_id=3)
BEGIN
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=3 AND lang_code='vi')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (3, 'vi', N'Godzilla x Kong: Đế Chế Mới', N'Hành Động, Viễn Tưởng', N'Hai thực thể hùng mạnh Godzilla và Kong phải hợp sức chống lại mối hiểm họa khổng lồ tiềm ẩn sâu trong lòng Trái Đất.', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens');
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=3 AND lang_code='en')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (3, 'en', N'Godzilla x Kong: The New Empire', N'Action, Sci-Fi', N'Two ancient titans, Godzilla and Kong, clash in an epic battle as humans unravel their intertwined origins and connection to Skull Island''s mysteries.', N'Adam Wingard', N'Rebecca Hall, Brian Tyree Henry, Dan Stevens');
END
GO

IF EXISTS (SELECT * FROM Movies WHERE movie_id=4)
BEGIN
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=4 AND lang_code='vi')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (4, 'vi', N'Kung Fu Panda 4', N'Hoạt Hình, Hài Hước', N'Po chuẩn bị trở thành Thủ lĩnh Tinh thần của Thung lũng Bình Yên nhưng phải đối đầu với phù thủy Tắc Kè Hoa có khả năng biến hình nguy hiểm.', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis');
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=4 AND lang_code='en')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (4, 'en', N'Kung Fu Panda 4', N'Animation, Comedy', N'Po must train a new Dragon Warrior while facing a wicked chameleon sorceress who can shapeshift into any creature.', N'Mike Mitchell', N'Jack Black, Awkwafina, Viola Davis');
END
GO

IF EXISTS (SELECT * FROM Movies WHERE movie_id=5)
BEGIN
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=5 AND lang_code='vi')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (5, 'vi', N'Lật Mặt 7: Một Điều Ước', N'Gia Đình, Tâm Lý', N'Câu chuyện cảm động về gia đình bà Hai và 5 người con, phản ánh tình mẫu tử thiêng liêng và thực trạng đạo hiếu trong xã hội hiện đại.', N'Lý Hải', N'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung');
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=5 AND lang_code='en')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (5, 'en', N'Face Off 7: One Wish', N'Family, Drama', N'A touching story about Mrs. Hai and her five children, reflecting sacred maternal love and filial piety in modern society.', N'Ly Hai', N'Thanh Hien, Truong Minh Cuong, Dinh Y Nhung');
END
GO

IF EXISTS (SELECT * FROM Movies WHERE movie_id=6)
BEGIN
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=6 AND lang_code='vi')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (6, 'vi', N'Deadpool & Wolverine', N'Hành Động, Siêu Anh Hùng', N'Deadpool và Wolverine bất đắc dĩ hợp tác để bảo vệ dòng thời gian và vũ trụ khỏi sự sụp đổ.', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin');
    IF NOT EXISTS (SELECT * FROM MovieTranslations WHERE movie_id=6 AND lang_code='en')
        INSERT INTO MovieTranslations (movie_id, lang_code, title, genre, description, director, cast)
        VALUES (6, 'en', N'Deadpool & Wolverine', N'Action, Superhero', N'Deadpool and Wolverine reluctantly team up to protect the timeline and the multiverse from collapse.', N'Shawn Levy', N'Ryan Reynolds, Hugh Jackman, Emma Corrin');
END
GO
