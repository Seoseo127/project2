package model.dto;

public class StudyMemberDTO {
    private int groupId;
    private String userId;
    private String joinDate;  // 날짜는 문자열로 간단히 처리하거나 java.sql.Date로 변경 가능
    private String role;      // "leader" 또는 "member"
    private String nickname;
    
    // 기본 생성자
    public StudyMemberDTO() {}

    // 생성자
    public StudyMemberDTO(int groupId, String userId, String role) {
        this.groupId = groupId;
        this.userId = userId;
        this.role = role;
    }

    // Getter & Setter
    public int getGroupId() { return groupId; }
    public void setGroupId(int groupId) { this.groupId = groupId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getJoinDate() { return joinDate; }
    public void setJoinDate(String joinDate) { this.joinDate = joinDate; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    // ✅ JSP 호환용 추가 메서드
    public String getJoinedAt() {
        return joinDate;
    }
}
