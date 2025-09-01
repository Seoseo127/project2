<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.ibatis.session.*, util.DBConnection, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%! public String toHourMin(int min) {
    int h = min / 60;
    int m = min % 60;
    return String.format("%02d:%02d", h, m);
}%>
<%

request.setCharacterEncoding("UTF-8");
String currentUserId = "hong01";


SqlSession sqlSession = DBConnection.getFactory().openSession();
List<Map<String, Object>> todoList = new ArrayList<>();
String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

try {
    todoList = sqlSession.selectList("TIMER.selectSubjectsFutureSorted", currentUserId);
} catch (Exception e) {
    e.printStackTrace();
} finally {
    sqlSession.close();
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>스터디 타이머</title>
    <style>
        .timer-box {
            border: 1px solid #ccc;
            padding: 16px;
            margin: 10px auto;
            border-radius: 10px;
            max-width: 600px;
            background-color: white;
        }

        .timer-box.cleared {
            background-color: #eee;
            color: #999;
            pointer-events: none;
            opacity: 0.6;
        }

        .timer-header {
            font-size: 20px;
            font-weight: bold;
        }

        .timer-display {
            font-family: monospace;
            font-size: 24px;
            margin: 10px 0;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="timer.js"></script> <%-- 타이머 기능 포함된 JS --%>
</head>
<body>

<h2 style="text-align:center">스터디 타이머</h2>

<% for (Map<String, Object> todo : todoList) {
    String subject = (String) todo.get("SUBJECT");
    int goal = todo.get("TOTAL_MINUTES") != null ? ((Number) todo.get("TOTAL_MINUTES")).intValue() : 0;
    int total = todo.get("TOTAL") != null ? ((Number) todo.get("TOTAL")).intValue() : 0;
    String clear = (todo.get("CLEAR") != null) ? todo.get("CLEAR").toString().substring(0, 10) : "";
    String safeId = java.net.URLEncoder.encode(subject, "UTF-8").replaceAll("%", "_");
    boolean isClearedToday = today.equals(clear);
%>
    <div class="timer-box <%= isClearedToday ? "cleared" : "" %>" id="timer-box-<%=safeId%>">
        <div class="timer-header"><%= subject %></div>
        <div class="timer-display" id="display-<%=safeId%>">00:00:00</div>
        목표시간: <input type="number" id="goal-<%=safeId%>" value="<%=goal%>" readonly> 분
        <br/>
        <button onclick="startTimer('<%=safeId%>')">시작</button>
        <button onclick="pauseTimer('<%=safeId%>')">일시정지</button>
        <button onclick="stopTimer('<%=safeId%>', '<%=subject%>')">정지</button>
    </div>
<% } %>

<script>
window.onload = function () {
    const today = new Date().toISOString().split("T")[0];
    fetch("timer?action=getTimers")
        .then(res => res.json())
        .then(data => {
            data.forEach(timer => {
                if (timer.clear === today) {
                    const box = document.getElementById(`timer-box-${timer.subject}`);
                    if (box) box.classList.add("cleared");
                }
            });
        });
};
</script>

</body>
</html>
