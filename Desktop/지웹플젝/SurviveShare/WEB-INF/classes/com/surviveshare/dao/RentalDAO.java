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
        String sql = "INSERT INTO rentals(item_id, owner_id, borrower_id, status) VALUES (?, ?, ?, 'pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rental.getItemId());
            ps.setInt(2, rental.getOwnerId());
            ps.setInt(3, rental.getBorrowerId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Rental> getRentalsForOwner(int ownerId) {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT * FROM rentals WHERE owner_id=? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rental> getRentalsForBorrower(int borrowerId) {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT * FROM rentals WHERE borrower_id=? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, borrowerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateStatus(int rentalId, String status) {
        String sql = "UPDATE rentals SET status=? WHERE rental_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, rentalId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Rental mapRow(ResultSet rs) throws SQLException {
        Rental rental = new Rental();
        rental.setRentalId(rs.getInt("rental_id"));
        rental.setItemId(rs.getInt("item_id"));
        rental.setOwnerId(rs.getInt("owner_id"));
        rental.setBorrowerId(rs.getInt("borrower_id"));
        rental.setStatus(rs.getString("status"));
        return rental;
    }
}
