package controller.community;

import service.NotificationService;
import service.PostService;
import websocket.NotificationWebSocket;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import model.dto.NotificationDTO;
import model.dto.PostDTO;
import model.dto.UserDTO;




@WebServlet("/likePost")
public class LikePostController extends HttpServlet {
    private final PostService postService = new PostService();

    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int postId = Integer.parseInt(request.getParameter("postId"));

        // 좋아요 상태 확인 및 토글 처리
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("userId", userId);

        int hasLiked = postService.hasLiked(param);
        if (hasLiked == 1) {
            postService.unlikePost(postId, userId); // 좋아요 취소
        } else {
            postService.likePost(postId, userId); // 좋아요 등록
        }

        // ✅ 알림 보낼 게시글 정보 가져오기
        PostDTO post = postService.getPostById(postId);
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser"); // 세션에서 로그인 객체 가져오기

        // 좋아요 알림 보내기 (본인이 누른 경우 제외)
        if (post != null && !userId.equals(post.getUserId())) {
            String nickname = loginUser.getNickname();

            // 1. DB에 알림 저장
            NotificationDTO noti = new NotificationDTO();
            noti.setUserId(post.getUserId());  // 글쓴이에게 알림
            noti.setPostId(postId);
            noti.setType("좋아요");
            noti.setMessage(nickname + "님이 내 글을 좋아했습니다.");
            new NotificationService().addNotification(noti);

            // 2. 실시간 웹소켓 알림 전송
            NotificationWebSocket.sendNotification(
                post.getUserId(),
                nickname + "님이 내 글을 좋아했습니다."
            );
        }

        // 최신 hasLiked 상태 반영을 위해 redirect 후 ViewPostController에서 다시 조회됨
        response.sendRedirect("ViewPostController?postId=" + postId + "&noCount=true");

        System.out.println("좋아요 알림 대상: " + post.getUserId());
        System.out.println("좋아요 누른 사람: " + userId);
    }
}





