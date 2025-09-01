package controller.admin;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import util.DBConnection;

@WebServlet("/ResuspendUserController")
public class ResuspendUserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("userId");
        if (userId == null || userId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/SuspendedUserListController");
            return;
        }

        // 현재 날짜로부터 3일 후 날짜 계산
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, 3);
        java.util.Date utilDate = cal.getTime();
        java.sql.Date suspendUntil = new java.sql.Date(utilDate.getTime());

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession session = factory.openSession(true)) {
            Map<String, Object> param = new HashMap<>();
            param.put("userId", userId);
            param.put("until", suspendUntil);
            
            System.out.println("Suspend userId: " + userId + ", until: " + suspendUntil);


            session.update("user.suspendUser", param);
        }

        // 재정지 후 정지 회원 목록 페이지로 이동
        response.sendRedirect(request.getContextPath() + "/SuspendedUserListController");
    }
}
