# PRJ302_QuanLyRapChieuPhim

<p align="left">
  <a href="https://github.com/TurtlesGA/PRJ302_QuanLyRapChieuPhim/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/TurtlesGA/PRJ302_QuanLyRapChieuPhim?style=flat-square&logo=github&color=e50914" alt="Contributors" />
  </a>
  <img src="https://img.shields.io/badge/Java-Servlet%20%2F%20JSP-orange?style=flat-square&logo=openjdk" alt="Java" />
  <img src="https://img.shields.io/badge/Database-SQL%20Server-blue?style=flat-square&logo=microsoftsqlserver" alt="SQL Server" />
  <img src="https://img.shields.io/badge/Theme-Dark%20%2F%20Light-success?style=flat-square" alt="Theme" />
</p>

Hệ thống Quản lý và Đặt vé Rạp chiếu phim (Cinema Management System) phát triển bằng nền tảng **Java Web (Servlet - JSP - JDBC)** theo mô hình kiến trúc chuẩn **MVC (Model - View - Controller)** kết hợp **DAO Pattern**.

---

## 🚀 Giới Thiệu Dự Án

Dự án cung cấp giải pháp toàn diện cho việc quản lý rạp chiếu phim và hỗ trợ người dùng trải nghiệm đặt vé xem phim trực tuyến hiện đại, trực quan:
- **Người dùng (Khách hàng)**: Xem danh sách phim đang chiếu, sắp chiếu, tra cứu lịch chiếu, lựa chọn suất chiếu, chọn vị trí ghế ngồi trực quan (Ghế Thường, VIP, Ghế Đôi), đặt vé, giả lập thanh toán trực tuyến qua mã QR động (VNPAY / MoMo), xem lại lịch sử vé đã mua, hủy vé trực tuyến và khôi phục tài khoản qua mã OTP khi quên mật khẩu.
- **Quản trị viên (Admin)**: Quản lý danh mục phim, quản lý phòng chiếu (thêm, sửa, đổi trạng thái, xóa phòng, tự sinh sơ đồ ghế), quản lý suất chiếu theo phòng, theo dõi lịch sử và hủy vé, thống kê doanh thu bán vé, quản lý phân quyền và khóa/mở khóa tài khoản khách hàng.

---

## 🛠️ Công Nghệ Sử Dụng

- **Ngôn ngữ**: Java 8 / 11+
- **Kiến trúc**: MVC (Model - View - Controller), DAO Pattern, DB Transaction
- **Web Layer**: Java Servlet (4.0+), JSP (JavaServer Pages), JSTL 1.2
- **Database & Persistence**: JDBC kết nối **Microsoft SQL Server** (hỗ trợ cả **MySQL**)
- **Bộ lọc & Bảo mật**:
  - `EncodingFilter`: Tự động chuyển đổi UTF-8 cho toàn bộ Request & Response (hỗ trợ tiếng Việt hoàn chỉnh).
  - `AuthFilter`: Phân quyền người dùng, bảo vệ các URL `/admin/*` và trang cá nhân `/my-bookings`, `/checkout`.
  - Cơ chế tự phục hồi mã hóa Mojibake trong Model layer kết hợp tham số kết nối JDBC chuẩn Unicode.
- **Giao diện Frontend**:
  - Bootstrap 5.3 kết hợp cơ chế chuyển đổi chế độ **Sáng / Tối (Dark / Light Mode)** linh hoạt với lưu trữ `localStorage`.
  - Thiết kế độ tương phản cao (High Contrast), tối ưu toàn diện cho các bảng dữ liệu quản trị, thẻ thông tin, sidebar và sơ đồ ghế ở cả hai chế độ sáng/tối.
  - FontAwesome 6 Icons & Google Fonts Montserrat.
  - Responsive tương thích máy tính & thiết bị di động.
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
│               │   ├── ForgotPasswordController.java
│               │   ├── LogoutController.java
│               │   └── ProfileController.java
│               └── admin/
│                   ├── AdminDashboardController.java
│                   ├── AdminMovieController.java
│                   ├── AdminRoomController.java
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
│           │   ├── footer.jsp
│           │   ├── admin-header.jsp
│           │   └── admin-footer.jsp
│           ├── home.jsp
│           ├── movies.jsp
│           ├── movie-detail.jsp
│           ├── seat-selection.jsp
│           ├── payment.jsp
│           ├── booking-success.jsp
│           ├── my-bookings.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── forgot-password.jsp
│           ├── profile.jsp
│           └── admin/
│               ├── dashboard.jsp
│               ├── movies.jsp
│               ├── movie-form.jsp
│               ├── rooms.jsp
│               ├── room-form.jsp
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
| **admin** | `123456` | **ADMIN** | Bảng điều khiển, Quản lý phim, Quản lý phòng chiếu, Quản lý suất chiếu, Xem & Hủy đơn vé, Xem doanh thu, Quản lý người dùng |
| **customer** | `123456` | **CUSTOMER** | Đặt vé, chọn vị trí ghế, quản lý hồ sơ cá nhân, xem lịch sử & hủy vé đã mua |
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

1. **Transaction Management & Ngăn chặn đặt trùng ghế**: Quá trình tạo đơn hàng (`Bookings`) và lưu chi tiết vé (`Tickets`) được bao bọc trong Database Transaction (`conn.setAutoCommit(false)`), đồng thời có cơ chế kiểm tra xung đột ghế ở backend để triệt để ngăn chặn đặt trùng cùng một vị trí ghế.
2. **Dynamic Seat Allocation & Phân Hạng Ghế**: Tự động sinh sơ đồ ghế (Ghế Thường, VIP, Ghế Đôi) khi tạo phòng chiếu mới; kiểm tra trạng thái ghế thời gian thực theo từng suất chiếu, tự động giải phóng vị trí ghế khi vé bị hủy.
3. **Quản Lý & Hủy Vé Linh Hoạt**: Cung cấp chức năng hủy vé cho cả khách hàng và quản trị viên, cập nhật trạng thái đơn vé (`PAID`, `CANCELLED`) và mở lại ghế ngay lập tức.
4. **Phân Quyền & Bảo Vệ Tài Nguyên (Security Filters)**: Tách biệt rõ quyền quản trị viên (`ADMIN`) và khách hàng (`CUSTOMER`) bằng Servlet Filter (`AuthFilter`), ngăn chặn truy cập trái phép vào khu vực quản trị.
5. **Đồng Bộ Mã Hóa Tiếng Việt (UTF-8) & Tự Động Phục Hồi Mojibake**:
   - File CSDL `cinema_db.sql` lưu chuẩn UTF-8 BOM, tương thích hoàn toàn với Microsoft SQL Server (SSMS).
   - Thiết lập tham số JDBC Unicode (`sendStringParametersAsUnicode=true`, `characterEncoding=UTF-8`) và cấu hình `web.xml` `<jsp-config>`.
   - Cơ chế tự động phát hiện và chuyển đổi chuỗi mojibake Windows-1252 về UTF-8 trong tầng Model.
6. **Chế Độ Giao Diện Kép (Dark / Light Mode) & Độ Tương Phản Tối Ưu**:
   - Cho phép người dùng chuyển đổi mượt mà giữa chế độ Sáng và Tối trực tiếp trên Navbar, lưu trạng thái thông qua `localStorage`.
   - Hệ thống CSS biến thể (`data-bs-theme`) được thiết kế tỉ mỉ, triệt để loại bỏ các mảng đen cứng khi chuyển sang chế độ sáng, tối ưu độ tương phản văn bản và bảng dữ liệu quản trị giúp giao diện rõ ràng, dễ nhìn.
7. **Giả Lập Thanh Toán Trực Tuyến & Khóa Ghế Tạm Thời (QR Pay)**: Tích hợp cổng thanh toán trực tuyến mô phỏng VNPAY và MoMo với mã QR động, giữ chỗ ghế ở trạng thái `PENDING` kèm đồng hồ đếm ngược 10 phút, tự động nhả ghế nếu hủy giao dịch hoặc cho phép thanh toán bù trong trang cá nhân.
8. **Khôi Phục Tài Khoản Qua Mã OTP (Account Recovery)**: Cung cấp tính năng quên mật khẩu và đặt lại mật khẩu với cơ chế cấp mã xác thực OTP 6 số ngẫu nhiên theo luồng xác thực 2 bước an toàn.

---

## 👥 Người Đóng Góp (Contributors)

Cảm ơn tất cả các thành viên đã tham gia xây dựng và đóng góp cho dự án!

<p align="center">
  <a href="https://github.com/TurtlesGA/PRJ302_QuanLyRapChieuPhim/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/TurtlesGA/PRJ302_QuanLyRapChieuPhim?style=for-the-badge&logo=github&color=e50914" alt="Contributors Count" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/TurtlesGA/PRJ302_QuanLyRapChieuPhim/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=TurtlesGA/PRJ302_QuanLyRapChieuPhim" alt="Contributors Avatar Grid" />
  </a>
</p>

