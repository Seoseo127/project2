<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.dto.StudyNoticeDTO, model.dto.UserDTO" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="util.MybatisUtil" %>

<%
    int noticeId = Integer.parseInt(request.getParameter("noticeId"));
    int groupId = Integer.parseInt(request.getParameter("groupId"));

    SqlSession sqlSession = MybatisUtil.getSqlSession();
    StudyNoticeDTO notice = sqlSession.selectOne("model.dao.StudyGroupMapper.getNoticeById", noticeId);
    sqlSession.close();
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>공지사항 수정</title>
  <style>
    .form-container {
        max-width: 700px;
        margin: 40px auto;
        padding: 30px;
        background: #f9f9f9;
        border-radius: 12px;
        font-family: sans-serif;
    }
    input, textarea {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
    }
    button {
        padding: 10px 20px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
    }
    button:hover {
        background-color: #2980b9;
    }
  </style>
</head>
<body>

<div class="form-container">
  <h2>공지사항 수정</h2>
  <form action="${pageContext.request.contextPath}/notice" method="post">
    <input type="hidden" name="action" value="update" />
    <input type="hidden" name="noticeId" value="<%= notice.getNoticeId() %>" />
    <input type="hidden" name="groupId" value="<%= notice.getGroupId() %>" />

    <label>제목</label>
    <input type="text" name="title" value="<%= notice.getTitle() %>" required />

    <label>장소</label>
    <input type="text" name="location" value="<%= notice.getLocation() %>" required />

    <label>내용</label>
    <textarea name="content" rows="6" required><%= notice.getContent() %></textarea>

    <button type="submit">수정 완료</button>
  </form>
</div>

</body>
</html>
