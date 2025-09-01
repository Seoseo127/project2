<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기</title>
  <style>
    body {
      text-align: center;
      font-family: 'Malgun Gothic', sans-serif;
      margin-top: 100px;
    }

    #top-area {
      position: absolute;
      top: 20px;
      left: 20px;
    }

    #goLoginBtn {
      padding: 6px 12px;
      font-size: 12px;
      background-color: #f0f0f0;
      border: 1px solid #ccc;
      cursor: pointer;
    }

    .input-box {
      margin: 10px 0;
    }

    input {
      padding: 8px;
      width: 240px;
    }

    button#findBtn {
      padding: 8px 16px;
      background: #333;
      color: white;
      border: none;
      margin-top: 12px;
      cursor: pointer;
    }

    #result {
      margin-top: 20px;
      color: green;
      font-weight: bold;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

  <!-- 상단 로그인 이동 버튼 (항상 표시) -->
  <div id="top-area">
    <button id="goLoginBtn">← 로그인 화면으로 이동</button>
  </div>

  <h2>비밀번호 찾기</h2>

  <div class="input-box">
    <input type="text" id="userId" placeholder="아이디">
  </div>
  <div class="input-box">
    <input type="email" id="email" placeholder="이메일">
  </div>
  <button id="findBtn">비밀번호 찾기</button>

  <div id="result"></div>

  <script>
    // 비밀번호 찾기 요청
    $("#findBtn").on("click", function() {
      const data = {
        userId: $("#userId").val(),
        email: $("#email").val()
      };

      $.ajax({
        url: "user/findpw",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(res) {
          $("#result").text(res.message);
        }
      });
    });

    // 로그인 이동
    $("#goLoginBtn").on("click", function() {
      location.href = "login.jsp";
    });
  </script>
</body>
</html>
