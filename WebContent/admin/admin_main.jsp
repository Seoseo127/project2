<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.dto.UserDTO" %>

<%
    UserDTO user = (UserDTO) session.getAttribute("loginUser");
    if (user == null || !"관리자".equals(user.getUserGrade())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<%@ include file="admin_header.jsp" %>

<h1>관리자 전용 페이지입니다.</h1>
<p><%= user.getUserName() %>님 환영합니다!</p>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu_bar_admin.css">
<!-- 여기서 마무리 -->
</div> <!-- admin-content -->
</body>
</html>


