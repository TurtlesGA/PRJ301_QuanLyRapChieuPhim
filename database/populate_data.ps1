# ================================================================
# Populate Mock Data: Movies, Users, Seats, and 3-Week Showtimes
# ================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connStr = "Server=localhost,1433;Database=CinemaDB;User Id=sa;Password=123;TrustServerCertificate=True;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()

function Execute-Sql($sql) {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    $cmd.ExecuteNonQuery() | Out-Null
}

function Execute-Scalar($sql) {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    return $cmd.ExecuteScalar()
}

Write-Host "1. Updating existing movies to fix UTF-8 encoding..." -ForegroundColor Cyan
Execute-Sql @"
UPDATE Movies SET 
    title = N'Godzilla x Kong: Đế Chế Mới',
    genre = N'Hành Động, Viễn Tưởng',
    director = N'Adam Wingard',
    cast = N'Rebecca Hall, Brian Tyree Henry, Dan Stevens',
    description = N'Hai thực thể hùng mạnh Godzilla và Kong phải hợp sức chống lại mối hiểm họa khổng lồ tiềm ẩn sâu trong lòng Trái Đất.',
    status = 'NOW_SHOWING'
WHERE movie_id = 3;

UPDATE Movies SET 
    title = N'Lật Mặt 7: Một Điều Ước',
    genre = N'Gia Đình, Tâm Lý',
    director = N'Lý Hải',
    cast = N'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung, Quách Ngọc Tuyên',
    description = N'Câu chuyện cảm động về gia đình bà Hai và 5 người con, phản ánh tình mẫu tử thiêng liêng và thực trạng đạo hiếu trong xã hội hiện đại.',
    status = 'NOW_SHOWING'
WHERE movie_id = 5;

UPDATE Movies SET 
    title = N'Deadpool & Wolverine',
    genre = N'Hành Động, Siêu Anh Hùng, Hài Hước',
    director = N'Shawn Levy',
    cast = N'Ryan Reynolds, Hugh Jackman, Emma Corrin, Matthew Macfadyen',
    description = N'Deadpool và Wolverine bất đắc dĩ hợp tác cùng Cơ quan Quản lý Phương sai Thời gian (TVA) để bảo vệ vũ trụ.',
    status = 'NOW_SHOWING'
WHERE movie_id = 6;
"@

Write-Host "2. Inserting new blockbuster movies (Part 1)..." -ForegroundColor Cyan
Execute-Sql @"
IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Quật Mộ Trùng Ma%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Exhuma: Quật Mộ Trùng Ma',
        N'Kinh Dị, Bí Ẩn',
        134,
        '2026-03-15',
        '2026-12-30',
        N'Jang Jae-hyun',
        N'Choi Min-sik, Kim Go-eun, Lee Do-hyun, Yoo Hae-jin',
        N'Quá trình khai quật một ngôi mộ bí ẩn đem lại hậu quả kinh hoàng khi giải phóng thế lực hắc ám cổ xưa.',
        'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500',
        'https://www.youtube.com/watch?v=73_1biulkYk',
        'T18',
        'NOW_SHOWING'
    );
END

IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Kẻ Trộm Mặt Trăng 4%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Kẻ Trộm Mặt Trăng 4 (Despicable Me 4)',
        N'Hoạt Hình, Hài Hước, Gia Đình',
        95,
        '2026-07-05',
        '2026-12-30',
        N'Chris Renaud',
        N'Steve Carell, Kristen Wiig, Will Ferrell, Sofia Vergara',
        N'Gru và gia đình bước vào cuộc sống mới cùng thành viên nhí Gru Jr., nhưng sớm đối mặt với kẻ thù mới nguy hiểm.',
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500',
        'https://www.youtube.com/watch?v=qQlr9-rF32A',
        'P',
        'NOW_SHOWING'
    );
END

IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Furiosa%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Furiosa: Câu Chuyện Từ Max Điên',
        N'Hành Động, Viễn Tưởng, Phiêu Lưu',
        148,
        '2026-05-24',
        '2026-12-30',
        N'George Miller',
        N'Anya Taylor-Joy, Chris Hemsworth, Tom Burke',
        N'Khi thế giới sụp đổ, Furiosa trẻ tuổi bị bắt cóc khỏi Nơi Xanh và rơi vào tay Băng Đảng Xe Máy Lãnh chúa Dementus.',
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500',
        'https://www.youtube.com/watch?v=XJMuhwVlca4',
        'T18',
        'NOW_SHOWING'
    );
END

IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Hành Tinh Khỉ%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Hành Tinh Khỉ: Vương Quốc Mới',
        N'Khoa Học Viễn Tưởng, Hành Động',
        145,
        '2026-05-10',
        '2026-12-30',
        N'Wes Ball',
        N'Owen Teague, Freya Allan, Kevin Durand, Peter Macon',
        N'Nhiều thế hệ sau thời kỳ của Caesar, loài khỉ trở thành giống loài thống trị hài hòa cùng thiên nhiên.',
        'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=500',
        'https://www.youtube.com/watch?v=XtFI7SNtVpY',
        'T13',
        'NOW_SHOWING'
    );
END
"@


Write-Host "2. Inserting new blockbuster movies (Part 2)..." -ForegroundColor Cyan
Execute-Sql @"
IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Vây Hãm: Kẻ Trừng Phạt%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Vây Hãm: Kẻ Trừng Phạt (The Roundup 4)',
        N'Hành Động, Tội Phạm, Hài Hước',
        109,
        '2026-04-26',
        '2026-12-30',
        N'Heo Myeong-haeng',
        N'Ma Dong-seok, Kim Mu-yeol, Park Ji-hwan, Lee Dong-hwi',
        N'Thanh tra Ma Seok-do tham gia đội điều tra không gian mạng để triệt phá tổ chức cờ bạc trực tuyến quy mô quốc tế.',
        'https://images.unsplash.com/photo-1563089145-599997674d42?w=500',
        'https://www.youtube.com/watch?v=s1X9e_m394g',
        'T18',
        'NOW_SHOWING'
    );
END

IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Transformers%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Transformers: Một (Transformers One)',
        N'Hoạt Hình, Hành Động, Viễn Tưởng',
        104,
        '2026-12-15',
        '2027-02-28',
        N'Josh Cooley',
        N'Chris Hemsworth, Brian Tyree Henry, Scarlett Johansson',
        N'Câu chuyện khởi nguồn chưa từng kể về mối quan hệ huynh đệ giữa Optimus Prime và Megatron.',
        'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500',
        'https://www.youtube.com/watch?v=u2NuUVbfzmA',
        'P',
        'COMING_SOON'
    );
END

IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Moana 2%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Moana 2: Hành Trình Mới',
        N'Hoạt Hình, Âm Nhạc, Phiêu Lưu',
        100,
        '2026-11-27',
        '2027-02-15',
        N'David G. Derrick Jr.',
        N'Auli''i Cravalho, Dwayne Johnson, Alan Tudyk',
        N'Sau khi nhận được lời kêu gọi bất ngờ từ tổ tiên, Moana cùng Maui và thủy thủ đoàn mới bắt đầu cuộc thám hiểm.',
        'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500',
        'https://www.youtube.com/watch?v=hDZ7y8RP5HE',
        'P',
        'COMING_SOON'
    );
END

IF NOT EXISTS (SELECT 1 FROM Movies WHERE title LIKE N'%Joker: Điên Có Đôi%')
BEGIN
    INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status)
    VALUES (
        N'Joker: Điên Có Đôi (Folie à Deux)',
        N'Tâm Lý, Tội Phạm, Ca Nhạc',
        138,
        '2026-12-04',
        '2027-02-20',
        N'Todd Phillips',
        N'Joaquin Phoenix, Lady Gaga, Brendan Gleeson',
        N'Arthur Fleck bị giam giữ tại Arkham chờ ngày xét xử. Tại đây, anh gặp gỡ tình yêu định mệnh Harley Quinn.',
        'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500',
        'https://www.youtube.com/watch?v=_OKAwz2NiJs',
        'T18',
        'COMING_SOON'
    );
END
"@

Write-Host "3. Generating Seats for Room 3 (IMAX: 6 rows A-F x 10 cols = 60 seats)..." -ForegroundColor Cyan
Execute-Sql @"
IF NOT EXISTS (SELECT 1 FROM Seats WHERE room_id = 3)
BEGIN
    DECLARE @r INT, @c INT;
    DECLARE @rows TABLE (idx INT, label CHAR(1));
    INSERT INTO @rows VALUES (1, 'A'), (2, 'B'), (3, 'C'), (4, 'D'), (5, 'E'), (6, 'F');

    DECLARE @row_label CHAR(1);
    DECLARE @seat_type VARCHAR(20);
    DECLARE @price_mod DECIMAL(10,2);

    DECLARE cur CURSOR FOR SELECT label, idx FROM @rows ORDER BY idx;
    OPEN cur;
    FETCH NEXT FROM cur INTO @row_label, @r;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @c = 1;
        WHILE @c <= 10
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

            INSERT INTO Seats (room_id, seat_row, seat_number, seat_type, price_modifier)
            VALUES (3, @row_label, @c, @seat_type, @price_mod);

            SET @c = @c + 1;
        END
        FETCH NEXT FROM cur INTO @row_label, @r;
    END
    CLOSE cur;
    DEALLOCATE cur;
END
"@


Write-Host "4. Inserting mock virtual users..." -ForegroundColor Cyan
Execute-Sql @"
DECLARE @users TABLE (
    username VARCHAR(50),
    password VARCHAR(255),
    full_name NVARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    role VARCHAR(20)
);

INSERT INTO @users VALUES
('hoangnam', '123456', N'Hoàng Nam', 'hoangnam@gmail.com', '0912345671', 'CUSTOMER'),
('linhchi', '123456', N'Đỗ Linh Chi', 'linhchi@gmail.com', '0912345672', 'CUSTOMER'),
('minhtuan', '123456', N'Lê Minh Tuấn', 'minhtuan@gmail.com', '0912345673', 'CUSTOMER'),
('phuonganh', '123456', N'Vũ Phương Anh', 'phuonganh@gmail.com', '0912345674', 'CUSTOMER'),
('ducthang', '123456', N'Phạm Đức Thắng', 'ducthang@gmail.com', '0912345675', 'CUSTOMER'),
('khanhly', '123456', N'Nguyễn Khánh Ly', 'khanhly@gmail.com', '0912345676', 'CUSTOMER'),
('quanghuy', '123456', N'Bùi Quang Huy', 'quanghuy@gmail.com', '0912345677', 'CUSTOMER'),
('thuytien', '123456', N'Phan Thủy Tiên', 'thuytien@gmail.com', '0912345678', 'CUSTOMER'),
('staff2', '123456', N'Đặng Thu Hà', 'thuha@cinema.vn', '0909988771', 'STAFF'),
('baolong', '123456', N'Trương Bảo Long', 'baolong@gmail.com', '0988776655', 'CUSTOMER');

INSERT INTO Users (username, password, full_name, email, phone, role, status)
SELECT u.username, u.password, u.full_name, u.email, u.phone, u.role, 1
FROM @users u
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE Users.username = u.username OR Users.email = u.email);
"@


Write-Host "5. Generating Showtimes for the next 3 weeks (21 days) across all NOW_SHOWING movies and rooms..." -ForegroundColor Cyan
Execute-Sql @"
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
"@


$totalUsers = Execute-Scalar "SELECT COUNT(*) FROM Users"
$totalMovies = Execute-Scalar "SELECT COUNT(*) FROM Movies"
$nowShowing = Execute-Scalar "SELECT COUNT(*) FROM Movies WHERE status = 'NOW_SHOWING'"
$comingSoon = Execute-Scalar "SELECT COUNT(*) FROM Movies WHERE status = 'COMING_SOON'"
$totalRooms = Execute-Scalar "SELECT COUNT(*) FROM Rooms"
$totalSeats = Execute-Scalar "SELECT COUNT(*) FROM Seats"
$totalShowtimes = Execute-Scalar "SELECT COUNT(*) FROM Showtimes"
$openFutureShowtimes = Execute-Scalar "SELECT COUNT(*) FROM Showtimes WHERE status = 'OPEN' AND show_date >= CAST(GETDATE() AS DATE)"

$conn.Close()

Write-Host "`n=== THONG KE DU LIEU SAU KHI SINH MAU ===" -ForegroundColor Green
Write-Host "- Tong nguoi dung (Users): $totalUsers"
Write-Host "- Tong phim (Movies): $totalMovies (Dang chieu: $nowShowing | Sap chieu: $comingSoon)"
Write-Host "- Tong phong chieu (Rooms): $totalRooms"
Write-Host "- Tong ghe ngoi (Seats): $totalSeats (Room 1: 40, Room 2: 40, Room 3 IMAX: 60)"
Write-Host "- Tong suat chieu (Showtimes): $totalShowtimes"
Write-Host "- Suat chieu mo trong 3 tuan toi: $openFutureShowtimes"

