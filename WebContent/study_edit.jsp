<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.dto.StudyGroupDTO" %>
<%@ page import="service.StudyGroupService" %>
<%
    int groupId = Integer.parseInt(request.getParameter("groupId"));
    StudyGroupService service = new StudyGroupService();
    StudyGroupDTO group = service.getGroupById(groupId);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>스터디 수정</title>
</head>
<body>
  <h2>스터디 수정</h2>
  <form action="study_edit_process.jsp" method="post">
    <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />
    이름: <input type="text" name="name" value="<%= group.getName() %>" /><br/>
    기간: <input type="number" name="duration" value="<%= group.getDuration() %>" /><br/>
    설명: <br/>
    <textarea name="description" rows="5" cols="40"><%= group.getDescription() != null ? group.getDescription() : "" %></textarea><br/>
    <input type="submit" value="수정 완료" />
  </form>
</body>
</html>
