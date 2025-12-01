package com.surviveshare.model;

import java.time.LocalDateTime;

public class Tip {
    private int tipId;
    private String sessionId;
    private String title;
    private String content;
    private String imagePath;
    private String hashtags;
    private int recommendCount;
    private LocalDateTime createdAt;

    public int getTipId() { return tipId; }
    public void setTipId(int tipId) { this.tipId = tipId; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getHashtags() { return hashtags; }
    public void setHashtags(String hashtags) { this.hashtags = hashtags; }

    public int getRecommendCount() { return recommendCount; }
    public void setRecommendCount(int recommendCount) { this.recommendCount = recommendCount; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
