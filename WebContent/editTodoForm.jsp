<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/header.jsp" />

<%
// 오늘 날짜를 yyyy-MM-dd 형식으로 JSP 변수 today에 저장
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
String today = sdf.format(new java.util.Date());
request.setAttribute("today", today);
%>

<html>
<head>
<title>TODO 수정</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<style>
.flatpickr-day.today {
	background: #fff59d !important;
	color: black;
	border-radius: 8px;
	font-weight: bold;
}

body {
	font-family: 'Malgun Gothic', sans-serif;
	background-color: #f4f6f9;
	margin: 0;
	padding: 0;
}

.container {
	width: 500px;
	margin: 80px auto;
	background-color: #fff;
	padding: 30px 40px;
	border-radius: 15px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

h2 {
	text-align: center;
	margin-bottom: 30px;
	color: #333;
}

label {
	display: block;
	margin-top: 15px;
	font-weight: bold;
	color: #444;
}

input[type="text"], input[type="number"], input[type="date"], textarea {
	width: 100%;
	padding: 10px;
	margin-top: 5px;
	border: 1px solid #ccc;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 14px;
}

textarea {
	resize: vertical;
}

button {
	margin-top: 25px;
	padding: 12px 20px;
	font-size: 15px;
	border: none;
	border-radius: 10px;
	cursor: pointer;
}

button[type="submit"] {
	background-color: #4CAF50;
	color: white;
	margin-right: 10px;
}

button[type="button"] {
	background-color: #ccc;
	color: #333;
}

button:hover {
	opacity: 0.9;
}

.no-login {
	text-align: center;
	padding: 50px;
	font-size: 18px;
}

.no-login a {
	display: inline-block;
	margin-top: 15px;
	text-decoration: none;
	color: #fff;
	background-color: #007BFF;
	padding: 10px 20px;
	border-radius: 8px;
}

.no-login a:hover {
	background-color: #0056b3;
}

/* 오늘 날짜 하이라이팅 (브라우저 지원 제한 있음) */
input[type="date"]::-webkit-datetime-edit-year-field:focus, input[type="date"]::-webkit-datetime-edit-month-field:focus,
	input[type="date"]::-webkit-datetime-edit-day-field:focus {
	background-color: #fff8a6; /* 노란 배경 */
	border-radius: 4px;
}

input[type="date"]::-webkit-calendar-picker-indicator {
	cursor: pointer;
}
</style>
</head>
<body>
	<div class="container">
		<c:if test="${empty sessionScope.loginUser}">
			<div class="no-login">
				<p>로그인이 필요합니다.</p>
				<a href="../login.jsp">로그인하러 가기</a>
			</div>
		</c:if>

		<c:if test="${not empty sessionScope.loginUser}">
			<h2>🛠️ TODO 수정</h2>
			<form action="<c:url value='/todo' />" method="post">
				<input type="hidden" name="action" value="update" /> <input
					type="hidden" name="todoId" value="${todo.todoId}" /> <input
					type="hidden" name="userId"
					value="${sessionScope.loginUser.userId}" /> <label for="subject">과목</label>
				<input type="text" id="subject" name="subject"
					value="${todo.subject}" required /> <label for="content">내용</label>
				<textarea id="content" name="content" rows="4" required>${todo.content}</textarea>

				<label for="deadline">기한</label> <input type="text" id="deadline"
					name="deadline"
					value="<fmt:formatDate value='${todo.deadline}' pattern='yyyy-MM-dd' />"
					min="${today}" required /> <label for="goal">목표 시간 (분)</label> <input
					type="number" id="goal" name="goal" min="1" value="${todo.goal}"
					required />

				<button type="submit">수정 완료</button>
				<a href="<c:url value='/todo?action=list' />"><button
						type="button">취소</button></a>
			</form>
		</c:if>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script>
		flatpickr("#deadline", {
			minDate : "today",
			defaultDate : "${todo.deadline}",
			locale : "ko",
		});
	</script>
</body>
</html>
