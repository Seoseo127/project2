<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>📌 게시글 작성</title>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	max-width: 600px;
	margin: 80px auto;
	padding: 0 20px;
}

h2 {
	text-align: center;
	margin-bottom: 40px;
}

.form-group {
	margin-bottom: 20px;
}

input[type="text"], select, textarea {
	width: 100%;
	padding: 10px;
	font-size: 14px;
	border: 1px solid #ccc;
	border-radius: 8px;
	box-sizing: border-box;
}

textarea {
	resize: vertical;
	height: 200px;
}

button {
	background-color: #333;
	color: white;
	border: none;
	padding: 10px 18px;
	border-radius: 8px;
	cursor: pointer;
}

button:hover {
	background-color: #555;
}

.clear {
	clear: both;
}
</style>

<script>
	function toggleStudentCategory() {
		const main = document.getElementById("mainCategory").value;
		const subGroup = document.getElementById("studentSubGroup");

		if (main === "학생") {
			subGroup.style.display = "block";
			const subValue = document.getElementById("studentSubSelect").value;
			document.getElementById("category").value = subValue;
		} else {
			subGroup.style.display = "none";
			document.getElementById("category").value = main;
		}
	}

	function updateCategory(select) {
		document.getElementById("category").value = select.value;
	}

	window.onload = function() {
		toggleStudentCategory();
	};
</script>
</head>
<body>

	<h2>📌 게시글 작성</h2>

	<form action="${pageContext.request.contextPath}/community/write"
		method="post" enctype="multipart/form-data">

		<!-- 로그인된 사용자 아이디 전달 -->
		<input type="hidden" name="userId"
			value="${sessionScope.loginUser.userId}" />

		<!-- 실제 전송될 카테고리 -->
		<input type="hidden" name="category" id="category" value="공부" />

		<div class="form-group">
			<input type="text" name="title" placeholder="제목을 입력하세요" required>
		</div>

		<!-- 메인 카테고리 -->
		<div class="form-group">
			<label>카테고리</label> <select id="mainCategory"
				onchange="toggleStudentCategory()">
				<option value="공부">공부</option>
				<option value="자유">자유</option>
				<option value="학생">학생</option>
			</select>
		</div>

		<!-- 학생 하위 카테고리 -->
		<div class="form-group" id="studentSubGroup" style="display: none;">
			<label>구분</label> <select id="studentSubSelect"
				onchange="updateCategory(this)">
				<option value="고등학생">고등학생</option>
				<option value="대학생">대학생</option>
				<option value="취준생">취준생</option>
				<option value="직장인">직장인</option>
			</select>
		</div>

		<div class="form-group">
			<textarea name="pContent" placeholder="내용을 입력하세요" required></textarea>
		</div>

		<div class="form-group">
			<input type="file" name="uploadFile" accept="image/*,video/*">
		</div>

		<!-- 등록 버튼 (오른쪽) -->
		<div style="text-align: right; margin-top: 10px;">
			<button type="submit">등록</button>
		</div>

		<div style="text-align: right; margin-top: 10px;">
			<button type="button"
				onclick="location.href='${pageContext.request.contextPath}/CommunityListController?category=all&keyword='">
				목록으로</button>
		</div>

	</form>

</body>
</html>
