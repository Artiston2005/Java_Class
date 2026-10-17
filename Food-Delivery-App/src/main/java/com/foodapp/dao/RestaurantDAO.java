package com.foodapp.dao;

import com.foodapp.model.Restaurant;
import com.foodapp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    private Restaurant mapRow(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setLogoUrl(rs.getString("logo_url"));
        r.setRating(rs.getDouble("rating"));
        r.setDeliveryTime(rs.getInt("delivery_time"));
        try { r.setCuisineType(rs.getString("cuisine_type")); } catch (SQLException ignored) {}
        try { r.setMinOrder(rs.getInt("min_order")); } catch (SQLException ignored) {}
        try { r.setFreeDeliveryAbove(rs.getInt("free_delivery_above")); } catch (SQLException ignored) {}
        try { r.setOpen(rs.getBoolean("is_open")); } catch (SQLException ignored) { r.setOpen(true); }
        try { r.setOfferText(rs.getString("offer_text")); } catch (SQLException ignored) {}
        return r;
    }

    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();
        String query = "SELECT * FROM restaurants ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) restaurants.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return restaurants;
    }

    public Restaurant getRestaurantById(int id) {
        String query = "SELECT * FROM restaurants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Restaurant> searchRestaurants(String keyword) {
        List<Restaurant> restaurants = new ArrayList<>();
        String query = "SELECT DISTINCT r.* FROM restaurants r LEFT JOIN food_items f ON r.id = f.restaurant_id WHERE r.name LIKE ? OR f.name LIKE ? ORDER BY r.rating DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            String p = "%" + keyword + "%";
            stmt.setString(1, p);
            stmt.setString(2, p);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) restaurants.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return restaurants;
    }
    
    public Restaurant getRestaurantByOwnerId(int ownerId) {
        String query = "SELECT * FROM restaurants WHERE owner_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Restaurant r = new Restaurant();
                    r.setId(rs.getInt("id"));
                    r.setName(rs.getString("name"));
                    r.setRating(rs.getDouble("rating"));
                    
                    r.setDeliveryTime(rs.getInt("delivery_time"));
                    r.setLogoUrl(rs.getString("logo_url"));
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void setRestaurantAverageRating(Restaurant r) {
        String query = "SELECT AVG(rating), COUNT(*) FROM restaurant_reviews WHERE restaurant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, r.getId());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    r.setRating(avg > 0 ? avg : 4.5); // Fallback to 4.5 if no ratings
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int getTotalRestaurants() {
        String query = "SELECT COUNT(*) FROM restaurants";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
