package controller.community;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.PostDTO;
import util.DBConnection;

@WebServlet("/editPostForm.do")
public class UpdatePostFormController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int postId = Integer.parseInt(request.getParameter("postId"));
        String sessionUserId = (String) request.getSession().getAttribute("userId");

        SqlSessionFactory factory = DBConnection.getFactory();
        try (SqlSession session = factory.openSession()) {
            PostDTO post = session.selectOne("communityMapper.getPostById", postId);

            if (post != null && sessionUserId != null && sessionUserId.equals(post.getUserId())) {
                request.setAttribute("post", post);
                request.getRequestDispatcher("editPostForm.jsp").forward(request, response);
            } else {
                response.sendRedirect("community.do");
            }
        }
    }
}

