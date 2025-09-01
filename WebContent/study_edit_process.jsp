<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="service.StudyGroupService" %>
<%@ page import="model.dto.StudyGroupDTO" %>

<%
    request.setCharacterEncoding("UTF-8");

    int groupId = Integer.parseInt(request.getParameter("groupId"));
    String name = request.getParameter("name");
    int duration = Integer.parseInt(request.getParameter("duration"));
    String description = request.getParameter("description");

    StudyGroupService service = new StudyGroupService();
    StudyGroupDTO group = service.getGroupById(groupId);
    group.setName(name);
    group.setDuration(duration);
    group.setDescription(description);

    service.updateGroup(group);

    response.sendRedirect("study_leader.jsp?groupId=" + groupId);
%>
