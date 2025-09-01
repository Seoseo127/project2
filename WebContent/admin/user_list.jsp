<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.dto.UserDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="admin_header.jsp" %>

<%
    List<UserDTO> fullList = (List<UserDTO>) request.getAttribute("userList");
    int currentPage = 1;
    int size = 10;
    try {
        currentPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception ignored) {}

    int start = (currentPage - 1) * size;
    int end = Math.min(start + size, fullList.size());
    List<UserDTO> pagedList = fullList.subList(start, end);

    request.setAttribute("pagedList", pagedList);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", (int) Math.ceil((double) fullList.size() / size));
%>


<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: #fff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    th, td {
        padding: 12px 16px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }

    th {
        background-color: #f0f4f8;
        font-weight: bold;
    }

    tr:hover {
        background-color: #f9fafb;
    }

    h2 {
        margin-top: 30px;
        margin-bottom: 20px;
    }

    .pagination {
        margin-top: 30px;
        text-align: center;
    }

    .pagination a {
        display: inline-block;
        margin: 0 5px;
        padding: 6px 12px;
        background-color: #e2e8f0;
        color: #333;
        border-radius: 6px;
        text-decoration: none;
    }

    .pagination a.active {
        background-color: #3b82f6;
        color: white;
        font-weight: bold;
    }

    .pagination a:hover {
        background-color: #93c5fd;
    }
</style>

<h2>전체 회원 목록</h2>

<table>
    <tr>
        <th>아이디</th>
        <th>닉네임</th>
        <th>이름</th>
        <th>등급</th>
        <th>가입일</th>
    </tr>
    <c:forEach var="user" items="${pagedList}">
        <tr>
            <td><a href="AdminUserDetailController?userId=${user.userId}">${user.userId}</a></td>
            <td>${user.nickname}</td>
            <td>${user.userName}</td>
            <td>${user.userGrade}</td>
            <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" /></td>
        </tr>
    </c:forEach>
</table>

<!-- ✅ 페이징 -->
<div class="pagination">
    <c:forEach var="i" begin="1" end="${totalPages}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <a href="?page=${i}" class="active">${i}</a>
            </c:when>
            <c:otherwise>
                <a href="?page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>

</div> <!-- admin-content -->
</body>
</html>
