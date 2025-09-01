<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.apache.ibatis.session.*, util.DBConnection, java.util.*" %>
<%
  String userId = request.getParameter("userId");
  String[] subjectsParam = request.getParameterValues("subjects");
  List<String> subjects = subjectsParam != null ? Arrays.asList(subjectsParam) : new ArrayList<>();

  SqlSession sqlSession = DBConnection.getFactory().openSession();

  Map<String, Object> paramMap = new HashMap<>();
  paramMap.put("userId", userId);
  paramMap.put("subjects", subjects);

  List<Map<String, Object>> subjectList = new ArrayList<>();
  if (!subjects.isEmpty()) {
    subjectList = sqlSession.selectList("TIMER.selectSubjectsWithTimeByUserIdFiltered", paramMap);
  }
  sqlSession.close();
%>

<% for (Map<String, Object> row : subjectList) {
     String subject = (String) row.get("SUBJECT");
     int totalMin = row.get("TOTAL_MINUTES") != null ? ((java.math.BigDecimal) row.get("TOTAL_MINUTES")).intValue() : 0;
     int total = row.get("TOTAL") != null ? ((java.math.BigDecimal) row.get("TOTAL")).intValue() : 0;
     if (totalMin == 0) totalMin = 1;
     int percent = Math.min(100, (int)((double) total / totalMin * 100));
     String color = (percent == 100) ? "#87CEFA" : "#007bff";
     String textColor = "black";
%>
<div class="bar-section">
  <div class="subject"><%= subject %></div>
  <div class="bar-background">
    <div class="bar-fill" style="width: <%= percent %>%; background: <%= color %>;"></div>
    <span class="percent-text" style="color: <%= textColor %>;"><%= percent %>%</span>
  </div>
</div>
<% } %>
