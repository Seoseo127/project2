package service;

import model.dto.FeedbackDTO;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.DBConnection;

public class FeedbackService {
	private final static SqlSessionFactory factory = DBConnection.getFactory();

	public boolean updateFeedback(FeedbackDTO dto) {
		try (SqlSession session = factory.openSession(true)) {
			return session.update("feedbackMapper.updateFeedback", dto) == 1;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public FeedbackDTO getFeedbackByTodoId(int todoId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectOne("feedbackMapper.getFeedbackByTodoId", todoId);
		}
	}
}