
package controller.community;

import model.dto.CommentDTO;
import model.dto.UserDTO;
import service.CommentService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateComment")
public class UpdateCommentController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        Object loginUser = session.getAttribute("loginUser");
        if (loginUser == null) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            response.sendRedirect("ViewPostController?postId=" + postId);
            return;
        }

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        int postId = Integer.parseInt(request.getParameter("postId"));
        String newContent = request.getParameter("cContent");

        CommentDTO comment = new CommentDTO();
        comment.setCommentId(commentId);
        comment.setcContent(newContent);

        new CommentService().updateComment(comment);

        response.sendRedirect("ViewPostController?postId=" + postId);
    }
}
