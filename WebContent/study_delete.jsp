<%@ page contentType="text/html; charset=UTF-8" %>
<%
String groupId = request.getParameter("groupId");

// 기존 session 객체 재사용
if (session == null || session.getAttribute("loginUser") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

if (groupId != null) {
    response.sendRedirect(request.getContextPath() + "/study_leader_list.jsp?deleted=true&groupId=" + groupId);
} else {
    response.sendRedirect(request.getContextPath() + "/study_leader_list.jsp?deleted=false");
}
%>
