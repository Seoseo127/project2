package controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

@WebServlet("/GetPostIdByReportIdController")
public class GetPostIdByReportIdController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String reportIdStr = req.getParameter("reportId");
        resp.setContentType("application/json;charset=UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{");

        if (reportIdStr == null) {
            json.append("\"postId\": null");
            json.append("}");
            resp.getWriter().write(json.toString());
            return;
        }

        int reportId = Integer.parseInt(reportIdStr);
        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();

        try (SqlSession sqlSession = factory.openSession()) {
            String postId = sqlSession.selectOne("reportMapper.getPostIdByReportId", reportId);
            if (postId == null) {
                postId = sqlSession.selectOne("reportMapper.getTargetIdByReportId", reportId);
            }
            if (postId != null) {
                json.append("\"postId\": \"").append(postId).append("\"");
            } else {
                json.append("\"postId\": null");
            }
            json.append("}");
            resp.getWriter().write(json.toString());
        }
    }
}
