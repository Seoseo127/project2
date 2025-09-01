package model.dto;

import java.util.Date;

public class NotificationDTO {
    private int notiId;
    private String userId;
    private int postId;
    private String type;
    private String message;
    private String isRead;
    private Date createdAt;

    // ✅ 기본 생성자 필요
    public NotificationDTO() {}

    // ✅ getter & setter (전부 있어야 함)
    public int getNotiId() { return notiId; }
    public void setNotiId(int notiId) { this.notiId = notiId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getIsRead() { return isRead; }
    public void setIsRead(String isRead) { this.isRead = isRead; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
