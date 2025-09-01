<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="org.apache.ibatis.io.Resources" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory" %>
<%@ page import="org.apache.ibatis.session.SqlSessionFactoryBuilder" %>
<%@ page import="model.dto.UserDTO" %>
<%@ page import="java.io.Reader" %> <%-- Reader 클래스 임포트 --%>

<%
    UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
%>
<p>로그인이 필요합니다.</p>
<%
        return;
    }
    String userId = loginUser.getUserId();

    String yearStr = request.getParameter("year");
    String monthStr = request.getParameter("month");
    String dayStr = request.getParameter("day");

    if (yearStr == null || monthStr == null || dayStr == null) {
%>
<p>잘못된 요청입니다.</p>
<%
        return;
    }

    int year = 0, month = 0, day = 0;
    try {
        year = Integer.parseInt(yearStr);
        month = Integer.parseInt(monthStr);
        day = Integer.parseInt(dayStr);
    } catch(Exception e) {
%>
<p>잘못된 날짜 형식입니다.</p>
<%
        return;
    }

    // 쿼리 파라미터용 SimpleDateFormat (필요하다면)
    // SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 현재는 String.format으로 대체됨

    // ✅ 출력용 SimpleDateFormat 추가
    SimpleDateFormat displaySdf = new SimpleDateFormat("yyyy-MM-dd");

    String dateStr = String.format("%04d-%02d-%02d", year, month, day);

    SqlSession sqlSession = null;
    List<Map<String,Object>> todoList = new ArrayList<>();
    try {
        Reader reader = Resources.getResourceAsReader("util/config.xml");
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
        reader.close();

        sqlSession = sqlSessionFactory.openSession();

        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("userId", userId);
        // ✅ 쿼리 파라미터 이름 'selectedDate'로 수정
        paramMap.put("selectedDate", dateStr); 

        todoList = sqlSession.selectList("CALENDAR.selectTodosByDate", paramMap);

    } catch(Exception e) {
        e.printStackTrace();
        // ✅ 오류 발생 시 사용자에게 메시지 표시
        out.println("<p>할 일 목록을 불러오는 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.</p>");
    } finally {
        if (sqlSession != null) sqlSession.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= year %>년 <%= month %>월 <%= day %>일 할 일 목록</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f4f4f4;
    }
    h2 {
        color: #333;
        border-bottom: 2px solid #007bff;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }
    ul {
        list-style: none;
        padding: 0;
    }
    li {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 15px;
        padding: 15px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    li strong {
        font-size: 1.2em;
        color: #007bff;
    }
    li br {
        margin-bottom: 5px;
    }
    p {
        color: #555;
        font-size: 1.1em;
    }
</style>
</head>
<body>

<h2><%= year %>년 <%= month %>월 <%= day %>일 할 일 목록</h2>

<% if (todoList == null || todoList.isEmpty()) { %>
    <p>이 날짜에 할 일이 없습니다.</p>
<% } else { %>
    <ul>
    <% for (Map<String,Object> todo : todoList) { 
        // ✅ CREATED_AT과 DEADLINE을 Date 객체로 가져온 후 포맷팅
        Date createdAtDate = null;
        Object createdAtObj = todo.get("CREATED_AT");
        if (createdAtObj instanceof java.sql.Timestamp) {
            createdAtDate = new Date(((java.sql.Timestamp) createdAtObj).getTime());
        } else if (createdAtObj instanceof java.util.Date) {
            createdAtDate = (java.util.Date) createdAtObj;
        }

        Date deadlineDate = null;
        Object deadlineObj = todo.get("DEADLINE");
        if (deadlineObj instanceof java.sql.Timestamp) {
            deadlineDate = new Date(((java.sql.Timestamp) deadlineObj).getTime());
        } else if (deadlineObj instanceof java.util.Date) {
            deadlineDate = (java.util.Date) deadlineObj;
        }
    %>
        <li>
            <strong><%= todo.get("SUBJECT") %></strong>
            <br>상태: <%= todo.get("STATUS") %>
            <br>목표 공부 시간: <%= todo.get("GOAL") != null ? todo.get("GOAL") + "분" : "없음" %>
            <br>공부 시간: <%= todo.get("STUDY_TIME") != null ? todo.get("STUDY_TIME") + "분" : "기록 없음" %>
            <br>생성일: <%= createdAtDate != null ? displaySdf.format(createdAtDate) : "없음" %>
            <br>마감일: <%= deadlineDate != null ? displaySdf.format(deadlineDate) : "없음" %>
        </li>
    <% } %>
    </ul>
<% } %>

</body>
</html>