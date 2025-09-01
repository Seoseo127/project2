<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
String category = request.getParameter("category");
String keyword = request.getParameter("keyword");
if (category == null)
	category = "all";
if (keyword == null)
	keyword = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 게시판</title>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	max-width: 900px;
	margin: auto;
	padding: 20px;
	background-color: #f4f9fc;
}

h2 {
	margin-bottom: 24px;
	color: #0077b6;
}

.btn-cute {
	padding: 8px 16px;
	background-color: #e1f5fe;
	border: none;
	border-radius: 8px;
	font-weight: 600;
	color: #0077b6;
	cursor: pointer;
	transition: background-color 0.2s ease;
	font-size: 14px;
}

.btn-cute:hover {
	background-color: #b3e5fc;
}

.btn-cute.active {
	background-color: #0077b6;
	color: white;
}

.btn-cute.search {
	background-color: #43aa8b;
	color: white;
}

.btn-cute.search:hover {
	background-color: #369270;
}

.btn-cute.write {
	background-color: #3a86ff;
	color: white;
}

.btn-cute.write:hover {
	background-color: #2d6fd6;
}

.category-bar {
	display: flex;
	justify-content: center;
	flex-wrap: wrap;
	gap: 14px;
	margin-bottom: 30px;
}

.category-bar .btn-category {
	padding: 12px 24px;
	background-color: #e1f5fe;
	border: none;
	border-radius: 12px;
	font-size: 16px;
	font-weight: bold;
	color: #0077b6;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.category-bar .btn-category:hover {
	background-color: #b3e5fc;
}

.category-bar .btn-category.active {
	background-color: #0077b6;
	color: white;
}

.search-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 10px;
	flex-wrap: wrap;
	margin-bottom: 30px;
}

.search-bar input[type="text"] {
	padding: 8px 14px;
	width: 240px;
	border-radius: 8px;
	border: 1px solid #ccc;
	font-size: 14px;
}

.table-box {
	background: #ffffff;
	border-radius: 12px;
	padding: 20px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	margin-top: 30px;
}

.post-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

a.post-card {
	display: block;
	border: 1px solid #e0e0e0;
	border-radius: 10px;
	padding: 14px 20px;
	background-color: #fff;
	transition: box-shadow 0.2s ease;
	text-decoration: none;
	color: inherit;
}

a.post-card:hover {
	background-color: #eef5ff;
	box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
	transform: translateY(-2px);
	transition: all 0.2s ease-in-out;
}

.top-row {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	flex-wrap: wrap;
	margin-bottom: 10px;
}

.left-box {
	display: flex;
	align-items: center;
	gap: 12px;
	flex-wrap: wrap;
}

.category {
	color: #0077b6;
	font-weight: bold;
	font-size: 14px;
	border: 1px solid #b3e5fc;
	border-radius: 6px;
	padding: 2px 8px;
	background-color: #e1f5fe;
}

.title {
	font-size: 16px;
	font-weight: bold;
	color: #1e3a8a;
	text-decoration: none;
}

.title:hover {
	color: #3b82f6;
	text-decoration: underline;
}

.created-at {
	font-size: 13px;
	color: #888;
}

.bottom-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 6px;
}

.counts {
	display: flex;
	gap: 10px;
	font-size: 13px;
	color: #888;
}

.top-post-card {
	border: 1px solid #ffe58f;
	background-color: #fffbe6;
	border-radius: 8px;
	padding: 12px 16px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
}

.pagination {
	text-align: center;
	margin-top: 40px;
	display: flex;
	justify-content: center;
	flex-wrap: wrap;
	gap: 8px;
}

.page-btn {
	padding: 8px 14px;
	min-width: 40px;
	text-align: center;
	background-color: #ffffff;
	color: #333;
	text-decoration: none;
	border: 1px solid #ccc;
	border-radius: 10px;
	font-size: 15px;
	font-weight: 500;
	cursor: pointer;
	box-sizing: border-box;
}

.page-btn:hover {
	background-color: #eff6ff;
	color: #1e3a8a;
}

.page-btn.active {
	background-color: #3b82f6;
	color: #fff;
	border-color: #3b82f6;
	font-weight: bold;
}

.page-btn.dummy {
	visibility: hidden;
	pointer-events: none;
}
</style>
</head>
<body>

	<h2>📚 커뮤니티 게시판</h2>

	<!-- ✅ 카테고리 선택 -->
	<div class="category-bar">
		<form action="CommunityListController" method="get">
			<input type="hidden" name="category" value="all">
			<button class="btn-category ${category == 'all' ? 'active' : ''}">전체게시판</button>
		</form>
		<form action="CommunityListController" method="get">
			<input type="hidden" name="category" value="자유">
			<button class="btn-category ${category == '자유' ? 'active' : ''}">자유게시판</button>
		</form>
		<form action="CommunityListController" method="get">
			<input type="hidden" name="category" value="공부">
			<button class="btn-category ${category == '공부' ? 'active' : ''}">공부게시판</button>
		</form>
		<form action="CommunityListController" method="get">
			<input type="hidden" name="category" value="학생">
			<button
				class="btn-category ${category == '학생' || category == '고등학생' || category == '대학생' || category == '취준생' || category == '직장인' ? 'active' : ''}">학생별게시판</button>
		</form>
	</div>

	<!-- ✅ 학생 하위 카테고리 -->
	<c:if
		test="${category == '학생' || category == '고등학생' || category == '대학생' || category == '취준생' || category == '직장인'}">
		<div
			style="display: flex; justify-content: center; gap: 12px; margin-bottom: 20px;">
			<c:forEach var="role" items="${['고등학생','대학생','취준생','직장인']}">
				<form action="CommunityListController" method="get">
					<input type="hidden" name="category" value="${role}">
					<button type="submit"
						class="btn-cute ${category == role ? 'active' : ''}">${role}</button>
				</form>
			</c:forEach>
		</div>
	</c:if>

	<!-- ✅ 검색 & 글쓰기 -->
	<div class="search-bar">
		<form action="CommunityListController" method="get"
			style="display: flex; gap: 8px;">
			<input type="hidden" name="category" value="<%=category%>"> <input
				type="text" name="keyword" placeholder="검색어" value="<%=keyword%>">
			<button type="submit" class="btn-cute search">🔍 검색</button>
		</form>
		<form action="writePost.jsp" method="get">
			<button type="submit" class="btn-cute write">✏ 글쓰기</button>
		</form>
	</div>

	<!-- ✅ 인기글 Top 3 -->
	<c:if test="${not empty topPosts}">
		<div style="margin-top: 30px;">
			<h3 style="margin-bottom: 16px;">🔥 인기글 Top 3</h3>
			<div style="display: flex; flex-direction: column; gap: 12px;">
				<c:forEach var="post" items="${topPosts}">
					<div class="top-post-card">
						<div
							style="display: flex; justify-content: space-between; align-items: center;">
							<div>
								<a
									href="${pageContext.request.contextPath}/ViewPostController?postId=${post.postId}"
									style="font-size: 16px; font-weight: bold; color: #d48806; text-decoration: none;">
									🔥 ${post.title}</a>
								<div style="font-size: 13px; color: #888;">
									${post.nickname} ·
									<fmt:formatDate value="${post.createdAt}"
										pattern="yyyy-MM-dd HH:mm" />
								</div>
							</div>
							<div style="font-size: 13px; color: #888;">
								조회수 <strong>${post.viewCount}</strong> · 댓글 ${post.commentCount}
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</c:if>

	<!-- ✅ 게시글 카드 리스트 -->
	<div class="table-box">
		<div class="post-list">
			<c:choose>
				<c:when test="${not empty postList}">
					<c:forEach var="post" items="${postList}">
						<a class="post-card"
							href="${pageContext.request.contextPath}/ViewPostController?postId=${post.postId}">
							<div class="top-row">
								<div class="left-box">
									<span class="category">${post.category}</span> <span
										class="title">${post.title}</span>
								</div>
								<div class="created-at">
									<fmt:formatDate value="${post.createdAt}"
										pattern="yyyy-MM-dd HH:mm" />
								</div>
							</div>

							<div class="like-bar">❤️ ${post.likeCount}</div>

							<div class="bottom-row">
								<div></div>
								<div class="counts">
									<span>💬 ${post.commentCount}</span> <span>👁
										${post.viewCount}</span>
								</div>
							</div>
						</a>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div style="text-align: center; padding: 30px;">게시글이 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- ✅ 페이징 -->
	<div class="pagination">
		<c:choose>
			<c:when test="${currentPage > 1}">
				<a
					href="?page=${currentPage - 1}&category=${category}&keyword=${keyword}"
					class="page-btn">&laquo; 이전</a>
			</c:when>
			<c:otherwise>
				<span class="page-btn dummy">&laquo; 이전</span>
			</c:otherwise>
		</c:choose>

		<c:forEach var="i" begin="1" end="${totalPages}">
			<a href="?page=${i}&category=${category}&keyword=${keyword}"
				class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
		</c:forEach>

		<c:choose>
			<c:when test="${currentPage < totalPages}">
				<a
					href="?page=${currentPage + 1}&category=${category}&keyword=${keyword}"
					class="page-btn">다음 &raquo;</a>
			</c:when>
			<c:otherwise>
				<span class="page-btn dummy">다음 &raquo;</span>
			</c:otherwise>
		</c:choose>
	</div>

</body>
</html>
