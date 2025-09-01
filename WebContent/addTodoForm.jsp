<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<%
  java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
  String today = sdf.format(new java.util.Date());
  request.setAttribute("today", today);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>할 일 추가</title>
  <!--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">-->
  <link href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" rel="stylesheet">
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

    .form-container {
      max-width: 600px;
      margin: 80px auto;
      background-color: #fff;
      padding: 30px 40px;
      border-radius: 15px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    }

    h1 {
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

    input[type="text"], input[type="number"], textarea {
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

    .d-grid {
      margin-top: 25px;
    }

    .btn {
      padding: 10px 20px;
      border-radius: 10px;
      font-size: 15px;
    }

    .btn-primary {
      background-color: #4CAF50;
      border: none;
    }

    .btn-secondary {
      background-color: #ccc;
      color: #333;
      border: none;
    }

    .btn:hover {
      opacity: 0.9;
    }
  </style>
</head>
<body>
  <div class="form-container">
    <c:if test="${empty sessionScope.loginUser}">
      <div class="text-center">
        <p>로그인이 필요합니다.</p>
        <a href="../login.jsp" class="btn btn-primary">로그인하러 가기</a>
      </div>
    </c:if>

    <c:if test="${not empty sessionScope.loginUser}">
      <h1>📝 새 할 일 작성</h1>
      <form action="<c:url value='/todo' />" method="post">
        <input type="hidden" name="action" value="add" />
        <input type="hidden" name="userId" value="${sessionScope.loginUser.userId}" />

        <label for="subject">과목 <span class="text-danger">*</span></label>
        <input type="text" id="subject" name="subject" required />

        <label for="content">내용</label>
        <textarea id="content" name="content" rows="3"></textarea>

        <label for="deadline">마감일</label>
        <input type="text" id="deadline" name="deadline" required />

        <label for="goal">목표 시간 (분)</label>
        <input type="number" id="goal" name="goal" min="1" value="0" required />

        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
          <a href="<c:url value='/todo?action=list' />" class="btn btn-secondary me-md-2">취소</a>
          <button type="submit" class="btn btn-primary">저장</button>
        </div>
      </form>
    </c:if>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
  
  <script>
    // ✅ flatpickr 초기화 코드를 DOMContentLoaded 이벤트 리스너 안에 넣음
    document.addEventListener('DOMContentLoaded', function() {
      flatpickr("#deadline", {
        minDate: "today",
        dateFormat: "Y-m-d",
        locale: "ko"
      });
    });
  </script>
</body>
</html>
