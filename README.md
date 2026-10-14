# PRJ302_QuanLyRapChieuPhim

<p align="left">
  <a href="https://github.com/TurtlesGA/PRJ302_QuanLyRapChieuPhim/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/TurtlesGA/PRJ302_QuanLyRapChieuPhim?style=flat-square&logo=github&color=e50914" alt="Contributors" />
  </a>
  <img src="https://img.shields.io/badge/Java-17%20%2F%2011%2B-orange?style=flat-square&logo=openjdk" alt="Java 17" />
  <img src="https://img.shields.io/badge/Jakarta%20EE-10%20(Servlet%206.0)-red?style=flat-square&logo=apachetomcat" alt="Jakarta EE 10" />
  <img src="https://img.shields.io/badge/Server-Apache%20Tomcat%2010.1%2B-blue?style=flat-square&logo=apachetomcat" alt="Tomcat 10" />
  <img src="https://img.shields.io/badge/Database-SQL%20Server-blue?style=flat-square&logo=microsoftsqlserver" alt="SQL Server" />
  <img src="https://img.shields.io/badge/Theme-Dark%20%2F%20Light-success?style=flat-square" alt="Theme" />
</p>

Hệ thống Quản lý và Đặt vé Rạp chiếu phim (**CineStar Cinema Management System**) được xây dựng trên nền tảng **Java Web (Jakarta Servlet 6.0 - JSP - JDBC)** theo mô hình kiến trúc chuẩn **MVC (Model - View - Controller)** kết hợp **DAO Pattern** và **Database Transaction**.

---

## 🚀 Giới Thiệu Dự Án

Dự án cung cấp giải pháp toàn diện cho hoạt động quản lý rạp chiếu phim hiện đại và mang đến trải nghiệm đặt vé xem phim trực tuyến tiện lợi cho người dùng:

- **Khách hàng (Customer)**:
  - **Trang chủ & Danh mục phim**: Khám phá danh sách phim đang chiếu (`NOW_SHOWING`), phim sắp chiếu (`COMING_SOON`), xem banner nổi bật và lọc phim trực quan.
  - **Chi tiết phim & Trailer**: Tra cứu đầy đủ thông tin về thể loại, thời lượng, ngày phát hành, đạo diễn, diễn viên, nhãn phân loại độ tuổi (P, K, T13, T16, T18), xem trailer nhúng trực tiếp từ YouTube.
  - **Đặt vé & Chọn ghế trực quan**: Lựa chọn suất chiếu theo ngày và phòng chiếu; sơ đồ phòng chiếu sinh động hiển thị các loại ghế (**Ghế Thường**, **Ghế VIP**, **Ghế Đôi / Couple**) kèm giá tiền tự động tính toán theo hệ số nhân; ngăn chặn đặt trùng ghế theo thời gian thực.
  - **Giả lập thanh toán trực tuyến (QR Pay)**: Tích hợp mã QR động mô phỏng thanh toán qua **VNPAY** và **MoMo**, cơ chế giữ chỗ tạm thời trạng thái `PENDING` kèm đồng hồ đếm ngược 10 phút, hỗ trợ hủy giao dịch để nhả ghế hoặc thanh toán bù trong lịch sử đơn hàng.
  - **Lịch sử đặt vé & Hủy vé trực tuyến**: Theo dõi toàn bộ danh sách vé đã mua, chi tiết mã đơn hàng (`booking_code`), trạng thái thanh toán và tự thực hiện hủy vé khi chưa đến giờ chiếu để giải phóng ghế.
  - **Quản lý tài khoản & Khôi phục mật khẩu**: Đăng ký, đăng nhập, cập nhật hồ sơ cá nhân, đổi mật khẩu và tính năng **Quên mật khẩu / Đặt lại mật khẩu qua mã OTP 6 số** theo luồng xác thực 2 bước an toàn.

- **Quản trị viên (Admin)**:
  - **Bảng điều khiển (Dashboard)**: Theo dõi các chỉ số thống kê tổng quan (Tổng doanh thu, Tổng số vé bán ra, Tổng số lượng phim, Tổng người dùng hệ thống) và danh sách 10 đơn đặt vé gần nhất.
  - **Quản lý Phim (`/admin/movies`)**: Thêm, sửa, xóa phim, cấu hình áp phích (poster), liên kết trailer, phân loại độ tuổi và trạng thái phim.
  - **Quản lý Phòng Chiếu (`/admin/rooms`)**: Thêm, chỉnh sửa, bật/tắt hoạt động, xóa phòng chiếu; **tự động sinh sơ đồ ghế ngồi** theo hàng x cột (`total_rows` x `total_cols`) và phân hạng loại ghế (Thường, VIP, Đôi).
  - **Quản lý Suất Chiếu (`/admin/showtimes`)**: Thêm suất chiếu mới (chọn phim và phòng đang hoạt động, tự động tính giờ kết thúc dựa theo thời lượng phim), xóa suất chiếu.
  - **Quản lý Đơn Vé (`/admin/bookings`)**: Tra cứu toàn bộ lịch sử đặt vé của khách hàng; cho phép quản trị viên hủy đơn vé có xác nhận để hoàn trả vị trí ghế về trạng thái trống.
  - **Quản lý Người Dùng (`/admin/users`)**: Thêm mới tài khoản người dùng trực tiếp trong trang quản trị, chỉnh sửa đầy đủ thông tin & vai trò (`ADMIN`, `STAFF`, `CUSTOMER`), khóa / mở khóa tài khoản (`status`), và **xóa người dùng** (tự động xóa cascading vé và đơn đặt vé trong Database Transaction an toàn, có cơ chế chặn tự xóa tài khoản đang đăng nhập).
  - **Giao diện Admin chuyên dụng & SweetAlert2**: Header/Footer quản trị tách biệt, Mobile Offcanvas Sidebar drawer, tích hợp thư viện **SweetAlert2** cho tất cả các hộp thoại xác nhận thao tác và toast thông báo flash message.

---

## 🛠️ Công Nghệ Sử Dụng

- **Ngôn ngữ**: Java 17 (tương thích Java 11+)
- **Nền tảng & Web Layer**:
  - **Jakarta EE 10 / Servlet 6.0** (`jakarta.servlet.*`)
  - **JSP (JavaServer Pages)** & **JSTL 2.0** (`jakarta.servlet.jsp.jstl`)
  - Web Server khuyến nghị: **Apache Tomcat 10.1+** (hoặc Tomcat 10.0+)
- **Kiến trúc ứng dụng**:
  - Mô hình **MVC (Model - View - Controller)** chuẩn mực.
  - **DAO (Data Access Object) Pattern** tách bạch truy cập dữ liệu.
  - **Database Transaction Management** (`setAutoCommit(false)`, `commit()`, `rollback()`) đảm bảo tính toàn vẹn dữ liệu khi đặt vé và xóa tài khoản.
- **Cơ sở dữ liệu (Database & Persistence)**:
  - Hệ quản trị CSDL: **Microsoft SQL Server** (2014, 2017, 2019, 2022+).
  - Kết nối JDBC với driver `mssql-jdbc-13.2.0.jre11.jar`.
  - Cấu hình Unicode đầy đủ: `sendStringParametersAsUnicode=true`, `characterEncoding=UTF-8`, `useUnicode=true`.
- **Bộ lọc & Bảo mật (Filters & Security)**:
  - `EncodingFilter`: Tự động thiết lập mã hóa UTF-8 cho toàn bộ Request và Response (hỗ trợ hiển thị tiếng Việt có dấu chuẩn xác).
  - `AuthFilter`: Bảo vệ các đường dẫn nhạy cảm `/admin/*` (yêu cầu quyền Admin) và các chức năng cá nhân `/my-bookings`, `/checkout`, `/payment`, `/payment-confirm`, `/profile`.
  - Cơ chế tự phục hồi chuỗi mã hóa lỗi Mojibake (Windows-1252 $\leftrightarrow$ UTF-8) tại Model layer.
- **Giao diện Frontend (UI/UX)**:
  - **Bootstrap 5.3** với thiết kế hiện đại, tương thích đa kích thước màn hình (PC, Tablet, Mobile).
  - **Chế độ Kép Dark / Light Mode**: Chuyển đổi mượt mà bằng CSS Variables và thuộc tính `data-bs-theme`, lưu trạng thái qua `localStorage`.
  - **SweetAlert2 (v11)**: Hộp thoại xác nhận thao tác (Xóa, Hủy vé, Khóa tài khoản) và thông báo Toast góc màn hình cho người dùng.
  - **FontAwesome 6** & Google Fonts **Montserrat**.
  - JavaScript tương tác trực quan sơ đồ chọn ghế, đồng hồ đếm ngược giữ vé và tính tiền tự động.

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
PRJ302_QuanLyRapChieuPhim/
│
├── database/
│   └── cinema_db.sql                     # Script khởi tạo CSDL SQL Server (kèm dữ liệu mẫu UTF-8)
│
├── allowedlib/                           # Thư viện JAR cần thiết cho dự án
│   ├── jakarta.servlet.jsp.jstl-2.0.0.jar
│   ├── jakarta.servlet.jsp.jstl-api-2.0.0.jar
│   ├── jaxb-api-2.1.jar
│   └── mssql-jdbc-13.2.0.jre11.jar       # JDBC Driver cho SQL Server (JRE 11+)
│
├── src/
│   └── java/
│       └── com/cinema/
│           ├── context/
│           │   └── DBContext.java                # Kết nối CSDL JDBC Microsoft SQL Server
│           ├── model/                            # Thực thể dữ liệu (POJO)
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
│           ├── filter/                           # Bộ lọc UTF-8 & Phân quyền bảo mật
│           │   ├── EncodingFilter.java
│           │   └── AuthFilter.java
│           └── controller/                       # Controller Layer (Jakarta Servlets)
│               ├── HomeController.java
│               ├── MoviesListController.java
│               ├── MovieDetailController.java
│               ├── SeatSelectionController.java
│               ├── CheckoutController.java       # Thanh toán, QR Pay, xác nhận giữ chỗ
│               ├── MyBookingsController.java     # Lịch sử đơn hàng, hủy vé
│               ├── auth/                         # Xác thực & tài khoản
│               │   ├── LoginController.java
│               │   ├── RegisterController.java
│               │   ├── ForgotPasswordController.java # Quên mật khẩu, cấp mã OTP
│               │   ├── LogoutController.java
│               │   └── ProfileController.java
│               └── admin/                        # Nghiệp vụ quản trị
│                   ├── AdminDashboardController.java
│                   ├── AdminMovieController.java
│                   ├── AdminRoomController.java
│                   ├── AdminShowtimeController.java
│                   ├── AdminBookingController.java
│                   └── AdminUserController.java  # Quản lý người dùng, phân quyền, xóa tài khoản
│
├── web/
│   ├── index.jsp                                 # Trang chuyển hướng mặc định vào /home
│   ├── assets/
│   │   ├── css/
│   │   │   └── style.css                         # Giao diện chính, Dark/Light Mode, Seat Map
│   │   └── js/
│   │       ├── main.js                           # Xử lý chọn ghế, đếm ngược, chuyển theme
│   │       └── admin.js                          # Xử lý SweetAlert2, xác nhận & toast thông báo
│   └── WEB-INF/
│       ├── web.xml                               # Cấu hình Web Descriptor (Servlet 6.0, UTF-8, MIME)
│       └── views/
│           ├── common/                           # Giao diện dùng chung cho khách hàng
│           │   ├── header.jsp
│           │   ├── navbar.jsp
│           │   └── footer.jsp
│           ├── home.jsp                          # Trang chủ rạp chiếu phim
│           ├── movies.jsp                        # Danh sách phim đang chiếu & sắp chiếu
│           ├── movie-detail.jsp                  # Chi tiết phim, trailer YouTube
│           ├── seat-selection.jsp                # Sơ đồ chọn vị trí ghế ngồi
│           ├── payment.jsp                       # Trang giả lập thanh toán QR (MoMo / VNPAY)
│           ├── booking-success.jsp               # Thông báo đặt vé thành công
│           ├── my-bookings.jsp                   # Lịch sử vé đã mua & chức năng hủy vé
│           ├── login.jsp                         # Đăng nhập
│           ├── register.jsp                      # Đăng ký tài khoản
│           ├── forgot-password.jsp               # Khôi phục mật khẩu qua mã OTP
│           ├── profile.jsp                       # Hồ sơ cá nhân & đổi mật khẩu
│           └── admin/                            # Các giao diện quản trị Admin
│               ├── common/
│               │   ├── admin-header.jsp          # Navbar & Sidebar quản trị chuyên dụng
│               │   └── admin-footer.jsp          # Footer & Script SweetAlert2 quản trị
│               ├── dashboard.jsp                 # Thống kê tổng quan & đơn hàng mới
│               ├── movies.jsp                    # Danh sách quản lý phim
│               ├── movie-form.jsp                # Form thêm / sửa phim
│               ├── rooms.jsp                     # Danh sách phòng chiếu & sơ đồ ghế
│               ├── room-form.jsp                 # Form thêm / sửa phòng chiếu
│               ├── showtimes.jsp                 # Danh sách suất chiếu
│               ├── showtime-form.jsp             # Form lên lịch suất chiếu
│               ├── bookings.jsp                  # Danh sách đơn vé & hủy vé quản trị
│               ├── users.jsp                     # Quản lý người dùng & phân quyền
│               └── user-form.jsp                 # Form thêm / sửa người dùng
│
├── build.xml                                     # Cấu hình Ant Build (Apache NetBeans)
├── pom.xml.maven                                 # File cấu hình Maven dự phòng
└── README.md
```

---

## 🗄️ Hướng Dẫn Cài Đặt Cơ Sở Dữ Liệu

### Cài đặt trên Microsoft SQL Server

1. Khởi động **SQL Server Management Studio (SSMS)** hoặc **Azure Data Studio**.
2. Mở file script [database/cinema_db.sql](database/cinema_db.sql).
3. Nhấn **Execute (F5)** để tạo CSDL `CinemaDB`, toàn bộ hệ thống bảng và nạp sẵn dữ liệu mẫu (đầy đủ phim, phòng chiếu, sơ đồ ghế, suất chiếu và tài khoản).
4. Mở file [DBContext.java](src/java/com/cinema/context/DBContext.java) tại đường dẫn:
   `src/java/com/cinema/context/DBContext.java`
   và kiểm tra cấu hình thông số kết nối phù hợp với máy của bạn:
   ```java
   private static final String SERVER_NAME = "localhost";
   private static final String PORT_NUMBER = "1433";
   private static final String DATABASE_NAME = "CinemaDB";
   private static final String USER_ID = "sa";        // Tài khoản SA của SQL Server
   private static final String PASSWORD = "123";      // Mật khẩu SA của máy bạn
   ```

---

## 🔑 Tài Khoản Trải Nghiệm Mẫu

CSDL mẫu đã được khởi tạo sẵn các tài khoản demo để tiện trải nghiệm và đánh giá:

| Tài khoản (Username) | Mật khẩu (Password) | Vai trò (Role) | Chức năng chính |
|:---|:---|:---|:---|
| **admin** | `123456` | **ADMIN** | Toàn quyền quản trị hệ thống: Bảng điều khiển doanh thu, Quản lý phim, Phòng chiếu, Suất chiếu, Tra cứu & Hủy đơn vé, Thêm/Sửa/Khóa/Xóa tài khoản người dùng |
| **staff** | `123456` | **STAFF** | Tài khoản nhân viên rạp |
| **customer** | `123456` | **CUSTOMER** | Đặt vé, chọn ghế, thanh toán QR giả lập, xem lịch sử đặt vé, hủy vé, đổi mật khẩu và cập nhật thông tin cá nhân |
| **user2** | `123456` | **CUSTOMER** | Tài khoản khách hàng mẫu thứ 2 |

---

## 💻 Hướng Dẫn Chạy Dự Án

> [!IMPORTANT]
> **Yêu cầu môi trường chạy**:
> - **JDK**: Java 17 (hoặc Java 11+).
> - **Web Server**: **Apache Tomcat 10.1+** (hoặc Tomcat 10.0+).  
> *Lưu ý: Không sử dụng Tomcat 9 trở xuống vì dự án sử dụng đặc tả **Jakarta EE 10** (`jakarta.servlet.*`), Tomcat 9 chỉ hỗ trợ `javax.servlet.*` sẽ gây lỗi khi khởi chạy.*

### 1. Chạy với Apache NetBeans (Khuyến nghị)
1. Mở **Apache NetBeans** (phiên bản 15, 17, 19, 21 hoặc mới hơn).
2. Chọn **File** -> **Open Project** -> Duyệt đến thư mục `PRJ302_QuanLyRapChieuPhim`.
3. Kiểm tra Server: Chuột phải vào Project -> Chọn **Properties** -> mục **Run** -> đảm bảo Server đã chọn là **Apache Tomcat 10.x** (hoặc Tomcat 10.1+).
4. Các thư viện JAR trong thư mục `allowedlib/` đã được liên kết tự động trong `nbproject/project.properties`.
5. Chuột phải vào Project -> Chọn **Clean and Build**.
6. Nhấn nút **Run** (F6) hoặc chuột phải chọn **Run**. Ứng dụng sẽ tự động mở trên trình duyệt tại địa chỉ:
   `http://localhost:8080/PRJ302_QuanLyRapChieuPhim/`

### 2. Chạy với IntelliJ IDEA Ultimate
1. Mở IntelliJ IDEA Ultimate -> Chọn **Open** -> Chọn thư mục `PRJ302_QuanLyRapChieuPhim`.
2. Vào **File** -> **Project Structure**:
   - **Project**: Chọn **SDK 17**.
   - **Modules** -> tab **Dependencies**: Thêm các file JAR trong thư mục `allowedlib/` vào project.
   - **Facets** / **Artifacts**: Thêm **Web Application: Exploded** trỏ đến thư mục `web/`.
3. Cấu hình **Run/Debug Configurations**:
   - Nhấn `+` -> Chọn **Tomcat Server** -> **Local**.
   - Chọn đường dẫn đến thư mục cài đặt Tomcat 10.x / 10.1+.
   - Tab **Deployment**: Thêm Artifact `PRJ302_QuanLyRapChieuPhim:war exploded`.
   - Đặt **Application context**: `/PRJ302_QuanLyRapChieuPhim` (hoặc `/`).
4. Nhấn **Run** hoặc **Debug**.

---

## ✨ Điểm Nổi Bật Kỹ Thuật (Báo Cáo Môn Học)

1. **Quản Lý Giao Dịch CSDL (Database Transactions & Concurrency)**:
   - **Đặt vé & Khóa ghế**: Quá trình tạo đơn hàng (`Bookings`) và chèn chi tiết vé (`Tickets`) được bao bọc trong transaction (`conn.setAutoCommit(false)`). Cơ chế kiểm tra xung đột ghế ở backend ngăn chặn triệt để tình trạng đặt trùng ghế (Race Condition).
   - **Xóa tài khoản an toàn**: Nghiệp vụ xóa người dùng được quản lý theo chuỗi giao dịch (xóa Tickets liên quan $\rightarrow$ xóa Bookings $\rightarrow$ xóa User), tự động rollback nếu xảy ra lỗi bất kỳ.
2. **Tự Động Sinh Sơ Đồ Ghế (Dynamic Seat Matrix)**:
   - Khi Admin tạo phòng chiếu với số hàng và số cột tùy ý, hệ thống tự động sinh danh sách ghế tương ứng trong bảng `Seats`, tự động phân hạng ghế (Ghế Thường ở hàng đầu, Ghế VIP ở trung tâm, Ghế Đôi ở hàng cuối) với hệ số nhân giá vé tương ứng.
3. **Giả Lập Thanh Toán Trực Tuyến QR Pay & Bộ Đếm Giữ Ghế**:
   - Mô phỏng cổng thanh toán trực tuyến MoMo và VNPAY với mã QR động tạo theo mã đơn hàng và số tiền.
   - Đơn hàng được giữ ở trạng thái `PENDING` kèm đồng hồ đếm ngược 10 phút; nếu khách hàng hủy hoặc hết hạn, vị trí ghế sẽ được giải phóng lập tức. Hỗ trợ khách hàng tiếp tục thanh toán đơn chờ qua trang `/my-bookings`.
4. **Khôi Phục Mật Khẩu Bằng Mã OTP 2 Bước**:
   - Cung cấp luồng khôi phục tài khoản qua mã xác thực OTP 6 chữ số ngẫu nhiên lưu trong Session, kiểm tra email tồn tại và cho phép cập nhật lại mật khẩu mới mà không cần can thiệp CSDL thủ công.
5. **Quản Trị Người Dùng Toàn Diện (CRUD & Role Management)**:
   - Đầy đủ các tính năng: Thêm người dùng mới, Sửa thông tin & đổi vai trò, Khóa / Mở khóa trạng thái tài khoản, và Xóa người dùng với cơ chế ngăn chặn xóa chính tài khoản đang đăng nhập.
6. **Bảo Mật Hai Lớp Bằng Servlet Filters**:
   - `EncodingFilter`: Đảm bảo toàn bộ request/response xử lý chuẩn UTF-8, cấu hình MIME-mapping chính xác cho static assets (CSS, JS).
   - `AuthFilter`: Kiểm soát phân quyền chặt chẽ giữa khách hàng và quản trị viên, tự động chuyển hướng về trang đăng nhập kèm thông báo khi truy cập trái phép.
7. **Tối Ưu Giao Diện Kép Dark / Light Mode & Trải Nghiệm Người Dùng**:
   - Chuyển đổi giao diện Sáng / Tối linh hoạt lưu trên `localStorage`.
   - Nâng cấp độ tương phản (High Contrast) cho các bảng dữ liệu, nút bấm và sơ đồ ghế, loại bỏ triệt để hiện tượng vỡ màu khi chuyển đổi giữa 2 chế độ.
   - Tích hợp thư viện **SweetAlert2** chuyên nghiệp cho các thông báo Toast và hộp thoại xác nhận thao tác nhạy cảm.
   - Hỗ trợ giao diện Responsive trên thiết bị di động với menu Offcanvas chuyên dụng cho trang quản trị.

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
