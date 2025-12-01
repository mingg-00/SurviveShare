package com.surviveshare.dao;

import com.surviveshare.config.DBConnection;
import com.surviveshare.model.Tip;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TipDAO {

    public boolean createTip(Tip tip) {
        String sql = "INSERT INTO tips(session_id, title, content, image_path, hashtags) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tip.getSessionId());
            ps.setString(2, tip.getTitle());
            ps.setString(3, tip.getContent());
            ps.setString(4, tip.getImagePath());
            ps.setString(5, tip.getHashtags());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Tip> getRecentTips(int limit) {
        List<Tip> tips = new ArrayList<>();
        String sql = "SELECT * FROM tips ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection()) {
            // 연결 인코딩 설정
            conn.setCatalog("surviveshare");
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        tips.add(mapRow(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tips;
    }

    public Tip findById(int tipId) {
        String sql = "SELECT * FROM tips WHERE tip_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tipId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getTipCountBySession(String sessionId) {
        String sql = "SELECT COUNT(*) as count FROM tips WHERE session_id=?";
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

    public boolean addRecommendation(int tipId, String sessionId) {
        String sql = "INSERT IGNORE INTO tip_recommendations(tip_id, session_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tipId);
            ps.setString(2, sessionId);
            if (ps.executeUpdate() == 1) {
                // 추천 수 증가
                String updateSql = "UPDATE tips SET recommend_count = recommend_count + 1 WHERE tip_id=?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, tipId);
                    updatePs.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalRecommendCount(String sessionId) {
        String sql = "SELECT SUM(recommend_count) as total FROM tips WHERE session_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Tip mapRow(ResultSet rs) throws SQLException {
        Tip tip = new Tip();
        tip.setTipId(rs.getInt("tip_id"));
        tip.setSessionId(rs.getString("session_id"));
        tip.setTitle(rs.getString("title"));
        tip.setContent(rs.getString("content"));
        tip.setImagePath(rs.getString("image_path"));
        tip.setHashtags(rs.getString("hashtags"));
        tip.setRecommendCount(rs.getInt("recommend_count"));
        java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            tip.setCreatedAt(timestamp.toLocalDateTime());
        }
        return tip;
    }
}
