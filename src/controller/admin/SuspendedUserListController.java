package controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.UserDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

@WebServlet("/SuspendedUserListController")
public class SuspendedUserListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=needAdmin");
            return;
        }

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession sqlSession = factory.openSession()) {

            // 1. 정지 처리: 승인 신고 3회 이상인 사용자 → 정지
            int updatedSuspend = sqlSession.update("reportMapper.suspendUsersWithThreeOrMoreReports");
            System.out.println("정지 처리된 사용자 수: " + updatedSuspend);

            // 2. 오늘 정지 해제 처리: SUSPENDED_UNTIL = SYSDATE → NULL로 변경
            int updatedUnsuspend = sqlSession.update("reportMapper.unsuspendUsersOnExpiry");
            System.out.println("정지 해제된 사용자 수: " + updatedUnsuspend);

            // 3. 오늘 정지 해제된 사용자들의 신고 상태 '완료' 처리
            List<String> unsuspendedUserIds = sqlSession.selectList("user.getUsersUnsuspendedToday");
            for (String userId : unsuspendedUserIds) {
                int updatedReports = sqlSession.update("reportMapper.markReportsCompleteByUserId", userId);
                System.out.println("유저 " + userId + "의 완료 처리된 신고 수: " + updatedReports);
            }

            // 커밋은 한 번만
            sqlSession.commit();

            // 정지된 사용자 목록
            List<UserDTO> suspendedList = sqlSession.selectList("user.getSuspendedUsers");

            // 신고 누적 사용자 목록
            List<UserDTO> reportedList = sqlSession.selectList("reportMapper.getUsersWithThreeOrMoreApprovedReports");

            request.setAttribute("suspendedUsers", suspendedList);
            request.setAttribute("reportedUsers", reportedList);

            request.getRequestDispatcher("admin/suspended_user_list.jsp").forward(request, response);
        }
    }
}
