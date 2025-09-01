package model.dto;

import java.util.Date;

public class TimerTodoDTO {
	private int todoId;
	private String userId;
	private String subject;
	private String content;
	private Date deadline;
	private Integer goal;
	private String status;
	private Date createdAt;
	private String feedback;
	private Integer total; // 누적 시간(분)
	private Integer totalMinutes; // 목표 시간(분)
	private Date clear;

	// getter / setter
	public int getTodoId() {
		return todoId;
	}

	public void setTodoId(int todoId) {
		this.todoId = todoId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getDeadline() {
		return deadline;
	}

	public void setDeadline(Date deadline) {
		this.deadline = deadline;
	}

	public Integer getGoal() {
		return goal;
	}

	public void setGoal(Integer goal) {
		this.goal = goal;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getFeedback() {
		return feedback;
	}

	public void setFeedback(String feedback) {
		this.feedback = feedback;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public Integer getTotalMinutes() {
		return totalMinutes;
	}

	public void setTotalMinutes(Integer totalMinutes) {
		this.totalMinutes = totalMinutes;
	}

	public Date getClear() {
		return clear;
	}

	public void setClear(Date clear) {
		this.clear = clear;
	}
}
