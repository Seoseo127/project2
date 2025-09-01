<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.dto.StudyGroupDTO" %>
<%
List<StudyGroupDTO> groups = (List<StudyGroupDTO>) request.getAttribute("groups");

if (groups == null) {
    response.sendRedirect(request.getContextPath() + "/study_leader_list.jsp?error=noGroups");
    return;
}
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>스터디 관리</title></head>
<body>
<h2>스터디 관리</h2>
<ul>
<% for (StudyGroupDTO g : groups) { %>
    <li>
        <strong><%= g.getName() %></strong> - <%= g.getDescription() %><br>
        <form action="${pageContext.request.contextPath}/endGroup" method="post" style="display:inline;">
            <input type="hidden" name="groupId" value="<%= g.getGroupId() %>">
            <button type="submit">종료</button>
        </form>
        <a href="${pageContext.request.contextPath}/study_edit.jsp?groupId=<%= g.getGroupId() %>">수정</a>
        <a href="${pageContext.request.contextPath}/study_delete.jsp?groupId=<%= g.getGroupId() %>">삭제</a>
    </li>
<% } %>
</ul>
<a href="${pageContext.request.contextPath}/study_home.jsp">홈으로</a>
</body>
</html>
