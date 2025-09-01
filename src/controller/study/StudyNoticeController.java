package controller.study;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dto.StudyNoticeDTO;
import model.dto.StudyGroupDTO;
import model.dto.UserDTO;
import org.apache.ibatis.session.SqlSession;
import util.MybatisUtil;

@WebServlet("/notice")
public class StudyNoticeController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int groupId = Integer.parseInt(request.getParameter("groupId"));

        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {

            // 스터디 정보 가져오기
            StudyGroupDTO group = sqlSession.selectOne("model.dao.StudyGroupMapper.getGroupById", groupId);
            boolean isLeader = group.getLeaderId().equals(loginUser.getUserId());

            if (!isLeader) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "스터디장만 가능합니다.");
                return;
            }

            if ("insert".equals(action)) {
                StudyNoticeDTO dto = new StudyNoticeDTO();
                dto.setGroupId(groupId);
                dto.setTitle(request.getParameter("title"));
                dto.setLocation(request.getParameter("location"));
                dto.setContent(request.getParameter("content"));
                dto.setCreatedBy(loginUser.getUserId());

                sqlSession.insert("model.dao.StudyGroupMapper.insertNotice", dto);

            } else if ("update".equals(action)) {
                StudyNoticeDTO dto = new StudyNoticeDTO();
                dto.setNoticeId(Integer.parseInt(request.getParameter("noticeId")));
                dto.setTitle(request.getParameter("title"));
                dto.setLocation(request.getParameter("location"));
                dto.setContent(request.getParameter("content"));
                dto.setCreatedBy(loginUser.getUserId());

                sqlSession.update("model.dao.StudyGroupMapper.updateNotice", dto);

            } else if ("delete".equals(action)) {
                StudyNoticeDTO dto = new StudyNoticeDTO();
                dto.setNoticeId(Integer.parseInt(request.getParameter("noticeId")));
                dto.setCreatedBy(loginUser.getUserId());

                sqlSession.delete("model.dao.StudyGroupMapper.deleteNotice", dto);
            }

            sqlSession.commit();
            response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId);
        }
    }
}
