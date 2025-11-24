package com.surviveshare.model;

import java.time.LocalDateTime;

public class Tip {
    private int tipId;
    private int userId;
    private String title;
    private String content;
    private LocalDateTime createdAt;

    public int getTipId() { return tipId; }
    public void setTipId(int tipId) { this.tipId = tipId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
