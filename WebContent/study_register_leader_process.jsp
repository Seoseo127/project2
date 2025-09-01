<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.dto.StudyGroupDTO, service.StudyGroupService" %>
<%
request.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String leaderId = request.getParameter("leaderId");
String description = request.getParameter("description");
int duration = Integer.parseInt(request.getParameter("duration"));
int maxMember = Integer.parseInt(request.getParameter("maxMember"));

StudyGroupDTO dto = new StudyGroupDTO();
dto.setName(name);
dto.setLeaderId(leaderId);
dto.setDescription(description);
dto.setDuration(duration);
dto.setMaxMember(maxMember);

StudyGroupService service = new StudyGroupService();
int result = service.insertGroup(dto);

if (result > 0) {
    response.sendRedirect(request.getContextPath() + "/study_leader_list.jsp?registered=true");
} else {
    response.sendRedirect(request.getContextPath() + "/study_register_leader.jsp?error=fail");
}
%>
