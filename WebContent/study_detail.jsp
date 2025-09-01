<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.dto.StudyGroupDTO, java.util.List, model.dto.StudyMemberDTO" %>
<%@ page import="java.time.*, java.time.format.*" %>
<%@ page import="java.util.List, model.dto.StudyCommentDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
StudyGroupDTO group = (StudyGroupDTO) request.getAttribute("group");
List<StudyMemberDTO> members = (List<StudyMemberDTO>) request.getAttribute("members");
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
boolean isJoined = (boolean) request.getAttribute("isJoined");
boolean isLeader = (boolean) request.getAttribute("isLeader");
String joined = request.getParameter("joined");
String error = request.getParameter("error");
String userId = (String) session.getAttribute("userId");
// 모집 상태 계산
String 모집상태 = (group.getCurrentMemberCount() >= group.getMaxMember()) ? "모집 완료" : "모집 중";

// 컨트롤러에서 별도로 전달된 createdAt 사용
java.util.Date createdAt = (java.util.Date) request.getAttribute("createdAt");
    LocalDate startDate = ((java.sql.Date) createdAt).toLocalDate();  
    LocalDate endDate = startDate.plusDays(group.getDuration());
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
    List<StudyCommentDTO> comments = (List<StudyCommentDTO>) request.getAttribute("comments");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>스터디 상세 페이지</title>
    <style>
        .study-detail-card {
            max-width: 700px;
            margin: 40px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            font-family: 'Segoe UI', sans-serif;
        }
        .study-detail-card h2 {
            margin-top: 0;
            color: #003366;
        }
        .study-detail-card p {
            margin: 10px 0;
            font-size: 15px;
        }
        .study-detail-btns {
            margin-top: 30px;
        }
        .study-detail-btns form,
        .study-detail-btns a {
            display: inline-block;
            margin-right: 10px;
        }
        .study-detail-btns button,
        .study-detail-btns a {
            padding: 8px 15px;
            border: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 6px;
            text-decoration: none;
        }
        .study-detail-btns button.delete {
            background-color: #e74c3c;
        }
        ul.member-list {
            margin-top: 10px;
            padding-left: 20px;
        }
    </style>
    <style>
    /* 기존에 있는 스타일 유지하고 이걸 아래에 붙이세요 */
    
    .study-detail-btns {
        margin-top: 30px;
        text-align: left;
    }
    .study-detail-btns .btn-action {
        min-width: 180px;
        padding: 10px 18px;
        font-size: 15px;
        margin-right: 10px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    .study-detail-btns .btn-action:hover {
        background-color: #2980b9;
    }
    .study-detail-btns .btn-action.cancel {
        background-color: #95a5a6;
    }
    .study-detail-btns .btn-action.cancel:hover {
        background-color: #7f8c8d;
    }
    .study-detail-btns .btn-action.delete {
        background-color: #e74c3c;
    }
    .study-detail-btns .btn-action.delete:hover {
        background-color: #c0392b;
    }
    
    .btn-action {
  		min-width: 90px;
 		padding: 8px 14px;
  		font-size: 14px;
  		background-color: #3498db;
  		color: white;
  		border: none;
  		border-radius: 6px;
  		cursor: pointer;
  		margin-right: 6px;
	}
	.btn-action:hover {
  		background-color: #2980b9;
	}
	.btn-action.delete {
  		background-color: #e74c3c;
	}
	.btn-action.delete:hover {
  		background-color: #c0392b;
	}
    
    
</style>
    
</head>
<body>
<% String kicked = request.getParameter("kicked"); %>




<!-- 메뉴바 포함 -->
<%@ include file="/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/study_detail.css" />

	<div class="container">
  	<div class="study-detail-card">
  <h2>스터디 상세 정보</h2>
  <p><strong>스터디 이름:</strong> <%= group.getName() %></p>
  <p><strong>설명:</strong> <%= group.getDescription() %></p>
  <p><strong>스터디장:</strong> <%= group.getLeaderId() %></p>
  <p><strong>모집 상태:</strong> <%= 모집상태 %></p>
  <p><strong>기간:</strong> <%= group.getDuration() %>일</p>
  <p><strong>시작일:</strong> <%= formatter.format(startDate) %></p>
  <p><strong>종료일:</strong> <%= formatter.format(endDate) %></p>
  <p><strong>현재 인원:</strong> <%= group.getCurrentMemberCount() %> / <%= group.getMaxMember() %></p>

 <h3>스터디원 목록</h3>
    <ul class="member-list">
      <c:forEach var="member" items="${members}">
        <li>
          <span class="member-name">${member.userId}</span>
          <c:if test="${isLeader and member.userId ne sessionScope.userId}">
            <form action="${pageContext.request.contextPath}/kickMember" method="post" style="margin:0;">
              <input type="hidden" name="groupId" value="${group.groupId}" />
              <input type="hidden" name="targetUserId" value="${member.userId}" />
              <button type="submit" class="kick-btn">강제탈퇴</button>
            </form>
          </c:if>
        </li>
      </c:forEach>
    </ul>

    <div class="study-detail-btns">
    <form action="${pageContext.request.contextPath}/allGroups" method="get" style="display:inline;">
        <button type="submit" class="btn-action">스터디 목록으로 돌아가기</button>
    </form>

    <% if (!isJoined && !isLeader) { %>
        <form action="${pageContext.request.contextPath}/joinGroup" method="post" style="display:inline;">
            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>">
            <button type="submit" class="btn-action">이 스터디에 참여하기</button>
        </form>
    <% } else if (isJoined && !isLeader) { %>
        <form action="${pageContext.request.contextPath}/leaveGroup" method="post" style="display:inline;">
            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>">
            <button type="submit" class="btn-action cancel">스터디 탈퇴</button>
        </form>
    <% } else if (isLeader) { %>
        <p style="color:gray;">※ 이 스터디의 리더입니다.</p>
        <form action="${pageContext.request.contextPath}/deleteGroup" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>">
            <button type="submit" class="btn-action delete">스터디 삭제</button>
        </form>
    <% } %>
</div>


    <% if ("true".equals(joined)) { %>
        <p style="color:green;">스터디에 성공적으로 참여하였습니다.</p>
    <% } else if ("false".equals(joined)) { %>
        <p style="color:red;">스터디 참여에 실패하였습니다.</p>
    <% } else if ("full".equals(error)) { %>
        <p style="color:red;">오류: 스터디 인원이 가득 찼습니다.</p>
    <% } %>
</div>
<% if (isLeader) { %>
  <div style="max-width: 700px; margin: 30px auto; padding: 20px; border: 1px solid #ccc; border-radius: 12px;">
    <h3>📢 공지사항 등록</h3>
    <form action="${pageContext.request.contextPath}/notice" method="post">
      <input type="hidden" name="action" value="insert" />
      <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />

      <label>제목</label><br>
      <input type="text" name="title" style="width:100%; padding:8px;" required><br><br>

      <label>장소</label><br>
      <input type="text" name="location" style="width:100%; padding:8px;" required><br><br>

      <label>내용</label><br>
      <textarea name="content" rows="5" style="width:100%; padding:8px;" required></textarea><br><br>

      <button type="submit" class="btn-action">공지 등록</button>
    </form>
  </div>
<% } %>

	<%@ page import="java.util.List, model.dto.StudyNoticeDTO" %>
<%
List<StudyNoticeDTO> notices = (List<StudyNoticeDTO>) request.getAttribute("notices");
%>

<div style="max-width: 700px; margin: 30px auto;">
  <h3 style="margin-bottom: 20px;">📋 등록된 공지사항</h3>

  <% if (notices != null && !notices.isEmpty()) { %>
    <ul style="list-style: none; padding: 0;">
    <% for (StudyNoticeDTO notice : notices) { 
         String title = (notice.getTitle() != null && !notice.getTitle().isBlank()) ? notice.getTitle() : "(제목 없음)";
         String location = (notice.getLocation() != null && !notice.getLocation().isBlank()) ? notice.getLocation() : "(장소 없음)";
         String content = (notice.getContent() != null && !notice.getContent().isBlank()) ? notice.getContent() : "(내용 없음)";
    %>
      <li style="border: 1px solid #ccc; padding: 20px; border-radius: 12px; margin-bottom: 20px; background: #f9f9f9;">
        <p style="font-size: 18px; font-weight: bold;">제목: <%= title %></p>
        <p style="font-size: 15px;">장소: <%= location %></p>
        <p style="margin: 10px 0; font-size: 15px;">내용:<br> <%= content.replaceAll("\n", "<br>") %></p>
        <p style="font-size: 13px; color: gray;">
          작성일: <%= dateFormat.format(notice.getCreatedAt()) %> / 작성자: <%= notice.getCreatedBy() %>
        </p>

        <% if (isLeader && notice.getCreatedBy().equals(userId)) { %>
          <form action="${pageContext.request.contextPath}/notice" method="post" style="display:inline;">
            <input type="hidden" name="action" value="delete" />
            <input type="hidden" name="noticeId" value="<%= notice.getNoticeId() %>" />
            <input type="hidden" name="groupId" value="<%= notice.getGroupId() %>" />
            <button type="submit" class="btn-action delete" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
          </form>

          <form action="${pageContext.request.contextPath}/editNotice.jsp" method="get" style="display:inline;">
            <input type="hidden" name="noticeId" value="<%= notice.getNoticeId() %>" />
            <input type="hidden" name="groupId" value="<%= notice.getGroupId() %>" />
            <button type="submit" class="btn-action">수정</button>
          </form>
        <% } %>
      </li>
    <% } %>
    </ul>
  <% } else { %>
    <p style="color:gray;">등록된 공지사항이 없습니다.</p>
  <% } %>
</div>

<%
String updated = request.getParameter("updated"); // 수정 완료 메시지 출력용
%>

<%
String editCommentId = request.getParameter("editCommentId");
%>

<% if (isJoined) { %>
  <form action="${pageContext.request.contextPath}/comment" method="post">
    <input type="hidden" name="action" value="insert" />
    <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />
    <textarea name="content" rows="3" placeholder="댓글을 입력하세요" style="width:100%; padding:8px;" required></textarea>
    <button type="submit" class="btn-action" style="margin-top:10px;">댓글 등록</button>
  </form>
<% } else { %>
  <p style="color:gray;">댓글을 작성하려면 스터디에 참여해야 합니다.</p>
<% } %>

<hr style="margin:30px 0;">

<% if (comments != null && !comments.isEmpty()) { %>
  <ul style="list-style:none; padding:0;">
    <% for (StudyCommentDTO comment : comments) { %>
      <li style="background-color:#f9f9f9; border:1px solid #ccc; border-radius:10px; padding:15px; margin-bottom:15px;">
        <div style="display:flex; justify-content:space-between; align-items:center;">
          <div style="font-weight:bold; color:#2c3e50;"><%= comment.getUserId() %></div>
          <div style="font-size:13px; color:#777;"><%= dateFormat.format(comment.getCreatedAt()) %></div>
        </div>

        <% if (userId.equals(comment.getUserId()) && ("" + comment.getCommentId()).equals(editCommentId)) { %>
          <!-- 수정 중 -->
          <form action="${pageContext.request.contextPath}/comment" method="post" style="margin-top:10px;">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />
            <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>" />
            <textarea name="content" rows="3" style="width:100%; padding:10px; border-radius:8px;" required><%= comment.getContent() %></textarea>
            <div style="margin-top:10px;">
              <button type="submit" class="btn-action">수정 완료</button>
              <form action="${pageContext.request.contextPath}/studyDetail" method="get" style="display:inline;">
                <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />
                <button type="submit" class="btn-action cancel">취소</button>
              </form>
            </div>
          </form>
        <% } else { %>
          <p style="margin-top:10px;"><%= comment.getContent().replaceAll("\n", "<br>") %></p>
          <% if (userId.equals(comment.getUserId())) { %>
            <div style="margin-top:10px;">
              <form action="${pageContext.request.contextPath}/studyDetail" method="get" style="display:inline-block;">
                <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />
                <input type="hidden" name="editCommentId" value="<%= comment.getCommentId() %>" />
                <button type="submit" class="btn-action">수정</button>
              </form>

              <form action="${pageContext.request.contextPath}/comment" method="post" onsubmit="return confirm('삭제하시겠습니까?');" style="display:inline-block;">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />
                <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>" />
                <button type="submit" class="btn-action delete">삭제</button>
              </form>
            </div>
          <% } %>
        <% } %>
      </li>
    <% } %>
  </ul>
<% } else { %>
  <p style="color:gray;">아직 댓글이 없습니다.</p>
<% } %>

</body>
</html>

