<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 통일된 스타일 적용 (버전 변경으로 캐시 우회) -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/my_post_comment.css?v=4.0" />

<!-- ✅ 섹션 타이틀 -->
<div class="section-title">📄 내가 쓴 글</div>

<!-- ✅ 게시글 카드 리스트 -->
<div class="post-wrapper">
	<c:forEach var="post" items="${postList}">
		<div class="post-box">
			<a href="ViewPostController?postId=${post.postId}" class="post-title">
				${post.title}
			</a>
			<div class="post-meta">
				${post.userId} |
				<fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm" />
			</div>
		</div>
	</c:forEach>

	<c:if test="${empty postList}">
		<div class="post-box">작성한 글이 없습니다.</div>
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
