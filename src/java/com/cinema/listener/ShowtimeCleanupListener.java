package com.cinema.listener;

import com.cinema.dao.ShowtimeDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class ShowtimeCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;
    private ShowtimeDAO showtimeDAO = new ShowtimeDAO();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "Showtime-AutoCleanup-Worker");
            t.setDaemon(true);
            return t;
        });

        // Cơ chế dọn dẹp chủ động thông qua nút 'Dọn Dẹp Quá Hạn' trên trang Admin.
        // Có thể bật lại scheduler định kỳ nếu muốn hệ thống tự động dọn dẹp ngầm.
        /*
        scheduler.scheduleWithFixedDelay(() -> {
            try {
                showtimeDAO.deleteExpiredShowtimes();
            } catch (Throwable t) {
                System.err.println("[ShowtimeCleanupListener] Lỗi khi dọn dẹp suất chiếu: " + t.getMessage());
            }
        }, 30, 600, TimeUnit.SECONDS);
        */
        System.out.println("[ShowtimeCleanupListener] Khởi tạo hệ thống quản trị suất chiếu thành công.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            System.out.println("[ShowtimeCleanupListener] Đã dừng tiến trình dọn dẹp suất chiếu.");
        }
    }
}
