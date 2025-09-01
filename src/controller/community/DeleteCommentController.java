package controller.community;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import service.CommentService;

@WebServlet("/deleteComment")
public class DeleteCommentController extends HttpServlet {

    private final CommentService commentService = new CommentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        int postId = Integer.parseInt(request.getParameter("postId")); // 돌아갈 글

        commentService.deleteComment(commentId);

        response.sendRedirect("ViewPostController?postId=" + postId);
    }
}
