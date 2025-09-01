<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>비밀번호 확인</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body {
      font-family: 'Malgun Gothic', sans-serif;
      text-align: center;
      margin-top: 120px;
    }

    input {
      padding: 10px;
      width: 240px;
      font-size: 14px;
      margin-bottom: 10px;
    }

    button {
      padding: 8px 16px;
      background-color: #333;
      color: white;
      border: none;
      cursor: pointer;
    }

    #result {
      margin-top: 10px;
      color: red;
    }
  </style>
</head>
<body>

<h2>비밀번호 확인</h2>
<form id="pwForm">
  <input type="password" name="password" placeholder="비밀번호 입력" required>
  <button type="submit">확인</button>
</form>
<div id="result"></div>

<script>
  $("#pwForm").on("submit", function(e) {
    e.preventDefault();
    const pw = $("input[name=password]").val();

    $.ajax({
      url: "user/checkpw",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ password: pw }),
      success: function(res) {
        if (res.success) {
          location.href = "edit_info.jsp";
        } else {
          $("#result").text("비밀번호가 일치하지 않습니다.");
        }
      }
    });
  });
</script>

</body>
</html>