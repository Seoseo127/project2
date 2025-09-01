package controller.study;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.dto.StudyCommentDTO;
import org.apache.ibatis.session.SqlSession;
import util.MybatisUtil;

@WebServlet("/comment")
public class StudyCommentController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        // ✅ 한글 깨짐 방지
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int groupId = Integer.parseInt(request.getParameter("groupId"));
        String userId = (String) request.getSession().getAttribute("userId");

        SqlSession sqlSession = MybatisUtil.getSqlSession();

        // 스터디 가입 여부 확인
        Map<String, Object> param = new HashMap<>();
        param.put("groupId", groupId);
        param.put("userId", userId);

        boolean isMember = sqlSession.selectOne("model.dao.StudyGroupMapper.selectMember", param) != null;

        if (!isMember) {
            sqlSession.close();
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "스터디에 가입한 사용자만 댓글 작성이 가능합니다.");
            return;
        }

        if ("insert".equals(action)) {
            StudyCommentDTO comment = new StudyCommentDTO();
            comment.setGroupId(groupId);
            comment.setUserId(userId);
            comment.setContent(request.getParameter("content"));

            sqlSession.insert("model.dao.StudyGroupMapper.insertComment", comment);

        } else if ("update".equals(action)) {
            StudyCommentDTO dto = new StudyCommentDTO();
            dto.setCommentId(Integer.parseInt(request.getParameter("commentId")));
            dto.setUserId(userId);
            dto.setContent(request.getParameter("content"));

            sqlSession.update("model.dao.StudyGroupMapper.updateComment", dto);

        } else if ("delete".equals(action)) {
            StudyCommentDTO dto = new StudyCommentDTO();
            dto.setCommentId(Integer.parseInt(request.getParameter("commentId")));
            dto.setUserId(userId);

            sqlSession.delete("model.dao.StudyGroupMapper.deleteComment", dto);
        }
        
        sqlSession.commit();
        sqlSession.close();
        response.sendRedirect(request.getContextPath() + "/studyDetail?groupId=" + groupId + "&updated=success");

    }
    
    
    
}


