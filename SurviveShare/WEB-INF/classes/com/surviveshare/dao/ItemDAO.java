package com.surviveshare.dao;

import com.surviveshare.config.DBConnection;
import com.surviveshare.model.Item;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean createItem(Item item) {
        String sql = "INSERT INTO items(session_id, name, description, image_path, price, meet_time, meet_place) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getSessionId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setString(4, item.getImagePath());
            if (item.getPrice() != null) {
                ps.setBigDecimal(5, item.getPrice());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }
            if (item.getMeetTime() != null) {
                ps.setTimestamp(6, java.sql.Timestamp.valueOf(item.getMeetTime()));
            } else {
                ps.setNull(6, java.sql.Types.TIMESTAMP);
            }
            ps.setString(7, item.getMeetPlace());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection()) {
            // 연결 인코딩 설정
            conn.setCatalog("surviveshare");
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> getItemsBySession(String sessionId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items WHERE session_id=? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Item> getRecentItems(int limit) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setCatalog("surviveshare");
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        items.add(mapRow(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public Item findById(int itemId) {
        String sql = "SELECT * FROM items WHERE item_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getItemCountBySession(String sessionId) {
        String sql = "SELECT COUNT(*) as count FROM items WHERE session_id=?";
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

    private Item mapRow(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemId(rs.getInt("item_id"));
        item.setSessionId(rs.getString("session_id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setImagePath(rs.getString("image_path"));
        item.setPrice(rs.getBigDecimal("price"));
        java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            item.setCreatedAt(timestamp.toLocalDateTime());
        }
        java.sql.Timestamp meetTimestamp = rs.getTimestamp("meet_time");
        if (meetTimestamp != null) {
            item.setMeetTime(meetTimestamp.toLocalDateTime());
        }
        item.setMeetPlace(rs.getString("meet_place"));
        return item;
    }
}
