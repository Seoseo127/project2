<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.dto.UserDTO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원정보 수정</title>
  <style>
    body {
      font-family: 'Malgun Gothic', sans-serif;
      text-align: center;
      margin-top: 100px;
    }

    .input-box {
      margin: 12px 0;
    }

    input {
      padding: 10px;
      width: 240px;
      font-size: 14px;
    }

    button {
      margin-top: 20px;
      padding: 8px 16px;
      background-color: #333;
      color: white;
      border: none;
      cursor: pointer;
    }

    #deleteBtn {
      background-color: crimson;
    }

    #result {
      margin-top: 15px;
      color: green;
      font-weight: bold;
    }
  </style>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<%
  UserDTO user = (UserDTO) session.getAttribute("loginUser");
  Boolean checkPassed = (Boolean) session.getAttribute("checkPassed");

  if (user == null) {
%>
  <h3>로그인이 필요합니다.</h3>
  <a href="login.jsp">로그인 하러 가기</a>
<%
  } else if (checkPassed == null || !checkPassed) {
%>
  <h3>비밀번호 인증 후 접근 가능합니다.</h3>
  <a href="check_pw.jsp">비밀번호 확인하러 가기</a>
<%
  } else {
%>

  <h2>회원정보 수정</h2>

  <form id="updateForm">
    <input type="hidden" name="userId" value="<%= user.getUserId() %>">

    <div class="input-box">
      <input type="password" name="password" placeholder="새 비밀번호 입력">
    </div>
    <div class="input-box">
      <input type="text" name="nickname" value="<%= user.getNickname() %>" required>
    </div>

    <button type="submit">수정 완료</button>
  </form>

  <button id="deleteBtn">회원 탈퇴</button>

  <div id="result"></div>

  <script>
    // 회원정보 수정
    $("#updateForm").on("submit", function(e) {
      e.preventDefault();

      const data = {
        userId: $("input[name=userId]").val(),
        password: $("input[name=password]").val(),
        nickname: $("input[name=nickname]").val()
      };

      $.ajax({
        url: "user/update",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(res) {
          $("#result").text(res.message);
          if (res.success) {
            setTimeout(() => location.href = "mypage.jsp", 1000);
          }
        },
        error: function() {
          alert("수정 요청 중 오류가 발생했습니다.");
        }
      });
    });

    // 회원 탈퇴
    $("#deleteBtn").on("click", function () {
      if (!confirm("정말 탈퇴하시겠습니까?")) return;

      const userId = $("input[name=userId]").val();

      $.ajax({
        url: "user/delete",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ userId }),
        success: function(res) {
          alert(res.message);
          if (res.success) {
            location.href = "login.jsp";
          }
        },
        error: function() {
          alert("탈퇴 요청 중 오류가 발생했습니다.");
        }
      });
    });
  </script>

<% } %>

</body>
</html>