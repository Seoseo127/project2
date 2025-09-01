package controller.study;

import java.io.IOException;
import java.util.List;
import org.apache.ibatis.session.SqlSession;
import util.MybatisUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.dto.StudyCommentDTO;
import model.dto.StudyGroupDTO;
import model.dto.StudyMemberDTO;
import model.dto.StudyNoticeDTO;
import service.StudyGroupService;

@WebServlet("/studyDetail")
public class StudyDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudyGroupService studyService = new StudyGroupService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	String groupIdStr = request.getParameter("groupId");
    	if (groupIdStr == null || !groupIdStr.matches("\\d+")) {
    	    response.sendRedirect(request.getContextPath() + "/allGroups");
    	    return;
    	}

    	int groupId = Integer.parseInt(groupIdStr);

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        StudyGroupDTO group = studyService.getGroupById(groupId);
        List<StudyMemberDTO> members = studyService.getAllMembers(groupId);
        request.setAttribute("createdAt", group.getCreatedAt());

        boolean isJoined = members.stream().anyMatch(m -> m.getUserId().equals(userId));
        boolean isLeader = group.getLeaderId().equals(userId);

        request.setAttribute("group", group);
        request.setAttribute("members", members);
        request.setAttribute("isJoined", isJoined);
        request.setAttribute("isLeader", isLeader);
        
     // ✅ 여기 추가
        String editCommentId = request.getParameter("editCommentId");
        request.setAttribute("editCommentId", editCommentId);
        
        // ✅ 공지사항 + 댓글 조회 (namespace는 model.dao.StudyGroupMapper 기준)
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            List<StudyNoticeDTO> notices = sqlSession.selectList("model.dao.StudyGroupMapper.getNotices", groupId);
            request.setAttribute("notices", notices);

            List<StudyCommentDTO> comments = sqlSession.selectList("model.dao.StudyGroupMapper.getComments", groupId);
            request.setAttribute("comments", comments);
        }

        request.getRequestDispatcher("/study_detail.jsp").forward(request, response);
    }
}
    
    



