-- ================================================================
-- DATABASE: Cinema Management System (MySQL Version)
-- Course: PRJ302 / PRJ301 - Java Web Application
-- ================================================================

CREATE DATABASE IF NOT EXISTS CinemaDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE CinemaDB;

DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Seats;
DROP TABLE IF EXISTS Showtimes;
DROP TABLE IF EXISTS Rooms;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    status TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    release_date DATE NOT NULL,
    end_date DATE,
    director VARCHAR(100),
    cast VARCHAR(255),
    description TEXT,
    poster_url VARCHAR(500),
    trailer_url VARCHAR(500),
    age_rating VARCHAR(10) DEFAULT 'P',
    status VARCHAR(20) DEFAULT 'NOW_SHOWING'
);

CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(50) NOT NULL,
    room_type VARCHAR(20) DEFAULT '2D',
    total_rows INT NOT NULL DEFAULT 5,
    total_cols INT NOT NULL DEFAULT 8,
    status TINYINT(1) DEFAULT 1
);

CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    seat_row CHAR(1) NOT NULL,
    seat_number INT NOT NULL,
    seat_type VARCHAR(20) DEFAULT 'STANDARD',
    price_modifier DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE CASCADE
);

CREATE TABLE Showtimes (
    showtime_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    room_id INT NOT NULL,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    base_price DECIMAL(10,2) NOT NULL DEFAULT 80000,
    status VARCHAR(20) DEFAULT 'OPEN',
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE CASCADE
);

CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    showtime_id INT NOT NULL,
    booking_code VARCHAR(20) UNIQUE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PAID',
    payment_method VARCHAR(50) DEFAULT 'VNPAY',
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (showtime_id) REFERENCES Showtimes(showtime_id)
);

CREATE TABLE Tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

-- Sample Data
INSERT INTO Users (username, password, full_name, email, phone, role, status) VALUES
('admin', '123456', 'Quản Trị Viên', 'admin@cinema.vn', '0901234567', 'ADMIN', 1),
('staff', '123456', 'Nhân Viên Rạp', 'staff@cinema.vn', '0902345678', 'STAFF', 1),
('customer', '123456', 'Nguyễn Văn A', 'customer@gmail.com', '0903456789', 'CUSTOMER', 1);

INSERT INTO Movies (title, genre, duration, release_date, end_date, director, cast, description, poster_url, trailer_url, age_rating, status) VALUES
('Mai', 'Tâm Lý, Tình Cảm', 131, '2026-02-10', '2026-12-30', 'Trấn Thành', 'Phương Anh Đào, Tuấn Trần', 'Câu chuyện tình yêu đầy thử thách giữa Mai và Dương.', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500', 'https://www.youtube.com/watch?v=HKb0z8kYw3c', 'T18', 'NOW_SHOWING'),
('Dune: Hành Tinh Cát 2', 'Khoa Học Viễn Tưởng', 166, '2026-03-01', '2026-12-30', 'Denis Villeneuve', 'Timothée Chalamet, Zendaya', 'Hành trình trả thù và bảo vệ tương lai của Paul Atreides.', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500', 'https://www.youtube.com/watch?v=Way9Dexny3w', 'T16', 'NOW_SHOWING'),
('Kung Fu Panda 4', 'Hoạt Hình, Hài Hước', 94, '2026-03-08', '2026-12-30', 'Mike Mitchell', 'Jack Black, Awkwafina', 'Po đối đầu phù thủy Tắc Kè Hoa nguy hiểm.', 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500', 'https://www.youtube.com/watch?v=_inKs4eeHiI', 'P', 'NOW_SHOWING'),
('Lật Mặt 7: Một Điều Ước', 'Gia Đình, Tâm Lý', 138, '2026-04-26', '2026-12-30', 'Lý Hải', 'Thanh Hiền, Trương Minh Cường', 'Tình mẫu tử thiêng liêng và bài học gia đình.', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500', 'https://www.youtube.com/watch?v=d9MyW72ELq0', 'K', 'COMING_SOON');

INSERT INTO Rooms (room_name, room_type, total_rows, total_cols, status) VALUES
('Phòng Cinema 01 (2D)', '2D', 5, 8, 1),
('Phòng Cinema 02 (3D)', '3D', 5, 8, 1);

-- Seats Room 1 (A-E x 1-8)
INSERT INTO Seats (room_id, seat_row, seat_number, seat_type, price_modifier) VALUES
(1, 'A', 1, 'STANDARD', 0), (1, 'A', 2, 'STANDARD', 0), (1, 'A', 3, 'STANDARD', 0), (1, 'A', 4, 'STANDARD', 0), (1, 'A', 5, 'STANDARD', 0), (1, 'A', 6, 'STANDARD', 0), (1, 'A', 7, 'STANDARD', 0), (1, 'A', 8, 'STANDARD', 0),
(1, 'B', 1, 'STANDARD', 0), (1, 'B', 2, 'STANDARD', 0), (1, 'B', 3, 'STANDARD', 0), (1, 'B', 4, 'STANDARD', 0), (1, 'B', 5, 'STANDARD', 0), (1, 'B', 6, 'STANDARD', 0), (1, 'B', 7, 'STANDARD', 0), (1, 'B', 8, 'STANDARD', 0),
(1, 'C', 1, 'VIP', 15000), (1, 'C', 2, 'VIP', 15000), (1, 'C', 3, 'VIP', 15000), (1, 'C', 4, 'VIP', 15000), (1, 'C', 5, 'VIP', 15000), (1, 'C', 6, 'VIP', 15000), (1, 'C', 7, 'VIP', 15000), (1, 'C', 8, 'VIP', 15000),
(1, 'D', 1, 'VIP', 15000), (1, 'D', 2, 'VIP', 15000), (1, 'D', 3, 'VIP', 15000), (1, 'D', 4, 'VIP', 15000), (1, 'D', 5, 'VIP', 15000), (1, 'D', 6, 'VIP', 15000), (1, 'D', 7, 'VIP', 15000), (1, 'D', 8, 'VIP', 15000),
(1, 'E', 1, 'COUPLE', 30000), (1, 'E', 2, 'COUPLE', 30000), (1, 'E', 3, 'COUPLE', 30000), (1, 'E', 4, 'COUPLE', 30000), (1, 'E', 5, 'COUPLE', 30000), (1, 'E', 6, 'COUPLE', 30000), (1, 'E', 7, 'COUPLE', 30000), (1, 'E', 8, 'COUPLE', 30000);

-- Showtimes
INSERT INTO Showtimes (movie_id, room_id, show_date, start_time, end_time, base_price, status) VALUES
(1, 1, CURDATE(), '09:00:00', '11:15:00', 80000, 'OPEN'),
(1, 1, CURDATE(), '14:00:00', '16:15:00', 90000, 'OPEN'),
(1, 1, CURDATE(), '19:30:00', '21:45:00', 100000, 'OPEN'),
(2, 1, CURDATE(), '10:00:00', '12:45:00', 95000, 'OPEN');
