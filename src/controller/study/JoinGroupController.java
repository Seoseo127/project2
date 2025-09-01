package controller.study;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.StudyMemberDTO;
import service.StudyGroupService;

@WebServlet("/joinGroup")
public class JoinGroupController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        int groupId = Integer.parseInt(request.getParameter("groupId"));

        StudyMemberDTO dto = new StudyMemberDTO();
        dto.setGroupId(groupId);
        dto.setUserId(userId);

        try {
            boolean success = studyService.joinGroup(dto);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId + "&joined=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId + "&joined=false");
            }
        } catch (RuntimeException e) {
            response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId + "&error=full");
        }
    }
}
