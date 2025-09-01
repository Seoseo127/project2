<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <style>
    body {
      margin: 0;
      font-family: 'Malgun Gothic', sans-serif;
      background-color: #fff;
      text-align: center;
    }

    .container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
    }

    .logo-wrapper {
      margin-bottom: 40px;
    }

    #finalLogo {
      width: 600px;
      display: none;
      opacity: 0;
      transition: opacity 0.5s ease-in-out;
    }

    #animatedLogo {
      width: 600px;
    }

    .login-box {
      width: 240px;
    }

    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 10px;
      margin-bottom: 10px;
      border: 1px solid #ccc;
      font-size: 14px;
      border-radius: 4px;
    }

    button {
      width: 100%;
      padding: 10px;
      background-color: #333;
      color: #fff;
      border: none;
      font-size: 14px;
      border-radius: 4px;
      cursor: pointer;
    }

    .link-area {
      margin-top: 12px;
      font-size: 12px;
    }

    .link-area a {
      color: #007bff;
      text-decoration: none;
      margin: 0 5px;
    }

    /* 🧾 커스텀 팝업 스타일 */
    #customAlert {
      display: none;
      position: fixed;
      top: 30%;
      left: 50%;
      transform: translateX(-50%);
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      padding: 20px;
      z-index: 1000;
      width: 280px;
    }

    #overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.4);
      z-index: 999;
    }

    #customAlert button {
      margin-top: 10px;
      padding: 6px 12px;
      border: none;
      background: #800000;
      color: #fff;
      border-radius: 5px;
      cursor: pointer;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
  <div class="container">
    <div class="logo-wrapper">
      <img id="finalLogo" src="images/logo.png" alt="로고" />
      <video id="animatedLogo" autoplay muted playsinline>
        <source src="images/animation_logo.webm" type="video/webm" />
        브라우저가 video 태그를 지원하지 않습니다.
      </video>
    </div>

    <form id="loginForm" class="login-box">
      <input type="text" name="userId" placeholder="아이디" required>
      <input type="password" name="password" placeholder="비밀번호" required>
      <button type="submit">로그인</button>
      <div class="link-area">
        <a href="find_pw.jsp">비밀번호 찾기</a>
        <a href="signup.jsp">회원가입</a>
      </div>
    </form>
  </div>

  <!-- ✅ 커스텀 팝업 요소 -->
  <div id="overlay"></div>
  <div id="customAlert">
    <p id="alertMessage" style="margin: 0; font-size: 16px; font-weight: bold;"></p>
    <button onclick="closeAlert()">확인</button>
  </div>

  <script>
    const video = document.getElementById('animatedLogo');
    const finalLogo = document.getElementById('finalLogo');

    video.addEventListener('ended', function () {
      video.style.display = 'none';
      finalLogo.style.display = 'block';
      setTimeout(() => {
        finalLogo.style.opacity = '1';
      }, 50);
    });

    function showAlert(message, callback) {
      $("#alertMessage").text(message);
      $("#overlay").show();
      $("#customAlert").show();
      $("#customAlert button").off("click").on("click", function () {
        closeAlert();
        if (callback) callback(); // 콜백 실행
      });
    }

    function closeAlert() {
      $("#customAlert").hide();
      $("#overlay").hide();
    }

    $("#loginForm").on("submit", function(e) {
      e.preventDefault();
      const data = {
        userId: $("input[name=userId]").val(),
        password: $("input[name=password]").val()
      };

      $.ajax({
        url: "user/login",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(res) {
          if (res.success) {
            showAlert(res.userName + "님, 어서 오십시오!", function() {
              if (res.role === "admin") {
                window.location.href = "admin/admin_main.jsp";
              } else {
                window.location.href = "CommunityListController?category=all";
              }
            });
          } else {
            showAlert(res.message);
          }
        }
      });
    });
  </script>

  <c:if test="${param.logout eq 'true'}">
    <script>
      $(document).ready(function () {
        showAlert("로그아웃 되었습니다", () => {
          if (window.history.replaceState) {
            const url = new URL(window.location);
            url.searchParams.delete("logout");
            window.history.replaceState(null, "", url.toString());
          }
        });
      });
    </script>
  </c:if>
</body>
</html>
