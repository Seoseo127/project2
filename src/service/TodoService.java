package service;

import model.dto.TodoDTO;
import model.dto.TimerTodoDTO; // TimerTodoDTO 임포트 확인
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TodoService {
    private final static SqlSessionFactory factory = DBConnection.getFactory();

    // ✅ getTodoList 메소드 수정
    public List<TodoDTO> getTodoList(String userId) {
        System.out.println("DEBUG: getTodoList called for userId: " + userId); // 디버깅 로그 추가
        try (SqlSession session = factory.openSession()) {
            // ✅ 이 부분을 수정!
            List<TodoDTO> list = session.selectList("todoMapper.selectIncompleteTodosByUserId", userId);
            System.out.println("DEBUG: selectIncompleteTodosByUserId returned size: " + (list != null ? list.size() : "null")); // 디버깅 로그 추가
            return list;
        } catch (Exception e) { // 예외 처리 추가
            System.err.println("ERROR: Error in getTodoList: " + e.getMessage());
            e.printStackTrace();
            return null; // 예외 발생 시 null 반환
        }
    }

    public TodoDTO getTodoById(int todoId) {
        try (SqlSession session = factory.openSession()) {
            // 예시: return session.selectOne("todoMapper.selectTodoById", todoId);
            // ✅ 이 부분도 실제 쿼리 호출로 수정해야 합니다.
            return session.selectOne("todoMapper.selectTodoById", todoId);
        }
    }

    public void insertTodo(TodoDTO dto) {
        try (SqlSession session = factory.openSession(true)) {
            session.insert("todoMapper.insertTodo", dto);
        }
    }

    public void updateTodo(TodoDTO dto) {
        try (SqlSession session = factory.openSession(true)) {
            session.update("todoMapper.updateTodo", dto);
        }
    }

    public void deleteTodo(int todoId) {
        try (SqlSession session = factory.openSession(true)) {
            session.delete("todoMapper.deleteTodo", todoId);
        }
    }

    public void completeTodo(int todoId, String userId, String subject) {
        // 이 메소드는 TimerService의 checkAndMarkCompleteByTimer와 유사하게 동작할 수 있음
        // 또는 단순히 STATUS를 '완료'로 바꾸는 로직일 수 있음
        try (SqlSession session = factory.openSession(true)) {
            Map<String, Object> param = new HashMap<>();
            param.put("todoId", todoId);
            param.put("userId", userId);
            // subject는 이 메소드에서 직접 사용되지 않을 수 있음
            // total 값도 필요하다면 여기서 조회하거나 파라미터로 받아야 함
            param.put("status", "완료"); // STATUS를 '완료'로 설정
            Integer studyTotal = session.selectOne("todoMapper.getStudyTimerTotal", param);
            param.put("total", (studyTotal !=null) ? studyTotal : 0); // total 값을 어떻게 설정할지 확인 필요 (예시로 0)

            session.update("todoMapper.updateTodoStatusToCompletedByTodoIdWithClear", param);
        }
    }

    // ✅ getCompletedTodoWithTimer 메소드 추가 (TodoController에서 사용)
    public List<TimerTodoDTO> getCompletedTodoWithTimer(String userId) {
        try (SqlSession session = factory.openSession()) {
            return session.selectList("todoMapper.getCompletedTodoWithTimer", userId);
        }
    }

    // ✅ updateFeedbackByTodoId 메소드 추가
    public void updateFeedbackByTodoId(int todoId, String feedback) {
        SqlSession session = null; // 명시적 트랜잭션 관리를 위해 SqlSession 선언
        try {
            session = factory.openSession(false); // autoCommit을 false로 설정
            Map<String, Object> param = new HashMap<>();
            param.put("todoId", todoId);
            param.put("feedback", feedback);
            
            int updatedRows = session.update("todoMapper.updateFeedbackByTodoId", param);
            session.commit(); // ✅ 명시적 커밋
            System.out.println("DEBUG: updateFeedbackByTodoId updated rows: " + updatedRows);
        } catch (Exception e) {
            if (session != null) {
                session.rollback(); // ✅ 예외 발생 시 롤백
                System.err.println("ERROR: updateFeedbackByTodoId rolled back due to exception: " + e.getMessage());
            }
            e.printStackTrace(); // 전체 스택 트레이스 출력
        } finally {
            if (session != null) {
                session.close(); // ✅ 세션 닫기
            }
        }
    }
}
