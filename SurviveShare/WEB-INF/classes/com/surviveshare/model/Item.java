package com.surviveshare.model;

import java.time.LocalDateTime;

public class Item {
    private int itemId;
    private String sessionId;
    private String name;
    private String description;
    private String imagePath;
    private java.math.BigDecimal price;
    private LocalDateTime createdAt;
    private LocalDateTime meetTime;
    private String meetPlace;

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public java.math.BigDecimal getPrice() { return price; }
    public void setPrice(java.math.BigDecimal price) { this.price = price; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getMeetTime() { return meetTime; }
    public void setMeetTime(LocalDateTime meetTime) { this.meetTime = meetTime; }

    public String getMeetPlace() { return meetPlace; }
    public void setMeetPlace(String meetPlace) { this.meetPlace = meetPlace; }
}
