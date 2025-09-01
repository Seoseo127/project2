<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page contentType="text/plain;charset=UTF-8" %>
<%
String userId = ((model.dto.UserDTO)session.getAttribute("loginUser")).getUserId();
int total = 0;

try {
  Context ctx = new InitialContext();
  DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/yourDB");
  Connection conn = ds.getConnection();

  PreparedStatement pstmt = conn.prepareStatement(
    "SELECT NVL(SUM(TOTAL), 0) FROM TODO_LIST WHERE USER_ID = ?"
  );
  pstmt.setString(1, userId);
  ResultSet rs = pstmt.executeQuery();

  if (rs.next()) total = rs.getInt(1);

  rs.close(); pstmt.close(); conn.close();
} catch(Exception e) {
  total = 0;
}
out.print(total);
%>
