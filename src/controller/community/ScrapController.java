package controller.community;

import model.dto.UserDTO;
import model.dto.PostDTO;
import service.PostService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/scrap")
public class ScrapController extends HttpServlet {
    private final PostService postService = new PostService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        // 로그인 확인
        if (loginUser == null) {
            sendJson(resp, "{\"success\": false, \"message\": \"로그인이 필요합니다.\"}", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String postIdStr = req.getParameter("postId");
        String addStr = req.getParameter("add");

        // 파라미터 누락 검사
        if (postIdStr == null || addStr == null) {
            sendJson(resp, "{\"success\": false, \"message\": \"파라미터가 누락되었습니다.\"}", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            boolean add = Boolean.parseBoolean(addStr);

            Map<String, Object> param = new HashMap<>();
            param.put("userId", loginUser.getUserId());
            param.put("postId", postId);

            boolean scrapped;

            if (add) {
                System.out.println("스크랩 추가 요청: " + loginUser.getUserId() + ", postId=" + postId);
                postService.scrapPost(param);
                scrapped = true;
            } else {
                System.out.println("스크랩 취소 요청: " + loginUser.getUserId() + ", postId=" + postId);
                postService.unscrapPost(param);
                scrapped = false;
            }

            String json = String.format(
                "{\"success\": true, \"scrapped\": %s, \"message\": \"%s\"}",
                scrapped, scrapped ? "스크랩 완료" : "스크랩 취소됨"
            );
            sendJson(resp, json, HttpServletResponse.SC_OK);

        } catch (NumberFormatException e) {
            System.err.println("postId 파싱 오류: " + postIdStr);
            sendJson(resp, "{\"success\": false, \"message\": \"postId가 유효하지 않습니다.\"}", HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(resp, "{\"success\": false, \"message\": \"스크랩 처리 중 오류가 발생했습니다.\"}", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<PostDTO> scrapList = postService.getMyScrapPosts(loginUser.getUserId());
        req.setAttribute("scrapList", scrapList);
        req.getRequestDispatcher("my_scrap_list.jsp").forward(req, resp);
    }

    // ✅ JSON 출력 메서드
    private void sendJson(HttpServletResponse resp, String json, int statusCode) throws IOException {
        resp.setStatus(statusCode);
        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.write(json);
        out.flush();
        out.close();
    }
}
