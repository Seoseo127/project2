<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.dto.StudyGroupDTO" %>

<%
    List<StudyGroupDTO> groups = (List<StudyGroupDTO>) request.getAttribute("groups");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내가 가입한 스터디 목록</title>
<<link rel="stylesheet" href="${pageContext.request.contextPath}/css/study_list.css" />
<div class="container">
  <h2>📁 내가 가입한 스터디 목록</h2>
  <% if (groups == null || groups.isEmpty()) { %>
    <script>alert("가입한 스터디가 없습니다."); history.back();</script>
  <% } else { %>
    <% for (StudyGroupDTO group : groups) { %>
      <div class="study-card">
        <div class="study-title"><%= group.getName() %></div>
        <div class="study-desc">설명: <%= group.getDescription() %></div>
        <div class="study-duration">기간: <%= group.getDuration() %>일</div>
        <a href="${pageContext.request.contextPath}/studyDetail?groupId=<%=group.getGroupId()%>">상세 보기</a>
      </div>
    <% } %>
  <% } %>
  <div class="back-link"><a href="${pageContext.request.contextPath}/allGroups">← 스터디 전체 목록 보기</a></div>
</div>

</div>
</body>
</html>

