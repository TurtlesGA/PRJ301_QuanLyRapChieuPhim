# PRJ302_QuanLyRapChieuPhim

Hệ thống Quản lý và Đặt vé Rạp chiếu phim (Cinema Management System) phát triển bằng nền tảng **Java Web (Servlet - JSP - JDBC)** theo mô hình kiến trúc chuẩn **MVC (Model - View - Controller)** kết hợp **DAO Pattern**.

---

## 🚀 Giới Thiệu Dự Án

Dự án cung cấp giải pháp toàn diện cho việc quản lý rạp chiếu phim và hỗ trợ người dùng trải nghiệm đặt vé xem phim trực tuyến hiện đại, trực quan:
- **Người dùng (Khách hàng)**: Xem danh sách phim đang chiếu, sắp chiếu, tra cứu lịch chiếu, lựa chọn suất chiếu, chọn vị trí ghế ngồi trực quan (Ghế Thường, VIP, Ghế Đôi), đặt vé và xem lại lịch sử vé đã mua.
- **Quản trị viên (Admin)**: Quản lý danh mục phim, quản lý suất chiếu theo phòng, theo dõi lịch sử và doanh thu bán vé, quản lý phân quyền và khóa/mở khóa tài khoản khách hàng.

---

## 🛠️ Công Nghệ Sử Dụng

- **Ngôn ngữ**: Java 8 / 11+
- **Kiến trúc**: MVC (Model - View - Controller), DAO Pattern, DB Transaction
- **Web Layer**: Java Servlet (4.0+), JSP (JavaServer Pages), JSTL 1.2
- **Database & Persistence**: JDBC kết nối **Microsoft SQL Server** (hỗ trợ cả **MySQL**)
- **Bộ lọc & Bảo mật**:
  - `EncodingFilter`: Tự động chuyển đổi UTF-8 cho toàn bộ Request & Response (hỗ trợ tiếng Việt hoàn chỉnh).
  - `AuthFilter`: Phân quyền người dùng, bảo vệ các URL `/admin/*` và trang cá nhân `/my-bookings`, `/checkout`.
- **Giao diện Frontend**:
  - Bootstrap 5.3 (Dark Theme chuẩn Cinema)
  - FontAwesome 6 Icons
  - Responsive tương thích máy tính & thiết bị di động
  - JavaScript tương tác sơ đồ ghế ngồi trực quan & tự động tính tiền.

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
PRJ302_QuanLyRapChieuPhim/
│
├── database/
│   └── cinema_db.sql            # Script khởi tạo CSDL cho Microsoft SQL Server (Đầy đủ dữ liệu mẫu)
│
├── src/
│   └── java/
│       └── com/cinema/
│           ├── context/
│           │   └── DBContext.java                 # Kết nối CSDL JDBC
│           ├── model/                            # Các thực thể dữ liệu (POJO)
│           │   ├── User.java
│           │   ├── Movie.java
│           │   ├── Room.java
│           │   ├── Seat.java
│           │   ├── Showtime.java
│           │   ├── Booking.java
│           │   └── Ticket.java
│           ├── dao/                              # Data Access Object Layer
│           │   ├── UserDAO.java
│           │   ├── MovieDAO.java
│           │   ├── RoomDAO.java
│           │   ├── ShowtimeDAO.java
│           │   └── BookingDAO.java
│           ├── filter/                           # Bộ lọc UTF-8 & Phân quyền
│           │   ├── EncodingFilter.java
│           │   └── AuthFilter.java
│           └── controller/                       # Controller Layer (Servlets)
│               ├── HomeController.java
│               ├── MoviesListController.java
│               ├── MovieDetailController.java
│               ├── SeatSelectionController.java
│               ├── CheckoutController.java
│               ├── MyBookingsController.java
│               ├── auth/
│               │   ├── LoginController.java
│               │   ├── RegisterController.java
│               │   ├── LogoutController.java
│               │   └── ProfileController.java
│               └── admin/
│                   ├── AdminDashboardController.java
│                   ├── AdminMovieController.java
│                   ├── AdminShowtimeController.java
│                   ├── AdminBookingController.java
│                   └── AdminUserController.java
│
├── web/
│   ├── assets/
│   │   ├── css/style.css                     # Cinema UI Style
│   │   └── js/main.js                        # Sơ đồ chọn ghế & tính giá vé
│   └── WEB-INF/
│       ├── web.xml                           # Web Deployment Descriptor
│       └── views/
│           ├── common/
│           │   ├── header.jsp
│           │   ├── navbar.jsp
│           │   └── footer.jsp
│           ├── home.jsp
│           ├── movies.jsp
│           ├── movie-detail.jsp
│           ├── seat-selection.jsp
│           ├── booking-success.jsp
│           ├── my-bookings.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── profile.jsp
│           └── admin/
│               ├── dashboard.jsp
│               ├── movies.jsp
│               ├── movie-form.jsp
│               ├── showtimes.jsp
│               ├── showtime-form.jsp
│               ├── bookings.jsp
│               └── users.jsp
│
├── allowedlib/                                       # Thư viện JAR (SQL JDBC, JSTL 2.0)
├── build.xml                                         # Cấu hình Ant Build (NetBeans)
├── pom.xml.maven                                     # Cấu hình Maven dự phòng
└── README.md
```

---

## 🗄️ Hướng Dẫn Cài Đặt Cơ Sở Dữ Liệu

### 1. Cài đặt trên Microsoft SQL Server (Mặc định)
1. Mở **SQL Server Management Studio (SSMS)**.
2. Mở file [database/cinema_db.sql](database/cinema_db.sql).
3. Nhấn **Execute (F5)** để tự động tạo Database `CinemaDB`, cấu trúc bảng và nạp sẵn dữ liệu mẫu.
4. Mở file `src/java/com/cinema/context/DBContext.java` và chỉnh sửa thông tin đăng nhập:
   ```java
   private static final String SERVER_NAME = "localhost";
   private static final String PORT_NUMBER = "1433";
   private static final String DATABASE_NAME = "CinemaDB";
   private static final String USER_ID = "sa";        // Tài khoản SQL của bạn
   private static final String PASSWORD = "123";      // Mật khẩu SA của bạn
   ```


## 🔑 Tài Khoản Trải Nghiệm Mẫu

Hệ thống đã tạo sẵn các tài khoản demo:

| Tài khoản | Mật khẩu | Quyền hạn (Role) | Chức năng chính |
|:---|:---|:---|:---|
| **admin** | `123456` | **ADMIN** | Truy cập Dashboard, Quản lý phim, Quản lý suất chiếu, Xem doanh thu, Quản lý người dùng |
| **customer** | `123456` | **CUSTOMER** | Đặt vé, chọn ghế, quản lý hồ sơ cá nhân, xem lịch sử vé |
| **user2** | `123456` | **CUSTOMER** | Tài khoản khách hàng mẫu |

---

## 💻 Hướng Dẫn Chạy Dự Án

### Với IntelliJ IDEA Ultimate
1. Mở IntelliJ IDEA -> Chọn **Open** -> Chọn thư mục `PRJ302_QuanLyRapChieuPhim`.
2. Chờ Maven tải các thư viện trong `pom.xml`.
3. Cấu hình Run Configuration: **Tomcat Server** -> **Local**.
4. Tab **Deployment**: Nhấn `+` -> Chọn `PRJ302_QuanLyRapChieuPhim:war exploded`.
5. Đặt Application context là `/` hoặc `/PRJ302_QuanLyRapChieuPhim`.
6. Nhấn **Run** hoặc **Debug**.

### Với Apache NetBeans
1. Mở NetBeans -> **File** -> **Open Project** -> Chọn thư mục dự án.
2. Chuột phải vào project -> **Properties** -> **Run** -> Chọn Server **Apache Tomcat**.
3. Chuột phải vào project -> **Clean and Build**, sau đó chọn **Run**.

---

## ✨ Điểm Nổi Bật Kỹ Thuật (Phù Hợp Báo Cáo Môn Học)

1. **Transaction Management**: Quá trình tạo đơn hàng (`Bookings`) và lưu chi tiết vé (`Tickets`) được bao bọc trong Transaction (`conn.setAutoCommit(false)`), đảm bảo toàn vẹn dữ liệu nếu xảy ra lỗi.
2. **Dynamic Seat Allocation**: Sơ đồ ghế kiểm tra trạng thái thời gian thực theo từng suất chiếu, không cho phép đặt đè ghế đã bán.
3. **Phân quyền và Bộ lọc**: Tách biệt rõ quyền quản trị viên và khách hàng với Servlet Filter.
4. **Chuẩn mã hóa**: Hỗ trợ tiếng Việt có dấu đầy đủ từ CSDL đến giao diện Web.
