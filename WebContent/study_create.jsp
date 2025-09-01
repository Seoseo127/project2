<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page session="true"%>
<%@ page import="model.dto.UserDTO"%>

<%
UserDTO user = (UserDTO) session.getAttribute("loginUser"); // ✅ 세션 변수명 수정
if (user == null) {
	response.sendRedirect("login.jsp"); // 로그인 안 했으면 로그인 페이지로
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스터디 생성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/study_create.css" />
</head>
<body>

<div class="study-form">
    <h2>📌 새 스터디 생성</h2>

    <form action="${pageContext.request.contextPath}/study/create" method="post">
        <input type="hidden" name="action" value="create" />

        <label>스터디명:
            <input type="text" name="name" required />
        </label>

        <label>스터디장: <%= user.getUserId() %></label>
        <input type="hidden" name="leaderId" value="<%= user.getUserId() %>" />

        <label>진행 기간 (일):
            <input type="number" name="duration" required />
        </label>

        <label>최대 인원 수 (최대 10명):
            <input type="number" name="maxMember" min="1" max="10" required />
        </label>

        <label>설명:
            <textarea name="description" rows="5" placeholder="스터디에 대한 설명을 입력해주세요."></textarea>
        </label>

        <button type="submit">스터디 생성하기</button>
    </form>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/allGroups">← 스터디 목록으로 돌아가기</a>
    </div>
</div>

</body>
</html>