<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 최신 스타일시트 적용 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/my_post_comment.css?v=4.0" />

<!-- ✅ 섹션 타이틀 -->
<div class="section-title">💬 내가 쓴 댓글</div>

<!-- ✅ 댓글 카드 리스트 -->
<div class="post-wrapper">
	<c:forEach var="comment" items="${commentList}">
		<div class="post-box">
			<a href="ViewPostController?postId=${comment.postId}" class="post-title">
				${comment.postTitle}
			</a>
			<div class="post-meta">
				${comment.userId} |
				<fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
			</div>
			<div class="post-content">${comment.cContent}</div>
		</div>
	</c:forEach>

	<c:if test="${empty commentList}">
		<div class="post-box">작성한 댓글이 없습니다.</div>
	</c:if>
</div>

<!-- ✅ 페이지네이션 -->
<div class="pagination">
  <!-- 이전 버튼 (조건에 따라 보이지만 자리는 항상 존재) -->
  <c:choose>
    <c:when test="${currentPage > 1}">
      <a href="javascript:void(0)" class="page-btn" onclick="loadMyPosts(${currentPage - 1})">&laquo; 이전</a>
    </c:when>
    <c:otherwise>
      <span class="page-btn dummy">&laquo; 이전</span>
    </c:otherwise>
  </c:choose>

  <!-- 페이지 번호 -->
  <c:forEach var="i" begin="1" end="${totalPages}">
    <a href="javascript:void(0)" class="page-btn ${i == currentPage ? 'active' : ''}" onclick="loadMyPosts(${i})">${i}</a>
  </c:forEach>

  <!-- 다음 버튼 (조건에 따라 보이지만 자리는 항상 존재) -->
  <c:choose>
    <c:when test="${currentPage < totalPages}">
      <a href="javascript:void(0)" class="page-btn" onclick="loadMyPosts(${currentPage + 1})">다음 &raquo;</a>
    </c:when>
    <c:otherwise>
      <span class="page-btn dummy">다음 &raquo;</span>
    </c:otherwise>
  </c:choose>
</div>
