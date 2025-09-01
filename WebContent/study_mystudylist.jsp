<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.dto.StudyGroupDTO, model.dto.UserDTO" %>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    List<StudyGroupDTO> myGroups = (List<StudyGroupDTO>) request.getAttribute("myGroups");
%>
<html>
<head>
    <meta charset="UTF-8" />
    <title>🙋 내가 참여한 스터디</title>
</head>
<body>

<h2>🙋 내가 참여한 스터디 목록</h2>
<a href="studyGroup?role=member">→ 참여 가능한 스터디 보기</a><br/><br/>

<% if (myGroups == null || myGroups.isEmpty()) { %>
    <p>아직 참여한 스터디가 없습니다.</p>
<% } else { %>
<table border="1" cellpadding="8">
    <tr>
        <th>스터디 ID</th>
        <th>스터디명</th>
        <th>스터디장</th>
        <th>기간</th>
        <th>설명</th>
        <th>상태</th>
        <th>액션</th>
    </tr>
    <% for (StudyGroupDTO group : myGroups) { 
           String status = group.getStatus(); // 예: "모집 중" 또는 "종료됨"
    %>
    <tr>
    <td><%= group.getGroupId() %></td>
    <td><%= group.getName() %></td>
    <td><%= group.getLeaderId() %></td>
    <td><%= group.getDuration() %>일</td>
    <td><%= group.getDescription() %></td>
    <td><%= status %></td>
    <td>
        <form method="post" action="studyGroup"
              onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
            <input type="hidden" name="action" value="leave"/>
            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>"/>
            <button type="submit">탈퇴하기</button>
        </form>
    </td>
</tr>
<% } %>
</table>
<% } %>

</body>
</html>

