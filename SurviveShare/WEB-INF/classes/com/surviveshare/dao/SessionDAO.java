package com.surviveshare.dao;

import com.surviveshare.config.DBConnection;
import com.surviveshare.model.Session;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SessionDAO {

    public boolean createSession(String sessionId) {
        String sql = "INSERT INTO sessions(session_id, level_score) VALUES (?, 0) ON DUPLICATE KEY UPDATE session_id=session_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            // 이미 존재하는 경우 무시
            return true;
        }
    }

    public Session findBySessionId(String sessionId) {
        String sql = "SELECT * FROM sessions WHERE session_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateLevelScore(String sessionId, int score) {
        String sql = "UPDATE sessions SET level_score = ? WHERE session_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, score);
            ps.setString(2, sessionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getLevelScore(String sessionId) {
        String sql = "SELECT level_score FROM sessions WHERE session_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("level_score");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Session mapRow(ResultSet rs) throws SQLException {
        Session session = new Session();
        session.setSessionId(rs.getString("session_id"));
        session.setLevelScore(rs.getInt("level_score"));
        return session;
    }
}



