package controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.UserDTO;
import model.dto.ReportDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

@WebServlet("/AdminUserDetailController")
public class AdminUserDetailController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String userId = request.getParameter("userId");
	    if (userId == null || userId.trim().equals("")) {
	        response.sendRedirect("AdminUserListController");
	        return;
	    }

	    SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
	    try (SqlSession sqlSession = factory.openSession()) {

	        UserDTO user = sqlSession.selectOne("user.getUserById", userId);

	        // ✅ 승인된 신고 목록만 조회
	        List<ReportDTO> reportList = sqlSession.selectList("reportMapper.getApprovedReportsByUserId", userId);

	        // ✅ 승인된 신고 중 3회 이상인 글/댓글만 조회
	        List<Map<String, Object>> duplicateReportedTargets = sqlSession.selectList("reportMapper.getDuplicateReportedTargets", userId);

	        request.setAttribute("user", user);
	        request.setAttribute("reportList", reportList);
	        request.setAttribute("duplicateReportedTargets", duplicateReportedTargets);

	        request.getRequestDispatcher("/admin/user_detail.jsp").forward(request, response);
	    }
	}
}
