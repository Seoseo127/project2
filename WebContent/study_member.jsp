<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스터디 상세 정보 (스터디원)</title>
</head>
<body>

	<h1>${group.name}</h1>
	<p>설명: ${group.description}</p>
	<p>모집 상태: ${group.status}</p>
	<p>스터디 기간: ${group.duration}일</p>
	<p>현재 인원: ${group.currentMemberCount} / 최대 ${group.maxMember}명</p>

	<h3>스터디원 목록</h3>
	<ul>
		<c:forEach var="member" items="${members}">
			<li>${member.userId}</li>
		</c:forEach>
	</ul>

	<!-- ✅ 스터디 탈퇴 버튼 -->
	<form action="${pageContext.request.contextPath}/leaveGroup"
		method="post">
		<input type="hidden" name="groupId" value="${group.groupId}" />
		<button type="submit">스터디 탈퇴</button>
	</form>

	<!-- ✅ 탈퇴 성공/실패 메시지 -->
	<c:if test="${param.left eq 'true'}">
		<p style="color: green;">스터디를 탈퇴하였습니다.</p>
	</c:if>
	<c:if test="${param.left eq 'false'}">
		<p style="color: red;">스터디 탈퇴에 실패했습니다.</p>
	</c:if>

	<!--  목록으로 돌아가기 -->
	<p>
		<a href="${pageContext.request.contextPath}/allGroups">
			<button>스터디 목록으로 돌아가기</button>
		</a>
	</p>


</body>
</html>
