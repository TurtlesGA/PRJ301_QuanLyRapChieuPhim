package com.cinema.context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBContext - Quản lý kết nối cơ sở dữ liệu (SQL Server / MySQL)
 * Chuẩn mô hình JDBC cho các môn PRJ301 / PRJ302
 */
public class DBContext {

    // Cấu hình kết nối SQL Server
    private static final String SERVER_NAME = "localhost";
    private static final String PORT_NUMBER = "1433";
    private static final String DATABASE_NAME = "CinemaDB";
    private static final String USER_ID = "sa";
    private static final String PASSWORD = "123"; // Đổi thành mật khẩu SA của máy bạn

    /**
     * Mở kết nối đến SQL Server
     * @return Connection
     * @throws Exception
     */
    public Connection getConnection() throws Exception {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER 
                    + ";databaseName=" + DATABASE_NAME 
                    + ";encrypt=true;trustServerCertificate=true;";
            return DriverManager.getConnection(url, USER_ID, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            // Thử kết nối URL dạng cổ điển nếu SQL Server cũ
            try {
                String fallbackUrl = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER 
                        + ";databaseName=" + DATABASE_NAME;
                return DriverManager.getConnection(fallbackUrl, USER_ID, PASSWORD);
            } catch (Exception ex) {
                System.err.println("Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
                throw ex;
            }
        }
    }

    /**
     * Phương thức tiện ích để đóng kết nối an toàn
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
