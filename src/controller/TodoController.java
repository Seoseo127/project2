package controller;

import model.dto.TimerTodoDTO;
import model.dto.TodoDTO;
import service.TimerService;
import service.TodoService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import model.dto.UserDTO;

@WebServlet("/todo")
public class TodoController extends HttpServlet {
	private static final long serialVersionUID = 1L; // serialVersionUID 추가
	private final TodoService service = new TodoService();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		String action = request.getParameter("action");
		String userId = loginUser.getUserId();
		if ("list".equals(action)) {
			List<TodoDTO> todoList = service.getTodoList(userId);
			request.setAttribute("todoList", todoList);
			request.getRequestDispatcher("/todo_list.jsp").forward(request, response);
		} else if ("past".equals(action)) { // pastTodo_list.jsp를 위한 액션
			List<TimerTodoDTO> pastList = service.getCompletedTodoWithTimer(userId);
			request.setAttribute("pastTodoList", pastList);
			
            // 오늘 날짜를 JSP로 전달 (DEADLINE 비교용)
            request.setAttribute("todayDate", new Date());

			request.getRequestDispatcher("/pastTodo_List.jsp").forward(request, response);
		} else if ("edit".equals(action)) {
			int todoId = Integer.parseInt(request.getParameter("todoId"));
			TodoDTO todo = service.getTodoById(todoId);
			request.setAttribute("todo", todo);
			request.getRequestDispatcher("/editTodoForm.jsp").forward(request, response);
		} else if ("add".equals(action)) {
		    // 새로 추가할 todo, 비어있는 객체 전달
		    TodoDTO emptyTodo = new TodoDTO();
		    request.setAttribute("todo", emptyTodo);
		    request.getRequestDispatcher("/addTodoForm.jsp").forward(request, response);
		}
		// 다른 doGet 액션들이 있다면 여기에 추가하세요.
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");
		UserDTO loginUser = (UserDTO) request.getSession().getAttribute("loginUser");

		if (loginUser == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		String userId = loginUser.getUserId();

		if ("add".equals(action)) {
			String subject = request.getParameter("subject");
			String content = request.getParameter("content");
			String deadlineStr = request.getParameter("deadline");
			int goal = Integer.parseInt(request.getParameter("goal"));

			TodoDTO dto = new TodoDTO();
			dto.setUserId(userId);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setDeadline(java.sql.Date.valueOf(deadlineStr));
			dto.setGoal(goal);
			dto.setStatus("미완료");

			service.insertTodo(dto);

			TimerService timerService = new TimerService();
			timerService.saveGoalTime(userId, subject, goal);

			response.sendRedirect("todo?action=list");
		} else if ("update".equals(action)) {
			TodoDTO dto = new TodoDTO();
			dto.setTodoId(Integer.parseInt(request.getParameter("todoId")));
			dto.setUserId(request.getParameter("userId"));
			dto.setSubject(request.getParameter("subject"));
			dto.setContent(request.getParameter("content"));

			String deadlineStr = request.getParameter("deadline");
			if (deadlineStr != null && !deadlineStr.isEmpty()) {
				dto.setDeadline(java.sql.Date.valueOf(deadlineStr));
			}

			dto.setGoal(Integer.parseInt(request.getParameter("goal")));
			service.updateTodo(dto);
			response.sendRedirect("todo?action=list");

		} else if ("complete".equals(action)) {
			int todoId = Integer.parseInt(request.getParameter("todoId"));
			userId = ((UserDTO) request.getSession().getAttribute("loginUser")).getUserId();
			String subject = request.getParameter("subject");

			service.completeTodo(todoId, userId, subject);
			response.sendRedirect("todo?action=list");
		} else if ("delete".equals(action)) {
			int todoId = Integer.parseInt(request.getParameter("todoId"));
			service.deleteTodo(todoId);
			response.sendRedirect("todo?action=past");
		} else if ("feedback".equals(action)) {
		    // ✅ Content-Type 설정은 가능한 빨리
		    response.setContentType("application/json; charset=UTF-8");
		    // ✅ 응답 스트림을 초기화 (이전의 어떤 내용도 보내지 않도록)
		    // response.reset(); // reset() 대신 resetBuffer()를 시도해볼 수도 있지만, 일단 reset() 유지
		    
		    int todoId = Integer.parseInt(request.getParameter("todoId"));
		    String feedback = request.getParameter("feedback");
		    
		    try {
		        service.updateFeedbackByTodoId(todoId, feedback); 
		        System.out.println("DEBUG: TodoController - updateFeedbackByTodoId successful.");
		        
		        // ✅ 응답이 이미 커밋되었는지 확인하는 로그 추가
		        System.out.println("DEBUG: Response committed before writing? " + response.isCommitted());

		        try (PrintWriter out = response.getWriter()) {
		            out.print("{\"status\":\"success\"}"); 
		            out.flush();
		        }
		        System.out.println("DEBUG: TodoController - JSON response sent.");
		    } catch (Exception e) {
		        System.err.println("ERROR: TodoController - Exception during feedback action: " + e.getMessage());
		        e.printStackTrace();
		        // 클라이언트에 에러 응답을 보내는 것이 좋음
		        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 에러 코드 설정
		        response.setContentType("application/json; charset=UTF-8");
		        try (PrintWriter out = response.getWriter()) {
		            out.write("{\"status\":\"error\", \"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
		            out.flush();
		        } catch (IOException ioException) {
		            System.err.println("ERROR: Failed to write error response: " + ioException.getMessage());
		        }
		    }
		}
		// 다른 doPost 액션들이 있다면 여기에 추가하세요.
	}
}
