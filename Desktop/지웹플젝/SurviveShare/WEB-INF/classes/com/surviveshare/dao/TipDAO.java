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
        String sql = "INSERT INTO tips(user_id, title, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tip.getUserId());
            ps.setString(2, tip.getTitle());
            ps.setString(3, tip.getContent());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Tip> getRecentTips(int limit) {
        List<Tip> tips = new ArrayList<>();
        String sql = "SELECT * FROM tips ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tip tip = new Tip();
                tip.setTipId(rs.getInt("tip_id"));
                tip.setUserId(rs.getInt("user_id"));
                tip.setTitle(rs.getString("title"));
                tip.setContent(rs.getString("content"));
                tips.add(tip);
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
                Tip tip = new Tip();
                tip.setTipId(rs.getInt("tip_id"));
                tip.setUserId(rs.getInt("user_id"));
                tip.setTitle(rs.getString("title"));
                tip.setContent(rs.getString("content"));
                return tip;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
