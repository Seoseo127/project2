package controller.community;

import service.PostService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/deletePost.do")
public class DeletePostController extends HttpServlet {
    private final PostService postService = new PostService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int postId = Integer.parseInt(request.getParameter("postId"));
        String userId = (String) request.getSession().getAttribute("userId");

        // 댓글 → 게시글 삭제는 PostService에서 처리
        postService.deletePostWithComments(postId);

        response.sendRedirect("CommunityListController?category=all&keyword=");
    }
}
