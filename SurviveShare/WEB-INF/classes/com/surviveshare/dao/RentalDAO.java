package com.surviveshare.dao;

import com.surviveshare.config.DBConnection;
import com.surviveshare.model.Rental;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RentalDAO {

    public boolean createRental(Rental rental) {
        String sql = "INSERT INTO rentals(item_id, owner_session, borrower_session, status, item_name) VALUES (?, ?, ?, 'pending', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rental.getItemId());
            ps.setString(2, rental.getOwnerSession());
            ps.setString(3, rental.getBorrowerSession());
            ps.setString(4, rental.getItemName());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Rental> getRentalsForOwner(String ownerSession) {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, i.name AS item_name_db, i.meet_time AS meet_time_info, i.meet_place AS meet_place_info " +
                "FROM rentals r LEFT JOIN items i ON r.item_id = i.item_id " +
                "WHERE r.owner_session=? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ownerSession);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowWithItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rental> getRentalsByItem(int itemId) {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, i.name AS item_name_db, i.meet_time AS meet_time_info, i.meet_place AS meet_place_info " +
                "FROM rentals r LEFT JOIN items i ON r.item_id = i.item_id " +
                "WHERE r.item_id=? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowWithItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rental> getRentalsForBorrower(String borrowerSession) {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, i.name AS item_name_db, i.meet_time AS meet_time_info, i.meet_place AS meet_place_info FROM rentals r " +
                "LEFT JOIN items i ON r.item_id = i.item_id " +
                "WHERE r.borrower_session=? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, borrowerSession);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowWithItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int rentalId, String ownerSession, String status) {
        String sql = "UPDATE rentals SET status=? WHERE rental_id=? AND owner_session=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, rentalId);
            ps.setString(3, ownerSession);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Rental mapRow(ResultSet rs) throws SQLException {
        Rental rental = new Rental();
        rental.setRentalId(rs.getInt("rental_id"));
        rental.setItemId(rs.getInt("item_id"));
        rental.setOwnerSession(rs.getString("owner_session"));
        rental.setBorrowerSession(rs.getString("borrower_session"));
        rental.setStatus(rs.getString("status"));
        rental.setItemName(rs.getString("item_name"));
        java.sql.Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            rental.setCreatedAt(ts.toLocalDateTime());
        }
        return rental;
    }

    private Rental mapRowWithItem(ResultSet rs) throws SQLException {
        Rental rental = mapRow(rs);
        if (rental.getItemName() == null || rental.getItemName().isEmpty()) {
            rental.setItemName(rs.getString("item_name_db"));
        }
        java.sql.Timestamp meetTs = rs.getTimestamp("meet_time_info");
        if (meetTs != null) {
            rental.setMeetTime(meetTs.toLocalDateTime());
        }
        rental.setMeetPlace(rs.getString("meet_place_info"));
        return rental;
    }
}
