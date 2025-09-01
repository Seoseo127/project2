<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="header.jsp" %> <!-- ✅ 공통 네비게이션 사용 -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>커뮤니티</title>
  <link rel="stylesheet" href="css/menu_bar.css">
  <style>
    .container {
      width: 90%;
      max-width: 900px;
      margin: 40px auto;
      padding: 20px;
    }
    .page-title {
      font-size: 24px;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
  <div class="container" style="margin-top: 80px;">

    <jsp:include page="post_list.jsp" /> <!-- ✅ 목록 불러오기 -->
  </div>
</body>
</html>


