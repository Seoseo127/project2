package controller.study;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.StudyGroupDTO;
import util.DBConnection;

@WebServlet("/study/create")
public class StudyGroupController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private SqlSessionFactory sqlSessionFactory;

	@Override
	public void init() throws ServletException {
		sqlSessionFactory = DBConnection.getSqlSessionFactory();
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String name = request.getParameter("name");
		String leaderId = request.getParameter("leaderId");
		int duration = Integer.parseInt(request.getParameter("duration"));
		String description = request.getParameter("description");
		int maxMember = Integer.parseInt(request.getParameter("maxMember"));

		StudyGroupDTO dto = new StudyGroupDTO();
		dto.setName(name);
		dto.setLeaderId(leaderId);
		dto.setDuration(duration);
		dto.setDescription(description);
		dto.setMaxMember(maxMember);

		try (SqlSession session = sqlSessionFactory.openSession()) {
			int result = session.insert("model.dao.StudyGroupMapper.insertStudyGroup", dto);
			session.commit();

			if (result > 0) {
				response.sendRedirect(request.getContextPath() + "/allGroups");
			} else {
				response.sendRedirect(request.getContextPath() + "/study_create.jsp");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/study_create.jsp");
		}
	}
}
