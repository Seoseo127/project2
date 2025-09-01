package controller.study;

import service.StudyGroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteGroup")
public class DeleteGroupController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String leaderId = (String) session.getAttribute("userId"); // ✅ 세션에서 로그인된 유저 ID

        int groupId = Integer.parseInt(request.getParameter("groupId"));

        boolean success = studyService.deleteGroupByLeader(groupId, leaderId); // ✅ 전달

        if (success) {
            response.sendRedirect(request.getContextPath() + "/allGroups?deleted=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId + "&deleted=false");
        }
    }
}
