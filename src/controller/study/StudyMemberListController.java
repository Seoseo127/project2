// StudyMemberListController.java
package controller.study;

import model.dto.StudyGroupDTO;
import service.StudyGroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/myGroups")
public class StudyMemberListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
      
        List<StudyGroupDTO> myGroups = studyService.getGroupsJoinedByUser(userId);
        request.setAttribute("groups", myGroups);
        request.getRequestDispatcher("/study_member_list.jsp").forward(request, response);
    }
}
