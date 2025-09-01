<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.dto.UserDTO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.dto.UserDTO" %>
<%
    UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=notAdmin");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin_style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu_bar_admin.css">
</head>
<body>
<nav>
    <a href="<%=request.getContextPath()%>/admin/admin_main.jsp">🏠 관리자 홈</a>
    <a href="<%=request.getContextPath()%>/AdminUserListController">👥 회원 목록</a>
    <a href="<%=request.getContextPath()%>/AdminReportListController">🚨 신고 내역</a>
    <a href="<%=request.getContextPath()%>/AdminReportProcessListController">✔️ 신고 처리</a>
    <a href="<%=request.getContextPath()%>/SuspendedUserListController">🚫 정지 회원</a>
    <a href="<%=request.getContextPath()%>/user/logout">🔓 로그아웃</a>
</nav>
