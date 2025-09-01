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

@WebServlet("/AdminReportProcessListController")
public class AdminReportProcessListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 로그인 및 관리자 권한 체크
        HttpSession session = req.getSession();
        model.dto.UserDTO loginUser = (model.dto.UserDTO) session.getAttribute("loginUser");

        if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=needAdmin");
            return;
        }

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession sqlSession = factory.openSession()) {
            var approvedReports = sqlSession.selectList("reportMapper.getProcessedReports");
            req.setAttribute("approvedReports", approvedReports);
            req.getRequestDispatcher("/admin/report_process_list.jsp").forward(req, resp);
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
                // 신고 대상자 아이디 조회
                String targetUserId = session.selectOne("reportMapper.getTargetUserIdByReportId", reportId);

                // 해당 사용자의 승인된 신고 누적 개수 확인
                int approvedCount = session.selectOne("reportMapper.countApprovedReportsByUser", targetUserId);

                // 3회 이상이면 3일 정지 처리
                if (approvedCount >= 3) {
                    Calendar cal = Calendar.getInstance();
                    cal.add(Calendar.DATE, 3);
                    java.util.Date utilDate = cal.getTime();
                    java.sql.Date suspendUntil = new java.sql.Date(utilDate.getTime());

                    Map<String, Object> suspendParam = new HashMap<>();
                    suspendParam.put("userId", targetUserId);
                    suspendParam.put("until", suspendUntil);

                    session.update("user.suspendUser", suspendParam);
                }
            }
        }
        // 처리 완료 후 신고 처리 목록 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/AdminReportProcessListController");
    }
}
