package controller;

import model.dto.TimerTodoDTO;
import model.dto.UserDTO;
import service.TimerService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/timer")
public class TimerController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TimerService timerService = new TimerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userId = loginUser.getUserId();
        String action = request.getParameter("action");

        if ("main".equals(action) || action == null) {
            List<TimerTodoDTO> timerList = timerService.getTimerTodoListByUserId(userId);

            int totalGoal = 0;
            int totalStudy = 0;

            if (timerList != null) {
                totalGoal = timerList.stream().mapToInt(t -> t.getTotalMinutes() != null ? t.getTotalMinutes() : 0).sum();
                totalStudy = timerList.stream().mapToInt(t -> t.getTotal() != null ? t.getTotal() : 0).sum();
            }

            request.setAttribute("timerList", timerList);
            request.setAttribute("totalGoal", String.format("%02d:%02d", totalGoal / 60, totalGoal % 60));
            request.setAttribute("totalStudy", String.format("%02d:%02d", totalStudy / 60, totalStudy % 60));

            request.getRequestDispatcher("/timer/study_main.jsp").forward(request, response);

        } else if ("calendar".equals(action)) {
            // ✅ 캘린더 화면 요청 처리
            request.getRequestDispatcher("/calendar_main.jsp").forward(request, response);

        } else if ("getTimers".equals(action)) {
            List<TimerTodoDTO> timerList = timerService.getTimerTodoListByUserId(userId);
            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < timerList.size(); i++) {
                TimerTodoDTO t = timerList.get(i);
                String clearStr = (t.getClear() != null) ? sdf.format(t.getClear()) : "";

                json.append("{\"subject\":\"").append(t.getSubject())
                    .append("\",\"clear\":\"").append(clearStr).append("\"}");
                if (i < timerList.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
            out.flush();

        } else if ("getTotalTimes".equals(action)) {
            List<TimerTodoDTO> timerList = timerService.getTimerTodoListByUserId(userId);

            int totalGoal = 0;
            int totalStudy = 0;

            if (timerList != null) {
                totalGoal = timerList.stream().mapToInt(t -> t.getTotalMinutes() != null ? t.getTotalMinutes() : 0).sum();
                totalStudy = timerList.stream().mapToInt(t -> t.getTotal() != null ? t.getTotal() : 0).sum();
            }

            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"totalGoal\":\"" + String.format("%02d:%02d", totalGoal / 60, totalGoal % 60)
                    + "\", \"totalStudy\":\"" + String.format("%02d:%02d", totalStudy / 60, totalStudy % 60) + "\"}");
            out.flush();

        } else if ("getChartData".equals(action)) {
            List<TimerTodoDTO> timerList = timerService.getTimerTodoListByUserId(userId);
            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();

            StringBuilder jsonBuilder = new StringBuilder("[");
            for (int i = 0; i < timerList.size(); i++) {
                TimerTodoDTO t = timerList.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"subject\":\"").append(t.getSubject()).append("\",");
                jsonBuilder.append("\"total\":").append(t.getTotal() != null ? t.getTotal() : 0).append(",");
                jsonBuilder.append("\"totalMinutes\":").append(t.getTotalMinutes() != null ? t.getTotalMinutes() : 0);
                jsonBuilder.append("}");
                if (i < timerList.size() - 1) {
                    jsonBuilder.append(",");
                }
            }
            jsonBuilder.append("]");
            out.print(jsonBuilder.toString());
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userId = loginUser.getUserId();
        String action = request.getParameter("action");

        if ("saveGoal".equals(action)) {
            String subject = request.getParameter("subject");
            int goal = Integer.parseInt(request.getParameter("goal"));
            timerService.saveGoalTime(userId, subject, goal);
            response.sendRedirect("/timer?action=main");

        } else if ("saveTimer".equals(action)) {
            String subject = request.getParameter("subject");
            int minutes = Integer.parseInt(request.getParameter("minutes"));
            String todoIdStr = request.getParameter("todoId");
            int todoId = (todoIdStr != null && !todoIdStr.isEmpty()) ? Integer.parseInt(todoIdStr) : 0;

            timerService.updateStudyAndTodoTotal(userId, subject, todoId, minutes);

            boolean isCompleted = false;
            if (todoId > 0) {
                isCompleted = timerService.checkAndMarkCompleteByTimer(userId, subject, todoId);
            }

            String currentTodoStatus = "미확인";
            if (todoId > 0) {
                currentTodoStatus = timerService.getTodoStatus(userId, todoId);
            }

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"responseStatus\":\"" + (isCompleted ? "completed" : "saved")
                    + "\", \"todoStatus\":\"" + currentTodoStatus + "\"}");

        } else if ("complete".equals(action)) {
            String subject = request.getParameter("subject");
            int todoId = Integer.parseInt(request.getParameter("todoId"));
            timerService.markComplete(userId, subject, todoId);

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"status\":\"done\"}");
        }
    }
}
