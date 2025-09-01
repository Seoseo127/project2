package service;

import model.dto.TimerDTO;
import model.dto.TimerTodoDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TimerService {
	private final static SqlSessionFactory factory = DBConnection.getFactory();

	public TimerDTO getTimer(String userId, String subject) {
		try (SqlSession session = factory.openSession()) {
			return session.selectOne("timerMapper.getTimer", Map.of("userId", userId, "subject", subject));
		}
	}

	public void insertTimer(TimerDTO dto) {
		try (SqlSession session = factory.openSession(true)) {
			session.insert("timerMapper.insertTimer", dto);
		}
	}

	public void updateTimerTotal(String userId, String subject, int total) {
		try (SqlSession session = factory.openSession(true)) {
			session.update("timerMapper.updateTimerTotal",
					Map.of("userId", userId, "subject", subject, "total", total));
		}
	}

	public void deleteTimer(String userId, String subject) {
		try (SqlSession session = factory.openSession(true)) {
			session.delete("timerMapper.deleteTimer", Map.of("userId", userId, "subject", subject));
		}
	}

	public void saveGoalTime(String userId, String subject, int goal) {
		try (SqlSession session = factory.openSession(true)) {
			Map<String, Object> param = new HashMap<>();
			param.put("userId", userId);
			param.put("subject", subject);
			param.put("goal", goal);
			session.update("timerMapper.insertGoalTime", param);
		}
	}

	public List<TimerDTO> getTimersByUserId(String userId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectList("timerMapper.selectTimersByUserId", userId);
		}
	}

	public List<TimerTodoDTO> getTimerTodoListByUserId(String userId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectList("timerMapper.selectTimerTodoListByUserId", userId);
		}
	}

	public void markComplete(String userId, String subject, int todoId) {
	    SqlSession session = null;
	    try {
	        session = factory.openSession(false);
	        Map<String, Object> param = new HashMap<>();
	        param.put("userId", userId);
	        param.put("subject", subject);
	        param.put("todoId", todoId);
	        param.put("clearDate", new java.sql.Date(System.currentTimeMillis()));

	        Integer total = session.selectOne("timerMapper.getTotalByUserIdAndSubject", param);
	        param.put("total", total != null ? total : 0);
	        
	        param.put("status", "완료");

	        session.update("todoMapper.updateTodoStatusToCompletedByTodoIdWithClear", param);
	        session.update("timerMapper.updateClearDate", param);
	        session.commit();
	        System.out.println("DEBUG: markComplete committed successfully.");
	    } catch (Exception e) {
	        if (session != null) {
	            session.rollback();
	            System.err.println("ERROR: markComplete rolled back due to exception: " + e.getMessage());
	        }
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }
	}

	public boolean checkAndMarkCompleteByTimer(String userId, String subject, int todoId) {
	    SqlSession session = null;
	    try {
	        session = factory.openSession(false);
	        Map<String, Object> param = new HashMap<>();
	        param.put("userId", userId);
	        param.put("subject", subject);
	        param.put("todoId", todoId);

	        Integer total = session.selectOne("timerMapper.getTotalByUserIdAndSubject", param);
	        Integer goal = session.selectOne("timerMapper.getGoalByUserIdAndSubject", param);

	        System.out.println("DEBUG: checkAndMarkCompleteByTimer - userId: " + userId + ", subject: " + subject
	                + ", todoId: " + todoId);
	        System.out.println("DEBUG: total (STUDY_TIMER.TOTAL): " + total);
	        System.out.println("DEBUG: goal (STUDY_TIMER.TOTAL_MINUTES): " + goal);

	        if (total == null)
	            total = 0;
	        if (goal == null)
	            goal = 0;

	        if (total >= goal && goal > 0) {
	            System.out
	                    .println("DEBUG: Condition (total >= goal && goal > 0) is TRUE. Proceeding to mark complete.");

	            param.put("status", "완료");
	            param.put("clearDate", new java.sql.Date(System.currentTimeMillis()));

	            System.out.println("DEBUG: param map before update: " + param);

	            int updatedTodoRows = session.update("todoMapper.updateTodoStatusToCompletedByTodoIdWithClear", param);
	            System.out.println("DEBUG: todoMapper.updateTodoStatusToCompletedByTodoIdWithClear updated rows: "
	                    + updatedTodoRows);

	            int updatedTimerClearRows = session.update("timerMapper.updateClearDate", param);
	            System.out.println("DEBUG: timerMapper.updateClearDate updated rows: " + updatedTimerClearRows);

	            session.commit();
	            System.out.println("DEBUG: Transaction committed successfully.");
	            return true;
	        } else {
	            System.out.println("DEBUG: Condition (total >= goal && goal > 0) is FALSE. Not marking complete.");
	            System.out.println("DEBUG: Current total: " + total + ", Current goal: " + goal);
	        }
	        return false;
	    } catch (Exception e) {
	        if (session != null) {
	            session.rollback();
	            System.err.println("ERROR: Transaction rolled back due to exception: " + e.getMessage());
	        }
	        e.printStackTrace();
	        return false;
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }
	}

    public void updateStudyAndTodoTotal(String userId, String subject, int todoId, int totalMinutes) {
        SqlSession session = null;
        try {
            session = factory.openSession(false); // 수동 커밋
            Map<String, Object> param = new HashMap<>();
            param.put("userId", userId);
            param.put("subject", subject);
            param.put("total", totalMinutes); // STUDY_TIMER의 TOTAL 업데이트용

            // 1. STUDY_TIMER의 TOTAL 업데이트
            int updatedTimerRows = session.update("timerMapper.updateTimerTotal", param);
            System.out.println("DEBUG: timerMapper.updateTimerTotal updated rows: " + updatedTimerRows);

            // 2. TODO_LIST의 TOTAL 업데이트 (todoId가 있을 경우에만)
            if (todoId > 0) { // todoId가 유효한 경우에만 TODO_LIST 업데이트
                Map<String, Object> todoParam = new HashMap<>();
                todoParam.put("userId", userId);
                todoParam.put("todoId", todoId);
                todoParam.put("total", totalMinutes);

                int updatedTodoRows = session.update("todoMapper.updateTodoTotalOnly", todoParam);
                System.out.println("DEBUG: todoMapper.updateTodoTotalOnly updated rows: " + updatedTodoRows);
            }
            
            session.commit(); // ✅ 두 업데이트 모두 성공하면 커밋
            System.out.println("DEBUG: updateStudyAndTodoTotal committed successfully.");

        } catch (Exception e) {
            if (session != null) {
                session.rollback(); // ✅ 하나라도 실패하면 롤백
                System.err.println("ERROR: updateStudyAndTodoTotal rolled back due to exception: " + e.getMessage());
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    // ✅ 특정 TODO_ID의 STATUS를 조회하는 메소드 추가
    public String getTodoStatus(String userId, int todoId) {
        try (SqlSession session = factory.openSession()) {
            Map<String, Object> param = new HashMap<>();
            param.put("userId", userId);
            param.put("todoId", todoId);
            return session.selectOne("todoMapper.getTodoStatusById", param);
        }
    }

    // 이 메소드는 이제 updateStudyAndTodoTotal에 통합되었으므로,
    // 직접 호출되지 않도록 하거나, 필요하다면 내부 로직을 변경해야 합니다.
    // 현재는 TimerController에서 직접 호출하지 않도록 변경할 예정입니다.
	public void updateTodoTotal(String userId, int todoId, int total) {
	    System.out.println("WARNING: updateTodoTotal is deprecated. Use updateStudyAndTodoTotal instead.");
	    SqlSession session = null;
	    try {
	        session = factory.openSession(false);
	        Map<String, Object> param = new HashMap<>();
	        param.put("userId", userId);
	        param.put("todoId", todoId);
	        param.put("total", total);

	        int updatedRows = session.update("todoMapper.updateTodoTotalOnly", param);
	        System.out.println("DEBUG: todoMapper.updateTodoTotalOnly updated rows: " + updatedRows);
	        session.commit();
	        System.out.println("DEBUG: updateTodoTotal committed successfully.");
	    } catch (Exception e) {
	        if (session != null) {
	            session.rollback();
	            System.err.println("ERROR: updateTodoTotal rolled back due to exception: " + e.getMessage());
	        }
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }
	}

}
