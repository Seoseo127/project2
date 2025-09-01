package service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.CommentDTO;
import model.dto.PostDTO;
import model.dto.UserDTO;
import util.DBConnection;

public class UserService {

	private SqlSessionFactory factory = DBConnection.getFactory();

	// 회원가입 처리
	public boolean signup(UserDTO dto) {
		try (SqlSession session = factory.openSession(true)) { // auto commit
			int result = session.insert("user.signup", dto); // 매퍼 id: user.signup
			return result > 0;
		}
	}

	// 로그인
	public UserDTO login(String userId, String password) {
		try (SqlSession session = factory.openSession()) {
			UserDTO param = new UserDTO();
			param.setUserId(userId);
			param.setPassword(password);
			return session.selectOne("user.login", param); // → MyBatis 쿼리에서 userId + password 비교
		}
	}

	// 비밀번호 찾기
	public String findPassword(String userId, String email) {
		try (SqlSession session = factory.openSession()) {
			Map<String, Object> param = new HashMap<>();
			param.put("userId", userId);
			param.put("email", email);

			return session.selectOne("user.findPassword", param);
		}
	}

	// 정보 수정
	public boolean updateUser(UserDTO dto) {
		try (SqlSession session = factory.openSession(true)) {
			return session.update("user.update", dto) == 1;
		}
	}

	// 회원 탈퇴
	public boolean deleteUser(String userId) {
		try (SqlSession session = factory.openSession(true)) {

			session.delete("user.deletePostLikes", userId);
			session.delete("user.deleteComments", userId);

			// ❌ 기존 deleteScraps → 🔁 아래 새로 추가한 쿼리로 교체
			session.delete("user.deleteScrapsByPostAuthor", userId);

			session.delete("user.deleteNotifications", userId);
			session.delete("user.deleteStudyTimer", userId);
			session.delete("user.deleteTodoList", userId);
			session.delete("user.deleteStudyStats", userId);
			session.delete("user.deleteStudyGroup", userId);

			// 이제 POSTS 삭제 가능
			session.delete("user.deletePostsByUserId", userId);

			// 마지막으로 USERS 삭제
			int result = session.delete("user.deleteUser", userId);
			return result == 1;
		}
	}

}
