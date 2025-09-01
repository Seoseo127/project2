package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.ReportDTO;
import model.dto.UserDTO;
import util.DBConnection;

@WebServlet("/AdminReportProcessController")
public class AdminReportProcessController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 로그인 및 관리자 권한 체크
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=needAdmin");
            return;
        }

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession sqlSession = factory.openSession()) {
            List<ReportDTO> pendingReports = sqlSession.selectList("reportMapper.getPendingReports");
            request.setAttribute("reportList", pendingReports);
            request.getRequestDispatcher("/admin/report_list.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportIdStr = request.getParameter("reportId");
        String action = request.getParameter("action");

        if (reportIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/AdminReportProcessController");
            return;
        }

        int reportId = Integer.parseInt(reportIdStr);

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession session = factory.openSession(true)) {
            // 신고 상태 업데이트
            Map<String, Object> param = new HashMap<>();
            param.put("reportId", reportId);
            param.put("status", action.equals("approve") ? "승인" : "거부");
            session.update("reportMapper.updateReportStatus", param);

            if (action.equals("approve")) {
                // 신고 대상자 조회
                String targetUserId = session.selectOne("reportMapper.getTargetUserIdByReportId", reportId);

                // 승인된 신고 누적 개수 확인
                int approvedCount = session.selectOne("reportMapper.countApprovedReportsByUser", targetUserId);
                
                    if (approvedCount >= 3) {
                        Calendar cal = Calendar.getInstance();
                        cal.add(Calendar.DATE, 3);
                        java.sql.Date suspendUntil = new java.sql.Date(cal.getTimeInMillis());
                        Map<String, Object> suspendParam = new HashMap<>();
                        suspendParam.put("userId", targetUserId);
                        suspendParam.put("until", suspendUntil);
                        session.update("user.suspendUser", suspendParam);
                    }
                }

        }
        // 처리 후 처리된 신고 목록 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/AdminReportProcessListController");
    }
}
