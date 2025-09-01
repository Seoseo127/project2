package service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;

import model.dto.StudyGroupDTO;
import model.dto.StudyMemberDTO;
import util.DBConnection;

public class StudyGroupService {

	// 전체 스터디 목록 조회
	public List<StudyGroupDTO> getAllGroups() {
		try (SqlSession session = DBConnection.getSqlSession()) {
			List<StudyGroupDTO> groupList = session.selectList("model.dao.StudyGroupMapper.getAllStudyGroups");

			for (StudyGroupDTO group : groupList) {
				int count = session.selectOne("model.dao.StudyGroupMapper.countMembers", group.getGroupId());
				group.setCurrentMemberCount(count);
				group.setStatus(group.getDuration() > 0 ? "모집 중" : "종료됨");
			}

			return groupList;
		}
	}

	// 스터디 상세 조회 (+ 현재 인원 수 세팅)
	public StudyGroupDTO getGroupById(int groupId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			StudyGroupDTO group = session.selectOne("model.dao.StudyGroupMapper.getGroupById", groupId);
			int count = session.selectOne("model.dao.StudyGroupMapper.countMembers", groupId);
			group.setCurrentMemberCount(count); // ✅ 현재 인원 수 반영
			return group;
		}
	}

	public List<StudyGroupDTO> searchStudyGroups(String keyword) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			List<StudyGroupDTO> groupList = session.selectList("model.dao.StudyGroupMapper.searchGroups",
					"%" + keyword + "%");

			for (StudyGroupDTO group : groupList) {
				int count = session.selectOne("model.dao.StudyGroupMapper.countMembers", group.getGroupId());
				group.setCurrentMemberCount(count);

				// optional: 모집 상태도 함께 세팅
				group.setStatus(count >= group.getMaxMember() ? "모집 완료" : "모집 중");
			}

			return groupList;
		}
	}

	// 스터디 생성
	public int insertGroup(StudyGroupDTO group) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			int result = session.insert("model.dao.StudyGroupMapper.insertStudyGroup", group);
			session.commit();
			return result;
		}
	}

	// 스터디 수정
	public int updateGroup(StudyGroupDTO group) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			int result = session.update("model.dao.StudyGroupMapper.updateGroup", group);
			session.commit();
			return result;
		}
	}

	// 스터디 기간만 수정
	public boolean updateDuration(StudyGroupDTO dto) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			int result = session.update("model.dao.StudyGroupMapper.updateDuration", dto);
			session.commit();
			return result > 0;
		}
	}

	// 스터디 탈퇴
	public boolean leaveGroup(int groupId, String userId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			Map<String, Object> map = new HashMap<>();
			map.put("groupId", groupId);
			map.put("userId", userId);

			int result = session.delete("model.dao.StudyGroupMapper.leaveGroup", map);
			session.commit();
			return result > 0;
		}
	}

	// 스터디 참여
	public boolean joinGroup(StudyMemberDTO dto) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			int count = session.selectOne("model.dao.StudyGroupMapper.countMembers", dto.getGroupId());
			StudyGroupDTO group = session.selectOne("model.dao.StudyGroupMapper.getStudyGroupById", dto.getGroupId());

			if (count >= group.getMaxMember()) {
				throw new RuntimeException("정원 초과");
			}

			int result = session.insert("model.dao.StudyGroupMapper.insertMember", dto);
			session.commit();
			return result > 0;
		}
	}

	// 스터디 삭제 (스터디장만)
	public boolean deleteGroupByLeader(int groupId, String leaderId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			Map<String, Object> map = new HashMap<>();
			map.put("groupId", groupId);
			map.put("leaderId", leaderId); // 반드시 String!

			int result = session.delete("model.dao.StudyGroupMapper.deleteGroupByLeader", map);
			session.commit();
			return result > 0;
		}
	}

	// 강제 탈퇴
	public boolean kickMember(int groupId, String userId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			Map<String, Object> map = new HashMap<>();
			map.put("groupId", groupId);
			map.put("userId", userId);

			int result = session.delete("model.dao.StudyGroupMapper.kickMember", map);
			session.commit();
			return result > 0;
		}
	}

	// 내가 만든 스터디 목록
	public List<StudyGroupDTO> getGroupsLedByUser(String userId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			return session.selectList("model.dao.StudyGroupMapper.selectGroupsLedByUser", userId);
		}
	}

	// 내가 가입한 스터디 목록
	public List<StudyGroupDTO> getGroupsJoinedByUser(String userId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			return session.selectList("model.dao.StudyGroupMapper.selectGroupsJoinedByUser", userId);
		}
	}

	// 그룹 멤버 전체 조회
	public List<StudyMemberDTO> getAllMembers(int groupId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			return session.selectList("model.dao.StudyGroupMapper.selectMembersByGroupId", groupId);
		}
	}

	// 닉네임 포함 스터디 멤버 조회 (UserDTO 사용)
	public List<model.dto.UserDTO> getStudyMembersByGroupId(int groupId) {
		try (SqlSession session = DBConnection.getSqlSession()) {
			return session.selectList("model.dao.StudyGroupMapper.getStudyMembersByGroupId", groupId);
		}
	}

}
