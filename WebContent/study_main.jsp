<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.dto.UserDTO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%
UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
if (loginUser == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스터디 메인</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/menu_bar.css" />
<style>
body {
	font-family: Arial, sans-serif;
	margin: 40px;
	background-color: #f2f2f2;
}

.container {
	max-width: 900px;
	margin: auto;
	padding: 30px;
	background: white;
	border-radius: 8px;
}

h2 {
	color: #0077b6;
}

.menu-grid {
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
	margin-top: 30px;
}

.menu-card {
	flex: 1 1 250px;
	background-color: #e1f5fe;
	padding: 20px;
	border-radius: 8px;
	text-align: center;
	text-decoration: none;
	color: #0077b6;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s ease-in-out;
}

.menu-card:hover {
	transform: translateY(-5px);
	background-color: #b3e5fc;
}

.menu-icon {
	width: 50px;
	margin-bottom: 10px;
}

.study-list {
	margin-top: 40px;
}

.study-item {
	border: 1px solid #ccc;
	border-radius: 6px;
	padding: 15px;
	margin-bottom: 15px;
	background-color: #fafafa;
}

.study-item a {
	display: inline-block;
	margin-top: 8px;
	color: #0077b6;
	text-decoration: underline;
}
</style>
</head>
<body>

	<jsp:include page="header.jsp" />

	<div class="container">
		<h2>${loginUser.userName}님,환영합니다!</h2>

		<!-- study_main.jsp 발췌 (수정된 내가 만든 스터디 버튼) -->
		<div class="menu-grid">
			<c:choose>
				<c:when test="${empty groupsLedByMe}">
					<a href="#" class="menu-card"
						onclick="alert('아직 생성한 스터디가 없습니다.'); return false;"> <span
						class="menu-text">내가 만든 스터디</span>
					</a>
				</c:when>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/myCreatedGroups"
						class="menu-card"> <span class="menu-text">내가 만든 스터디</span>
					</a>
				</c:otherwise>
			</c:choose>


			<!-- =================================================================================================== -->

			<!-- 내가 가입한 스터디 -->
			<c:choose>
				<c:when test="${empty groupsJoinedByMe}">
					<a href="#" class="menu-card"
						onclick="alert('가입한 스터디가 없습니다.'); return false;"> <span
						class="menu-text">내가 가입한 스터디</span>
					</a>
				</c:when>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/myGroups"
						class="menu-card"> <span class="menu-text">내가 가입한 스터디</span>
					</a>
				</c:otherwise>
			</c:choose>

			<!-- =================================================================================================== -->


			<!-- 스터디 생성 -->
			<a href="${pageContext.request.contextPath}/study_create.jsp"
				class="menu-card"> <span class="menu-text">스터디 생성</span>
			</a>
		</div>
	</div>

	<!-- =================================================================================================== -->

<!-- 🔍 전체 상단 검색 영역 -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">

  <!-- 왼쪽 제목 -->
  <h2 style="margin: 0;">📋전체 스터디 목록</h2>

  <!-- 오른쪽 검색창 + 버튼 -->
  <form action="${pageContext.request.contextPath}/allGroups" method="get" style="display: flex; align-items: center;">
    <input type="text" name="keyword" placeholder="스터디 이름, 설명, 스터디장 검색"
           value="${param.keyword}" 
           style="padding: 9px 14px; width: 260px; border-radius: 6px; border: 1px solid #ccc; font-size: 15px;" />

    <style>
      .btn-cute {
          display: inline-block;
          min-width: 110px;
          padding: 9px 0;
          margin-left: 8px;
          font-size: 15px;
          text-align: center;
          border-radius: 8px;
          cursor: pointer;
          border: none;
          text-decoration: none;
          font-weight: 600;
          transition: all 0.2s ease;
      }

      .btn-cute.search {
          background-color: #43aa8b;
          color: white;
      }
      .btn-cute.search:hover {
          background-color: #369270;
      }

      .btn-cute.reset {
          background-color: #3a86ff;
          color: white;
      }
      .btn-cute.reset:hover {
          background-color: #2d6fd6;
      }
      
      .btn-cute.detail {
  		background-color: #ffc107;
  		color: black;
		}
	.btn-cute.detail:hover {
  		background-color: #e0a800;
		}
      
      
    </style>

    <!-- 검색 버튼 -->
    <button type="submit" class="btn-cute search">🔍 검색</button>

    <!-- 전체 보기 버튼 -->
    <a href="${pageContext.request.contextPath}/allGroups" class="btn-cute reset">🔄 전체 보기</a>
  </form>
</div>
		<c:if test="${empty groups}">
			<p>현재 등록된 스터디가 없습니다.</p>
		</c:if>
<c:forEach var="group" items="${groups}">
  <div class="study-item">
    <strong>${group.name}</strong><br />
    설명: ${group.description}<br />
    인원: ${group.currentMemberCount} / ${group.maxMember}<br />
    
    <form action="${pageContext.request.contextPath}/studyDetail" method="get" style="margin-top: 8px;">
      <input type="hidden" name="groupId" value="${group.groupId}" />
      <button type="submit" class="btn-cute">▶ 상세 보기</button>
    </form>
  </div>
</c:forEach>




</body>
</html>
s