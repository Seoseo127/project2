<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림 목록</title>
</head>
<body>

<h2>🔔 알림 목록</h2>

<c:choose>
  <c:when test="${empty notifications}">
    <div style="font-size: 14px; color: gray; padding: 20px;">🔕 새로운 알림이 없습니다.</div>
  </c:when>
  <c:otherwise>
    <div style="display: flex; flex-direction: column; gap: 10px;">
      <c:forEach var="n" items="${notifications}">
        <div style="
          background-color: ${n.isRead == 'N' ? '#e3f2fd' : '#f0f0f0'};
          border: 1px solid #ddd;
          border-radius: 10px;
          padding: 12px 16px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          font-weight: ${n.isRead == 'N' ? 'bold' : 'normal'};
          color: ${n.isRead == 'N' ? '#000' : '#888'};
        ">

          <!-- 알림 내용 -->
          <div style="font-size: 14px;">
            <a href="ViewPostController?postId=${n.postId}&notiId=${n.notiId}" style="text-decoration: none; color: inherit;">
              [${n.type}] ${n.message}
            </a>
            <div style="font-size: 12px; color: #888; margin-top: 4px;">
              📅 <fmt:formatDate value="${n.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
            </div>
          </div>

          <!-- 삭제 버튼 -->
          <form action="deleteNotification" method="post" style="margin: 0;">
            <input type="hidden" name="notiId" value="${n.notiId}" />
            <button type="submit" style="background: transparent; border: none; font-size: 16px; cursor: pointer; color: #999;" title="삭제">❌</button>
          </form>
        </div>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>

<br>
<!-- 🔙 목록으로 돌아가기 버튼 -->
<div style="margin-bottom: 15px;">
  <a href="<c:url value='/CommunityListController?category=all' />" 
     style="display: inline-block; padding: 8px 16px; background-color: #1976d2; color: white; text-decoration: none; border-radius: 6px; font-size: 14px;">
    ← 커뮤니티 목록으로
  </a>
</div>

</body>
</html>
