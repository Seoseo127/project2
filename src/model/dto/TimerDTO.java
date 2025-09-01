package model.dto;

import java.util.Date;

public class TimerDTO {
    private String userId;
    private String subject;
    private int totalMinutes;
    private int total;
    private Date clear;

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

    public int getTotalMinutes() {
        return totalMinutes;
    }

    public void setTotalMinutes(int totalMinutes) {
        this.totalMinutes = totalMinutes;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public Date getClear() {
        return clear;
    }

    public void setClear(Date clear) {
        this.clear = clear;
    }
}
