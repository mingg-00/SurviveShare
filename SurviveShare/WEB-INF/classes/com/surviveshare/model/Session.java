package com.surviveshare.model;

import java.time.LocalDateTime;

public class Session {
    private String sessionId;
    private int levelScore;
    private LocalDateTime createdAt;

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public int getLevelScore() { return levelScore; }
    public void setLevelScore(int levelScore) { this.levelScore = levelScore; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}



