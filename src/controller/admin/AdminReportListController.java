package controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.ReportDTO;
import model.dto.UserDTO;
import util.DBConnection;

@WebServlet("/AdminReportListController")
public class AdminReportListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 로그인 및 관리자 권한 체크
        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=needAdmin");
            return;
        }

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession sqlSession = factory.openSession()) {
            List<ReportDTO> pendingReports = sqlSession.selectList("reportMapper.getPendingReports");
            req.setAttribute("reportList", pendingReports);
            req.getRequestDispatcher("/admin/report_list.jsp").forward(req, resp);
        }
    }
}
