package model.dto;

import java.util.Date;

public class UserDTO {
	private String userId;
	private String password;
	private String nickname;
	private String email;
	private String userName;
	private String userGrade;
	private Date createdAt;
	private Date suspendedUntil;
	
	public UserDTO() {
	}

	public UserDTO(String userId, String password, String nickname, String email, String userName, String userGrade, Date createdAt, Date suspendedUntil) {
		this.userId = userId;
		this.password = password;
		this.nickname = nickname;
		this.email = email;
		this.userName = userName;
		this.userGrade = userGrade;
		this.createdAt = createdAt;
		this.suspendedUntil = suspendedUntil;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserGrade() {
		return userGrade;
	}

	public void setUserGrade(String userGrade) {
		this.userGrade = userGrade;
	}

	/**
	 * @return createdAt
	 */
	public Date getCreatedAt() {
		return createdAt;
	}

	/**
	 * @param createdAt 설정할 createdAt
	 */
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	
	public Date getSuspendedUntil() {
	    return suspendedUntil;
	}
	public void setSuspendedUntil(Date suspendedUntil) {
	    this.suspendedUntil = suspendedUntil;
	}

}
