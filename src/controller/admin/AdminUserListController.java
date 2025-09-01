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

@WebServlet("/AdminUserListController")
public class AdminUserListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 세션 검사: 로그인 + 관리자 확인
		HttpSession session = request.getSession();
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

		if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
			response.sendRedirect(request.getContextPath() + "/login.jsp?msg=needAdmin");
			return;
		}

		// MyBatis SqlSession 사용
		SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
		try (SqlSession sqlSession = factory.openSession()) {
			List<UserDTO> userList = sqlSession.selectList("user.getAllUsers");

			request.setAttribute("userList", userList);
			request.getRequestDispatcher("/admin/user_list.jsp").forward(request, response);
		}
	}
}
