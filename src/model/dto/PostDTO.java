package model.dto;

import java.util.Date;

public class PostDTO {
	private int postId;
	private String userId;
	private String category;
	private String title;
	private String pContent;
	private Date createdAt;
	private int commentCount;
	private String nickname;

	private String filePath;
	private String fileType;

	private int viewCount;
	private int likeCount;

	private Date scrapDate;
	
	// Getter & Setter
	public int getPostId() {
		return postId;
	}

	public void setPostId(int postId) {
		this.postId = postId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getpContent() {
		return pContent;
	}

	public void setpContent(String pContent) {
		this.pContent = pContent;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public int getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public int getViewCount() {
		return viewCount;
	}

	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	
	public int getLikeCount() {
	    return likeCount;
	}

	public void setLikeCount(int likeCount) {
	    this.likeCount = likeCount;
	}
	
	public String getNickname() {
	    return nickname;
	}
	public void setNickname(String nickname) {
	    this.nickname = nickname;
	}

	public Date getScrapDate() {
		return scrapDate;
	}

	public void setScrapDate(Date scrapDate) {
		this.scrapDate = scrapDate;
	}
}
