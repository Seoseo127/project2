<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="admin_header.jsp" %>

<style>
  h2, h3 {
    margin-top: 30px;
    margin-bottom: 16px;
    font-weight: 600;
    color: #333;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.05);
    overflow: hidden;
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

  a {
    color: #2563eb;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }
</style>

<h2>회원 상세 정보</h2>

<table border="1" cellpadding="10" style="margin-bottom: 20px;">
  <tr><th>아이디</th><td>${user.userId}</td></tr>
  <tr><th>닉네임</th><td>${user.nickname}</td></tr>
  <tr><th>이름</th><td>${user.userName}</td></tr>
  <tr><th>이메일</th><td>${user.email}</td></tr>
  <tr><th>등급</th><td>${user.userGrade}</td></tr>
  <tr><th>가입일</th><td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" /></td></tr>
  <c:if test="${not empty user.suspendedUntil}">
    <tr><th>정지 해제 예정일</th><td><fmt:formatDate value="${user.suspendedUntil}" pattern="yyyy-MM-dd" /></td></tr>
  </c:if>
</table>

<h3>📋 신고 내역</h3>
<table border="1" cellpadding="8" style="margin-bottom: 20px;">
  <tr>
    <th>신고 사유</th>
    <th>신고일</th>
  </tr>
  <c:forEach var="report" items="${reportList}">
    <tr>
      <td>${report.content}</td>
      <td><fmt:formatDate value="${report.createdAt}" pattern="yyyy-MM-dd" /></td>
    </tr>
  </c:forEach>
  <c:if test="${empty reportList}">
    <tr><td colspan="2">신고 내역이 없습니다.</td></tr>
  </c:if>
</table>


<h3>🚫 3회 이상 신고된 글/댓글</h3>
<table border="1" cellpadding="8">
  <tr>
    <th>신고된 글/댓글</th>
    <th>신고 횟수</th>
  </tr>
  <c:forEach var="dup" items="${duplicateReportedTargets}">
    <tr>
      <td>
        <c:choose>
          <c:when test="${dup.TARGET_TYPE == 'post'}">
            <a href="${pageContext.request.contextPath}/ViewPostController?postId=${dup.TARGET_ID}">이동</a>
          </c:when>
          <c:when test="${dup.TARGET_TYPE == 'comment'}">
            <a href="${pageContext.request.contextPath}/ViewPostController?postId=${dup.POST_ID}">댓글 ID: ${dup.TARGET_ID}</a>
          </c:when>
          <c:otherwise>
            ${dup.TARGET_ID}
          </c:otherwise>
        </c:choose>
      </td>
      <td>${dup.COUNT}</td>
    </tr>
  </c:forEach>
  <c:if test="${empty duplicateReportedTargets}">
    <tr><td colspan="2">중복 신고된 글/댓글이 없습니다.</td></tr>
  </c:if>
</table>

</div> <!-- admin-content -->
</body>
</html>
