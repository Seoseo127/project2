package model.dto;

import java.util.Date;

public class ReportDTO {
    private int reportId;
    private String reporterId;
    private String targetId;
    private String content;
    private Date createdAt;
    private String targetType;

    private String targetNickname; // 신고 대상 닉네임
    private String postId;         // 댓글 신고 시 해당 댓글이 속한 게시글 ID

    private String status;
    private String targetUserId;
    private String targetTitle;

    // status getter/setter
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    // targetUserId getter/setter
    public String getTargetUserId() {
        return targetUserId;
    }
    public void setTargetUserId(String targetUserId) {
        this.targetUserId = targetUserId;
    }

    // targetNickname getter/setter
    public String getTargetNickname() {
        return targetNickname;
    }
    public void setTargetNickname(String targetNickname) {
        this.targetNickname = targetNickname;
    }

    // postId getter/setter
    public String getPostId() {
        return postId;
    }
    public void setPostId(String postId) {
        this.postId = postId;
    }

    // reportId getter/setter
    public int getReportId() {
        return reportId;
    }
    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    // reporterId getter/setter
    public String getReporterId() {
        return reporterId;
    }
    public void setReporterId(String reporterId) {
        this.reporterId = reporterId;
    }

    // targetId getter/setter
    public String getTargetId() {
        return targetId;
    }
    public void setTargetId(String targetId) {
        this.targetId = targetId;
    }

    // content getter/setter
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    // createdAt getter/setter
    public Date getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // targetType getter/setter
    public String getTargetType() {
        return targetType;
    }
    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }
	public String getTargetTitle() {
		return targetTitle;
	}
	public void setTargetTitle(String targetTitle) {
		this.targetTitle = targetTitle;
	}
}
