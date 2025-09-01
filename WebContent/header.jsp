<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- ✅ 구글 폰트 + 메뉴바 스타일 -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="<c:url value='/css/menu_bar.css?v=4' />">

<!-- ✅ 메뉴바 전체 -->
<div class="menu-bar-wrapper">
	<div class="menu-inner">

		<!-- ✅ 왼쪽 알림 아이콘 (링크형으로 변경) -->
		<div class="menu-left">
			<a class="noti-icon" href="<c:url value='/NotificationController' />"
				style="position: relative;"> <span class="noti-bell">🔔</span> <c:if
					test="${notiCount > 0}">
					<span class="noti-dot" id="notiDot">●</span>
					<span class="noti-badge" id="notiCount">${notiCount}</span>
				</c:if>
			</a>
		</div>

		<!-- ✅ 중앙 메뉴 -->
		<div class="menu-center">
			<a href="<c:url value='/timer?action=main' />" class="menu-card">
				<span class="menu-text">공부</span> <img
				src="<c:url value='/images/study.png' />" class="menu-icon" />
			</a> <a href="<c:url value='/timer?action=calendar' />" class="menu-card">
				<span class="menu-text">캘린더</span> <img
				src="<c:url value='/images/Calander.png' />" class="menu-icon" />
			</a> <a href="<c:url value='/allGroups' />" class="menu-card"> <span
				class="menu-text">스터디</span> <img
				src="<c:url value='/images/study2.png' />" class="menu-icon" />
			</a> <a href="<c:url value='/CommunityListController?category=all' />"
				class="menu-card"> <span class="menu-text">커뮤니티</span> <img
				src="<c:url value='/images/commu.png' />" class="menu-icon" />
			</a> <a href="<c:url value='/user' />" class="menu-card"> <span
				class="menu-text">마이페이지</span> <img
				src="<c:url value='/images/profile.png' />" class="menu-icon" />
			</a>
		</div>

		<!-- ✅ 오른쪽 로그인/닉네임 -->
		<div class="menu-right user-box">
			<c:choose>
				<c:when test="${not empty sessionScope.loginUser}">
					<span class="nickname-text">${sessionScope.loginUser.userName}님</span>
					<a class="logout-btn"
						href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
				</c:when>
				<c:otherwise>
					<a class="login-btn"
						href="${pageContext.request.contextPath}/user/login.jsp">로그인</a>
					<a class="login-btn"
						href="${pageContext.request.contextPath}/user/signup.jsp">회원가입</a>
				</c:otherwise>
			</c:choose>
		</div>

	</div>
</div>
