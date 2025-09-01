<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head><title>Oracle DB 연결 테스트</title></head>
<body>

<%
    // JDBC 드라이버 정보
    String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@192.168.18.10:1521:xe"; // SERVICE NAME 방식
    String user = "PROJECT_2";  // 또는 프로젝트용 계정
    String password = "pj2"; // 실제 비밀번호

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, user, password);
        out.println("<h3>DB 연결 성공!</h3>");

        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM PROJECT_2.USERS WHERE ROWNUM = 1");

        while (rs.next()) {
            out.println("<p>USER_ID: " + rs.getString("USER_ID") + "</p>");
        }
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>DB 연결 실패: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

</body>
</html>