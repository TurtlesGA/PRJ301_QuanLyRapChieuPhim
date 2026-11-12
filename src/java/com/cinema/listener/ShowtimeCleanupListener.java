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

        // Delay 30 seconds after server startup, then run every 10 minutes in the background
        scheduler.scheduleWithFixedDelay(() -> {
            try {
                showtimeDAO.deleteExpiredShowtimes();
            } catch (Throwable t) {
                System.err.println("[ShowtimeCleanupListener] Lỗi khi dọn dẹp suất chiếu: " + t.getMessage());
            }
        }, 30, 600, TimeUnit.SECONDS);

        System.out.println("[ShowtimeCleanupListener] Đã kích hoạt cơ chế tự động dọn dẹp suất chiếu hết hạn định kỳ.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            System.out.println("[ShowtimeCleanupListener] Đã dừng tiến trình dọn dẹp suất chiếu.");
        }
    }
}
