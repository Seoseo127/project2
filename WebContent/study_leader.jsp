<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스터디 상세 정보 (리더)</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/study_detail.css" />
</head>
<body>

	<h1>${group.name}</h1>
	<p>설명: ${group.description}</p>
	<p>모집 기간: ${group.duration}일</p>
	<p>현재 인원: ${group.currentMemberCount} / 최대 ${group.maxMember}명</p>

	<ul class="member-list">
		<c:forEach var="member" items="${members}">
			<li class="member-row"><span class="member-name">${member.userId}</span>
				<c:if test="${isLeader && member.userId ne sessionScope.userId}">
					<form action="${pageContext.request.contextPath}/kickMember"
						method="post" style="display: inline;">
						<input type="hidden" name="groupId" value="${group.groupId}" /> <input
							type="hidden" name="targetUserId" value="${member.userId}" />
						<button type="submit" class="kick-btn">강제탈퇴</button>
					</form>
				</c:if></li>
		</c:forEach>
	</ul>

	<!-- ✅ 탈퇴 성공/실패 메시지 -->
	<c:if test="${param.kicked eq 'true'}">
		<p style="color: green;">강제 탈퇴 완료</p>
	</c:if>
	<c:if test="${param.kicked eq 'false'}">
		<p style="color: red;">강제 탈퇴 실패</p>
	</c:if>

	<!--  목록으로 돌아가기 -->
	<p>
		<a href="${pageContext.request.contextPath}/allGroups">
			<button>스터디 목록으로 돌아가기</button>
		</a>
	</p>

</body>
</html>
