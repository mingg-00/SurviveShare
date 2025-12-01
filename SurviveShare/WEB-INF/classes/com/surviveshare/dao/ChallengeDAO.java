package com.surviveshare.dao;

import com.surviveshare.config.DBConnection;
import com.surviveshare.model.Challenge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class ChallengeDAO {

    private static final String[] CHALLENGE_DESCRIPTIONS = {
        "오늘 집 청소하기",
        "간단한 요리 도전",
        "물건 정리하기",
        "친구와 물건 공유하기",
        "새로운 생활 팁 공유하기",
        "절약 팁 실천하기",
        "재활용 아이템 만들기",
        "홈카페 만들기"
    };

    public String getRandomChallenge() {
        Random random = new Random();
        return CHALLENGE_DESCRIPTIONS[random.nextInt(CHALLENGE_DESCRIPTIONS.length)];
    }

    public boolean createChallenge(Challenge challenge) {
        String sql = "INSERT INTO challenges(session_id, description, image_path, points) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, challenge.getSessionId());
            ps.setString(2, challenge.getDescription());
            ps.setString(3, challenge.getImagePath());
            ps.setInt(4, challenge.getPoints());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Challenge> getChallengesBySession(String sessionId) {
        List<Challenge> list = new ArrayList<>();
        String sql = "SELECT * FROM challenges WHERE session_id=? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getChallengeCountBySession(String sessionId) {
        String sql = "SELECT COUNT(*) as count FROM challenges WHERE session_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<SessionRank> getRanking(int limit) {
        List<SessionRank> ranking = new ArrayList<>();
        String sql = "SELECT session_id, level_score FROM sessions ORDER BY level_score DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            int rank = 1;
            while (rs.next()) {
                SessionRank sr = new SessionRank();
                sr.rank = rank++;
                sr.sessionId = rs.getString("session_id");
                sr.score = rs.getInt("level_score");
                ranking.add(sr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ranking;
    }

    public static class SessionRank {
        public int rank;
        public String sessionId;
        public int score;
        
        public int getRank() { return rank; }
        public String getSessionId() { return sessionId; }
        public int getScore() { return score; }
    }

    private Challenge mapRow(ResultSet rs) throws SQLException {
        Challenge challenge = new Challenge();
        challenge.setChallengeId(rs.getInt("challenge_id"));
        challenge.setSessionId(rs.getString("session_id"));
        challenge.setDescription(rs.getString("description"));
        challenge.setImagePath(rs.getString("image_path"));
        challenge.setPoints(rs.getInt("points"));
        return challenge;
    }
}

