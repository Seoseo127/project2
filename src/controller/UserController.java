package controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.CommentDTO;
import model.dto.PostDTO;
import model.dto.UserDTO;
import service.CommentService;
import service.PostService;
import service.UserService;

@WebServlet("/user/*")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/logout".equals(path)) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
            return;
        }

        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=needLogin");
            return;
        }

        String userId = loginUser.getUserId();
        PostService postService = new PostService();
        CommentService commentService = new CommentService();

        int postCount = postService.getMyPostCount(userId);
        int commentCount = commentService.getMyCommentCount(userId);
        int scrapCount = postService.getMyScrapCount(userId);

        req.setAttribute("postCount", postCount);
        req.setAttribute("commentCount", commentCount);
        req.setAttribute("scrapCount", scrapCount);

        req.getRequestDispatcher("/mypage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String action = req.getParameter("action");
        if (action != null) {
            handleAction(req, resp, action);
            return;
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line);
        String body = sb.toString();

        UserService service = new UserService();
        PrintWriter out = resp.getWriter();
        String uri = req.getRequestURI();

        if (uri.endsWith("/signup")) handleSignup(body, service, out);
        else if (uri.endsWith("/login")) handleLogin(req, body, service, out);
        else if (uri.endsWith("/findpw")) handleFindPw(body, service, out);
        else if (uri.endsWith("/checkpw")) handleCheckPw(req, body, out);
        else if (uri.endsWith("/update")) handleUpdate(req, body, service, out);
        else if (uri.endsWith("/delete")) handleDelete(req, body, service, out);
        else if (uri.endsWith("/logout")) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
        }
    }

    private void handleLogin(HttpServletRequest req, String body, UserService service, PrintWriter out) {
        String userId = extractValue(body, "userId");
        String password = extractValue(body, "password");
        UserDTO loginUser = service.login(userId, password);

        if (loginUser != null) {
            Date now = new Date();
            Date suspendedUntil = loginUser.getSuspendedUntil();

            if (suspendedUntil != null && suspendedUntil.after(now)) {
                // 로그인 제한 처리
                String json = String.format(
                    "{\"success\": false, \"message\": \"해당 계정은 %tF까지 정지되어 로그인할 수 없습니다.\"}",
                    suspendedUntil
                );
                out.print(json);
                return;
            }

            HttpSession session = req.getSession();
            session.setAttribute("loginUser", loginUser);
            session.setAttribute("userId", loginUser.getUserId());

            String role = "관리자".equals(loginUser.getUserGrade()) ? "admin" : "user";
            String json = String.format("{\"success\": true, \"userName\": \"%s\", \"role\": \"%s\"}",
                    loginUser.getUserName(), role);
            out.print(json);
        } else {
            out.print("{\"success\": false, \"message\": \"아이디 또는 비밀번호가 틀렸습니다.\"}");
        }
    }

    private void handleSignup(String body, UserService service, PrintWriter out) {
        String userId = extractValue(body, "userId");
        String password = extractValue(body, "password");
        String nickname = extractValue(body, "nickname");
        String email = extractValue(body, "email");
        String userName = extractValue(body, "userName");
        String userGrade = extractValue(body, "userGrade");

        UserDTO dto = new UserDTO(userId, password, nickname, email, userName, userGrade, null, null);
        boolean result = service.signup(dto);
        String json = String.format("{\"success\": %s, \"message\": \"%s\"}", result, result ? "회원가입 성공" : "회원가입 실패");
        out.print(json);
    }

    private void handleFindPw(String body, UserService service, PrintWriter out) {
        String userId = extractValue(body, "userId");
        String email = extractValue(body, "email");
        String pw = service.findPassword(userId, email);
        String json = pw != null
            ? String.format("{\"success\": true, \"message\": \"비밀번호는 %s 입니다.\"}", pw)
            : "{\"success\": false, \"message\": \"일치하는 회원 정보가 없습니다.\"}";
        out.print(json);
    }

    private void handleCheckPw(HttpServletRequest req, String body, PrintWriter out) {
        String password = extractValue(body, "password");
        UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
        boolean result = loginUser != null && loginUser.getPassword().equals(password);
        if (result) req.getSession().setAttribute("checkPassed", true);
        out.print(String.format("{\"success\": %s}", result));
    }

    private void handleUpdate(HttpServletRequest req, String body, UserService service, PrintWriter out) {
        String userId = extractValue(body, "userId");
        String password = extractValue(body, "password");
        String nickname = extractValue(body, "nickname");

        UserDTO dto = new UserDTO(userId, password, nickname, null, null, null, null, null);
        boolean result = service.updateUser(dto);
        if (result) {
            UserDTO updatedUser = service.login(userId, password);
            req.getSession().setAttribute("loginUser", updatedUser);
            req.getSession().removeAttribute("checkPassed");
        }
        String json = String.format("{\"success\": %s, \"message\": \"%s\"}", result, result ? "수정 완료" : "수정 실패");
        out.print(json);
    }

    private void handleDelete(HttpServletRequest req, String body, UserService service, PrintWriter out) {
        String userId = extractValue(body, "userId");
        boolean result = service.deleteUser(userId);
        if (result) req.getSession().invalidate();
        String json = String.format("{\"success\": %s, \"message\": \"%s\"}", result, result ? "회원 탈퇴 완료" : "탈퇴 실패");
        out.print(json);
    }

    private void handleAction(HttpServletRequest req, HttpServletResponse resp, String action) throws ServletException, IOException {
        HttpSession session = req.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=needLogin");
            return;
        }

        String userId = loginUser.getUserId();
        PostService postService = new PostService();
        CommentService commentService = new CommentService();

        if ("getMyPosts".equals(action)) {
            int page = 1, limit = 4;
            try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
            int offset = (page - 1) * limit;
            int total = postService.getMyPostCount(userId);
            int totalPages = (int) Math.ceil((double) total / limit);

            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("offset", offset);
            map.put("limit", limit);

            List<PostDTO> list = postService.getMyPostsPaging(map);
            req.setAttribute("postList", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("/my_post_list.jsp").forward(req, resp);
        } else if ("getMyComments".equals(action)) {
            int page = 1, limit = 4;
            try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
            int offset = (page - 1) * limit;
            int total = commentService.getMyCommentCount(userId);
            int totalPages = (int) Math.ceil((double) total / limit);

            List<CommentDTO> list = commentService.getMyCommentsWithPaging(userId, offset, limit);
            req.setAttribute("commentList", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("/my_comment_list.jsp").forward(req, resp);
        } else if ("getMyScraps".equals(action)) {
            int page = 1, size = 5;
            try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
            int offset = (page - 1) * size;

            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("offset", offset);
            map.put("limit", size);

            List<PostDTO> list = postService.getMyScrapPostsPaging(map);
            int total = postService.getMyScrapCount(userId);
            int totalPages = (int) Math.ceil((double) total / size);

            req.setAttribute("scrapList", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("/my_scrap_list_partial.jsp").forward(req, resp);
        }
    }

    private String extractValue(String json, String key) {
        String target = "\"" + key + "\":";
        int start = json.indexOf(target);
        if (start == -1) return null;
        int valueStart = json.indexOf("\"", start + target.length()) + 1;
        int valueEnd = json.indexOf("\"", valueStart);
        return json.substring(valueStart, valueEnd);
    }
}
