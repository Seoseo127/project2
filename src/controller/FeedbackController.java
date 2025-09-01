package controller;

import model.dto.FeedbackDTO;
import service.FeedbackService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackController extends HttpServlet {
	private final FeedbackService service = new FeedbackService();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int todoId = Integer.parseInt(request.getParameter("todoId"));
		String userId = request.getParameter("userId");
		String feedback = request.getParameter("feedback");

		FeedbackDTO dto = new FeedbackDTO();
		dto.setTodoId(todoId);
		dto.setUserId(userId);
		dto.setFeedback(feedback);

		service.updateFeedback(dto);

		response.sendRedirect("todo?action=past&updated=true");
	}
}
