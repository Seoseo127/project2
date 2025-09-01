package controller.study;

import service.StudyGroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/leaveGroup")
public class LeaveGroupController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int groupId = Integer.parseInt(request.getParameter("groupId"));
        String userId = (String) request.getSession().getAttribute("userId");

        boolean success = studyService.leaveGroup(groupId, userId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/allGroups?left=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId + "&left=false");
        }
    }
}
