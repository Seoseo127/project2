package controller.study;

import model.dto.StudyGroupDTO;
import service.StudyGroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateDuration")
public class UpdateDurationController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int groupId = Integer.parseInt(request.getParameter("groupId"));
        int duration = Integer.parseInt(request.getParameter("duration"));

        StudyGroupDTO dto = new StudyGroupDTO();
        dto.setGroupId(groupId);
        dto.setDuration(duration);

        boolean success = studyService.updateDuration(dto);

        String redirectUrl = request.getContextPath() + "/studyDetail?groupId=" + groupId;
        if (success) {
            response.sendRedirect(redirectUrl + "&durationUpdate=true");
        } else {
            response.sendRedirect(redirectUrl + "&durationUpdate=false");
        }
    }
}
