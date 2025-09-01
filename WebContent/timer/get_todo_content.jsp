<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="service.TodoService" %>
<%@ page import="model.dto.TodoDTO" %>

<%
String content = "";
try {
    String todoIdStr = request.getParameter("todoId");
    if (todoIdStr != null && !todoIdStr.isEmpty()) {
        int todoId = Integer.parseInt(todoIdStr);
        TodoService service = new TodoService();
        TodoDTO dto = service.getTodoById(todoId);
        if (dto != null && dto.getContent() != null) {
            content = dto.getContent();
        }
    }
} catch (Exception e) {
    content = "오류 발생";
}
out.print(content);
%>
