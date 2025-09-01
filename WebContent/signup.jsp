<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
body {
	text-align: center;
	font-family: 'Malgun Gothic', sans-serif;
	margin-top: 80px;
}

/* 공통 인풋박스 */
.input-box {
	margin: 10px 0;
}

input, select {
	padding: 8px;
	width: 240px;
	font-size: 14px;
}

/* 버튼 스타일 통일 */
.btn {
	padding: 8px 16px;
	background: #4A2F27;
	color: white;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-size: 14px;
	transition: background-color 0.2s ease;
}

.btn:hover {
	background-color: #6e3e34;
}

/* 돌아가기 버튼 (a태그용 버튼 스타일) */
.back-btn {
	display: inline-block;
	margin-bottom: 10px;
	background-color: #f0f0f0;
	color: #333;
	font-size: 13px;
	padding: 6px 12px;
	border: 1px solid #ccc;
	border-radius: 6px;
	text-decoration: none;
	transition: background-color 0.2s;
}

.back-btn:hover {
	background-color: #ddd;
}

/* 가입 결과 */
#result {
	margin-top: 20px;
	font-weight: bold;
	color: green;
}
</style>

<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	<!-- 상단 돌아가기 버튼 -->
	<a href="login.jsp" class="back-btn">← 로그인 화면으로 돌아가기</a>

	<h2>회원가입</h2>

	<form id="signupForm">
		<div class="input-box">
			<input type="text" name="userId" placeholder="아이디" required>
		</div>
		<div class="input-box">
			<input type="password" name="password" placeholder="비밀번호" required>
		</div>
		<div class="input-box">
			<input type="text" name="nickname" placeholder="닉네임" required>
		</div>
		<div class="input-box">
			<input type="email" name="email" placeholder="이메일">
		</div>
		<div class="input-box">
			<input type="text" name="userName" placeholder="이름" required>
		</div>
		<div class="input-box">
			<select name="userGrade">
				<option value="고등학생">고등학생</option>
				<option value="대학생">대학생</option>
				<option value="취준생">취준생</option>
				<option value="직장인">직장인</option>
			</select>
		</div>
		<button type="submit" class="btn">회원가입</button>
	</form>

	<div id="result"></div>

	<script>
		$("#signupForm").on("submit", function(e) {
			e.preventDefault();
			const data = {
				userId : $("input[name=userId]").val(),
				password : $("input[name=password]").val(),
				nickname : $("input[name=nickname]").val(),
				email : $("input[name=email]").val(),
				userName : $("input[name=userName]").val(),
				userGrade : $("select[name=userGrade]").val()
			};

			$.ajax({
				url : "user/signup",
				method : "POST",
				contentType : "application/json",
				data : JSON.stringify(data),
				success : function(res) {
					alert(res.message);
					if (res.success)
						location.href = "login.jsp";
				}
			});
		});
	</script>
</body>
</html>
