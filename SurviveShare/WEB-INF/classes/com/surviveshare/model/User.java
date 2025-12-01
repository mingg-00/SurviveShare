package com.surviveshare.model;

public class User {
    private int userId;
    private String username;
    private String password;
    private String nickname;
    private int levelScore;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public int getLevelScore() { return levelScore; }
    public void setLevelScore(int levelScore) { this.levelScore = levelScore; }
}
