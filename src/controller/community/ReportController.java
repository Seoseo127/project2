package controller.community;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.UserDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

@WebServlet("/ReportController")
public class ReportController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");

		String targetType = req.getParameter("targetType"); // post or comment
		String reason = req.getParameter("reason");
		String targetIdStr = req.getParameter("targetId");

		HttpSession session = req.getSession();
		UserDTO reporter = (UserDTO) session.getAttribute("loginUser");

		if (reporter == null || targetType == null || targetIdStr == null || reason == null) {
			resp.sendRedirect("login.jsp");
			return;
		}
		
		

		int targetId = Integer.parseInt(targetIdStr);
		String reporterId = reporter.getUserId();

		HashMap<String, Object> param = new HashMap<>();
		param.put("targetId", targetId);
		param.put("targetType", targetType);
		param.put("reason", reason);

		param.put("reporterId", reporterId);
		param.put("createdAt", new Date());



		SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
		try (SqlSession sqlSession = factory.openSession(true)) {
			sqlSession.insert("reportMapper.insertReport", param);
		}

		// 신고 후 원래 페이지로 이동
		resp.sendRedirect(req.getContextPath() + "/CommunityListController");
		


	}
}
