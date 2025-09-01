package controller.community;

import service.NotificationService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteNotification")
public class DeleteNotificationController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int notiId = Integer.parseInt(request.getParameter("notiId"));
        new NotificationService().deleteNotification(notiId);

        response.sendRedirect("NotificationController");
    }
}
