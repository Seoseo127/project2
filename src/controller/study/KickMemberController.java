package controller.study;

import service.StudyGroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/kickMember")
public class KickMemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int groupId = Integer.parseInt(request.getParameter("groupId"));
        String targetUserId = request.getParameter("targetUserId");

        boolean success = studyService.kickMember(groupId, targetUserId);

        String redirectUrl = request.getContextPath() + "/studyDetail?groupId=" + groupId + "&kicked=" + (success ? "true" : "false");
        response.sendRedirect(redirectUrl);  // ✅ 여기에 꼭 추가!
    }
}

