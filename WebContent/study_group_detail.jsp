<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>스터디 상세보기</title>
    <style>
        body { font-family: 'Segoe UI'; background-color: #f2f2f2; text-align: center; padding: 40px; }
        .box { background: #F7FBFE; padding: 30px; display: inline-block; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { margin-bottom: 20px; }
        p { font-size: 18px; line-height: 1.6; }
        a { text-decoration: none; color: #0077cc; display: block; margin-top: 30px; }
    </style>
</head>
<body>

    <div class="box">
        <h2>스터디 그룹 상세정보</h2>
        <p><strong>📌 이름:</strong> ${group.name}</p>
        <p><strong>👑 스터디장:</strong> ${group.leaderId}</p>
        <p><strong>⏱ 기간:</strong> ${group.duration}일</p>
        <p><strong>📅 생성일:</strong> ${group.createdAt}</p>

        <a href="studyGroup">📋 목록으로 돌아가기</a>
    </div>

</body>
</html>
