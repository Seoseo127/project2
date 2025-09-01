<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="post-wrapper">
	<c:if test="${empty scrapList}">
		<div class="post-box" style="text-align: center;">스크랩한 게시글이
			없습니다.</div>
	</c:if>

	<c:forEach var="post" items="${scrapList}">
		<div class="post-box" id="post-${post.postId}">
			<a href="ViewPostController?postId=${post.postId}" class="post-title">${post.title}</a>
			<p class="post-meta">카테고리: ${post.category} | 닉네임:
				${post.nickname} | 작성일: ${post.createdAt}</p>
			<button class="scrap-cancel-btn" onclick="unscrap(${post.postId})">스크랩
				취소</button>
		</div>
	</c:forEach>

	<!-- 📌 페이징 고정 -->
	<c:if test="${totalPages > 1}">
		<div class="pagination">
			<c:choose>
				<c:when test="${currentPage > 1}">
					<a href="javascript:void(0)" class="page-btn"
						onclick="loadMyScraps(${currentPage - 1})">&laquo; 이전</a>
				</c:when>
				<c:otherwise>
					<span class="page-btn dummy">&laquo; 이전</span>
				</c:otherwise>
			</c:choose>

			<c:forEach var="i" begin="1" end="${totalPages}">
				<a href="javascript:void(0)"
					class="page-btn ${i == currentPage ? 'active' : ''}"
					onclick="loadMyScraps(${i})">${i}</a>
			</c:forEach>

			<c:choose>
				<c:when test="${currentPage < totalPages}">
					<a href="javascript:void(0)" class="page-btn"
						onclick="loadMyScraps(${currentPage + 1})">다음 &raquo;</a>
				</c:when>
				<c:otherwise>
					<span class="page-btn dummy">다음 &raquo;</span>
				</c:otherwise>
			</c:choose>
		</div>
	</c:if>
</div>

<!-- ✅ 스타일 통일 -->
<style>
.post-wrapper {
	display: flex;
	flex-direction: column;
	gap: 16px;
	margin-top: 30px;
	max-width: 800px;
	margin-left: auto;
	margin-right: auto;
}

.post-box {
	padding: 20px 24px;
	border-radius: 1.5rem;
	background-color: #ffffff;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}

.post-title {
	font-size: 1.1rem;
	font-weight: 600;
	color: #1e293b;
	text-decoration: none;
	display: inline-block;
}

.post-title:hover {
	text-decoration: underline;
	color: #3b82f6;
}

.post-meta {
	font-size: 0.85rem;
	color: #6b7280;
	margin-top: 6px;
	margin-bottom: 10px;
}

.scrap-cancel-btn {
	background-color: #3b82f6;
	color: white;
	border: none;
	padding: 8px 14px;
	font-size: 14px;
	border-radius: 10px;
	cursor: pointer;
}

.scrap-cancel-btn:hover {
	background-color: #2563eb;
}

/* 페이징 */
.pagination {
	display: flex;
	justify-content: center;
	margin-top: 40px;
	gap: 10px;
	flex-wrap: wrap;
}

.page-btn {
	padding: 8px 14px;
	background-color: #ffffff;
	color: #333;
	text-decoration: none;
	border: 1px solid #ccc;
	border-radius: 10px;
	font-size: 15px;
	font-weight: 500;
	cursor: pointer;
}

.page-btn:hover {
	background-color: #f3f4f6;
	color: #111827;
}

.page-btn.active {
	background-color: #4a2d2d;
	color: #fff;
	border-color: #4a2d2d;
	font-weight: bold;
}

/* 자리 고정용 더미 */
.page-btn.dummy {
	visibility: hidden;
	pointer-events: none;
}
</style>
