
// StudyAllListController.java (전체 수정된 코드)
package controller.study;

import model.dto.StudyGroupDTO;
import service.StudyGroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/allGroups")
public class StudyAllListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // ✅ request 선언 O
        String keyword = request.getParameter("keyword");
        List<StudyGroupDTO> groups;

        if (keyword != null && !keyword.trim().isEmpty()) {
            groups = studyService.searchStudyGroups(keyword);
        } else {
            groups = studyService.getAllGroups();
        }

        request.setAttribute("groups", groups);
        request.setAttribute("keyword", keyword); 
        
        // ✅ 삭제 성공 알림 메시지
        if ("true".equals(request.getParameter("deleted"))) {
            request.setAttribute("message", "스터디가 성공적으로 삭제되었습니다.");
        }

        // ✅ 내가 만든/가입한 스터디 목록 세팅
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

     // ✅ 내 스터디 참여/생성 목록 추가
        request.setAttribute("groupsLedByMe", studyService.getGroupsLedByUser(userId));
        request.setAttribute("groupsJoinedByMe", studyService.getGroupsJoinedByUser(userId));

        request.getRequestDispatcher("/study_main.jsp").forward(request, response);
    }
}