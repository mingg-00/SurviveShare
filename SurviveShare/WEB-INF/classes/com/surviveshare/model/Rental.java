package com.surviveshare.model;

import java.time.LocalDateTime;

public class Rental {
    private int rentalId;
    private int itemId;
    private String ownerSession;
    private String borrowerSession;
    private String status;
    private LocalDateTime createdAt;
    private String itemName;
    private LocalDateTime meetTime;
    private String meetPlace;

    public int getRentalId() { return rentalId; }
    public void setRentalId(int rentalId) { this.rentalId = rentalId; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getOwnerSession() { return ownerSession; }
    public void setOwnerSession(String ownerSession) { this.ownerSession = ownerSession; }

    public String getBorrowerSession() { return borrowerSession; }
    public void setBorrowerSession(String borrowerSession) { this.borrowerSession = borrowerSession; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public LocalDateTime getMeetTime() { return meetTime; }
    public void setMeetTime(LocalDateTime meetTime) { this.meetTime = meetTime; }

    public String getMeetPlace() { return meetPlace; }
    public void setMeetPlace(String meetPlace) { this.meetPlace = meetPlace; }
}
