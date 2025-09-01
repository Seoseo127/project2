package service;

import model.dto.*;
import org.apache.ibatis.session.*;
import util.DBConnection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CommentService {
	private final static SqlSessionFactory factory = DBConnection.getFactory();

	public List<CommentDTO> getCommentsByPostId(int postId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectList("commentMapper.getCommentsByPostId", postId);
		}
	}

	public CommentDTO getCommentById(int commentId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectOne("commentMapper.getCommentById", commentId);
		}
	}

	public void addComment(CommentDTO comment) {
		try (SqlSession session = factory.openSession()) {
			session.insert("commentMapper.addComment", comment);
			session.commit();
		}
	}

	public void updateComment(CommentDTO comment) {
		try (SqlSession session = factory.openSession()) {
			session.update("commentMapper.updateComment", comment);
			session.commit();
		}
	}

	public void deleteComment(int commentId) {
		try (SqlSession session = factory.openSession()) {
			session.delete("commentMapper.deleteComment", commentId);
			session.commit();
		}
	}

	public static List<CommentDTO> getMyComments(String userId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectList("communityMapper.selectMyComments", userId);
		}
	}

	public int getMyCommentCount(String userId) {
		try (SqlSession session = factory.openSession()) {
			return session.selectOne("communityMapper.getMyCommentCount", userId);
		}
	}

	public List<CommentDTO> getMyCommentsWithPaging(String userId, int offset, int limit) {
		try (SqlSession session = factory.openSession()) {
			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("offset", offset);
			map.put("limit", limit);
			return session.selectList("communityMapper.selectMyCommentsPaging", map);
		}
	}
	
	public boolean isCommentBlinded(int commentId) {
	    try (SqlSession session = factory.openSession()) {
	        return session.selectOne("communityMapper.isCommentBlinded", commentId);
	    }
	}

}