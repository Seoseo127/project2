<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>스터디장 스터디 등록</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 30px; max-width: 600px; margin: auto; }
        label { display: block; margin-top: 15px; font-weight: bold; }
        input[type="text"], textarea { width: 100%; padding: 8px; margin-top: 5px; }
        button { margin-top: 20px; padding: 10px 20px; background-color: #48cae4; border: none; border-radius: 10px; color: white; cursor: pointer; }
        button:hover { background-color: #00b4d8; }
    </style>
</head>
<body>
    <h1>📋 신규 스터디 생성</h1>
    <form action="register_leader_process.jsp" method="post">
        <label for="name">스터디 이름</label>
        <input type="text" id="name" name="name" required>

        <label for="description">스터디 설명</label>
        <textarea id="description" name="description" rows="4" required></textarea>

        <label for="duration">기간 (일)</label>
        <input type="number" id="duration" name="duration" min="1" required>

        <button type="submit">스터디 생성</button>
    </form>
</body>
</html>
