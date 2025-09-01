package controller.community;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.dto.NotificationDTO;
import service.NotificationService;

@WebServlet("/NotificationController")
public class NotificationController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = (String) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        NotificationService service = new NotificationService();
//        service.markAllAsRead(userId); // ✅ 알림 모두 읽음 처리

        List<NotificationDTO> list = service.getNotificationsByUser(userId);
        int unreadCount = service.getUnreadCount(userId); // ✅ 안 읽은 알림 수 가져오기

        request.setAttribute("notifications", list);
        request.setAttribute("notiCount", unreadCount); // ✅ 뱃지 출력을 위한 값 전달

        request.getRequestDispatcher("Notification.jsp").forward(request, response);
    }
}
