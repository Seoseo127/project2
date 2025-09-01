<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/header.jsp" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>





<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TODO 목록</title>
<style>
body {
	padding: 20px;
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f8f9fa;
}

.todo-container {
	max-width: 1000px;
	margin: auto;
	background-color: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

h2 {
	text-align: center;
	margin-bottom: 30px;
	color: #0077b6;
}

.button-group {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.button-group .left-buttons, .button-group .right-buttons {
	display: flex;
	gap: 10px;
}

.btn {
	display: inline-block;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
	border-radius: 6px;
	font-weight: bold;
	transition: all 0.2s ease-in-out;
	border: 1px solid transparent;
	cursor: pointer;
}

.btn-primary {
	background-color: #007bff;
	color: white;
}

.btn-primary:hover {
	background-color: #0056b3;
}

.btn-secondary {
	background-color: #6c757d;
	color: white;
}

.btn-secondary:hover {
	background-color: #565e64;
}

.btn-info {
	background-color: #17a2b8;
	color: white;
}

.btn-info:hover {
	background-color: #117a8b;
}

.btn-outline-secondary {
	background-color: white;
	color: #6c757d;
	border: 1px solid #6c757d;
}

.btn-outline-secondary:hover {
	background-color: #6c757d;
	color: white;
}

.btn-outline-success {
	background-color: white;
	color: #28a745;
	border: 1px solid #28a745;
}

.btn-outline-success:hover {
	background-color: #28a745;
	color: white;
}

table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
}

thead {
	background-color: #e9ecef;
}

th, td {
	padding: 12px;
	border-bottom: 1px solid #dee2e6;
}

.badge {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 8px;
	font-size: 12px;
	font-weight: bold;
	color: #fff;
}

.badge-warning {
	background-color: #f0ad4e;
}

.badge-success {
	background-color: #5cb85c;
}

.action-buttons form {
	display: inline-block;
	margin: 0 2px;
}

.action-buttons .btn {
	font-size: 13px;
	padding: 4px 10px;
}

.text-muted {
	color: #6c757d;
}
</style>
</head>

<body>
	<div class="todo-container">
		<br>
		<br>
		<br>
		<h2 class="text-center mb-4">📋 TODO 목록</h2>

		<c:if test="${not empty sessionScope.loginUser}">
			<div class="button-group">
				<%-- ✅ 버튼 그룹을 위한 div 추가 --%>
				<div class="left-buttons">
					<%-- ✅ 왼쪽 버튼 그룹 --%>
					<a href="<c:url value='/timer?action=main' />" class="btn btn-info"> 뒤로가기 </a>
					<%-- ✅ 메인 버튼 추가 --%>
				</div>
				<div class="right-buttons">
					<%-- ✅ 오른쪽 버튼 그룹 --%>
					<a href="<c:url value='/todo?action=add' />"
						class="btn btn-primary">+ 할 일 추가</a> <a
						href="<c:url value='/todo?action=past' />"
						class="btn btn-secondary">완료된 할 일 보기</a>
				</div>
			</div>
		</c:if>

		<table class="table table-striped text-center align-middle">
			<thead class="table-light">
				<tr>
					<th>과목</th>
					<th>내용</th>
					<th>기한</th>
					<th>목표시간</th>
					<th>상태</th>
					<th>관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="todo" items="${todoList}">
					<tr>
						<td>${todo.subject}</td>
						<td>${todo.content}</td>
						<td><fmt:formatDate value="${todo.deadline}"
								pattern="yyyy년 M월 d일 HH시" /></td>
						<td>${todo.goal}분</td>
						<td><c:choose>
								<c:when test="${todo.status eq '완료'}">
									<span class="badge badge-success">완료</span>
								</c:when>
								<c:otherwise>
									<span class="badge badge-warning">진행중</span>
								</c:otherwise>
							</c:choose></td>
						<td class="action-buttons">
							<form action="<c:url value='/todo' />" method="get">
								<input type="hidden" name="action" value="edit" /> <input
									type="hidden" name="todoId" value="${todo.todoId}" />
								<button type="submit" class="btn btn-outline-secondary btn-sm">수정</button>
							</form>
							<form action="<c:url value='/todo' />" method="post"
								onsubmit="return confirm('정말 완료 처리하시겠습니까?');">
								<input type="hidden" name="action" value="complete" /> <input
									type="hidden" name="todoId" value="${todo.todoId}" /> <input
									type="hidden" name="subject" value="${todo.subject}" />
								<button type="submit" class="btn btn-outline-success btn-sm">완료</button>
							</form>
						</td>
					</tr>
				</c:forEach>

				<c:if test="${empty todoList}">
					<tr>
						<td colspan="6" class="text-muted text-center">할 일이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
