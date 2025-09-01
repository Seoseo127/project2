<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.dto.UserDTO, java.util.List" %>
<%@ include file="admin_header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    h2 {
        margin-top: 30px;
        margin-bottom: 16px;
        font-weight: 600;
        color: #333;
    }

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

    td[colspan] {
        color: #888;
        font-style: italic;
    }

    form {
        display: inline-block;
        margin: 0;
    }

    button {
        padding: 6px 12px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
    }

    button[type="submit"] {
        background-color: #60a5fa;
        color: white;
    }

    button[type="submit"]:hover {
        background-color: #3b82f6;
    }

    button.resuspend {
        background-color: #f87171;
    }

    button.resuspend:hover {
        background-color: #ef4444;
    }
</style>

<h2>🚫 정지된 회원 목록</h2>

<table>
    <tr>
        <th>아이디</th>
        <th>이름</th>
        <th>닉네임</th>
        <th>정지 만료일</th>
        <th>정지 해제</th>
        <th>재정지</th>
    </tr>
    <c:forEach var="user" items="${suspendedUsers}">
        <tr>
            <td>${user.userId}</td>
            <td>${user.userName}</td>
            <td>${user.nickname}</td>
            <td><fmt:formatDate value="${user.suspendedUntil}" pattern="yyyy-MM-dd" /></td>
            <td>
                <form action="${pageContext.request.contextPath}/UnsuspendUserController" method="post">
                    <input type="hidden" name="userId" value="${user.userId}"/>
                    <button type="submit">정지 해제</button>
                </form>
            </td>
            <td>
                <form action="${pageContext.request.contextPath}/ResuspendUserController" method="post">
                    <input type="hidden" name="userId" value="${user.userId}"/>
                    <button type="submit" class="resuspend">재정지</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty suspendedUsers}">
        <tr><td colspan="6">정지된 회원이 없습니다.</td></tr>
    </c:if>
</table>

</div> <!-- admin-content -->
</body>
</html>
