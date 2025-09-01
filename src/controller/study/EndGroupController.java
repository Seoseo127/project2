package controller.study;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.StudyGroupDTO;
import service.StudyGroupService;

@WebServlet("/endGroup")
public class EndGroupController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int groupId = Integer.parseInt(request.getParameter("groupId"));

        StudyGroupDTO dto = new StudyGroupDTO();
        dto.setGroupId(groupId);
        dto.setDuration(0); // 0일로 설정해서 종료 처리

        boolean success = studyService.updateDuration(dto);

        String redirectUrl = request.getContextPath() + "/studyDetail?groupId=" + groupId;

        if (success) {
            response.sendRedirect(redirectUrl + "&ended=true");
        } else {
            response.sendRedirect(redirectUrl + "&ended=false");
        }
    }
}
