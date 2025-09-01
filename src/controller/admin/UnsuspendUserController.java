package controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.UserDTO;
import util.DBConnection;

@WebServlet("/UnsuspendUserController")
public class UnsuspendUserController extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
        if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=needAdmin");
            return;
        }

        String userId = req.getParameter("userId");
        if (userId == null || userId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/AdminSuspendUserController");
            return;
        }

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession session = factory.openSession(true)) {
            // 1. 유저 정지 해제
            session.update("user.unsuspendUser", userId);

            // 2. 해당 유저의 게시글 신고 중 3회 이상 승인된 항목을 '완료'로 변경
            session.update("reportMapper.markReportsCompleteByUserId", userId);
        }

        resp.sendRedirect(req.getContextPath() + "/AdminSuspendUserController");
    }
}
