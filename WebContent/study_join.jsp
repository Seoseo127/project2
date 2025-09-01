<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="model.dto.StudyGroupDTO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");%>

<%
StudyGroupDTO group = (StudyGroupDTO) request.getAttribute("group");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>스터디 가입 페이지 - <%=group.getName()%></title>
</head>
<body>
	<h1>스터디 가입 안내</h1>
	<h2><%=group.getName()%></h2>
	<p>
		생성일: <fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
	<p>
		기간:
		<%=group.getDuration()%>일
	</p>
	<p>
		설명:
		<%=group.getDescription() != null ? group.getDescription() : "설명 없음"%></p>

	<form action="joinGroup" method="post">
		<input type="hidden" name="groupId" value="<%=group.getGroupId()%>" />
		<button type="submit">가입하기</button>
	</form>

	<!-- 목록으로 돌아가기 -->
	<p>
		<a href="${pageContext.request.contextPath}/allGroups">
			<button>스터디 목록으로 돌아가기</button>
		</a>
	</p>

	<!-- ✅ 에러 메시지 팝업 -->
	<c:if test="${param.error eq 'full'}">
		<script>
			alert("정원이 초과되었습니다.");
		</script>
	</c:if>

</body>
</html>
