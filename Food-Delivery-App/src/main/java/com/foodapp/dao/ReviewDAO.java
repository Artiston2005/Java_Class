package com.foodapp.dao;
import com.foodapp.model.Review;
import com.foodapp.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    
    public void addRestaurantReview(int userId, int restaurantId, int rating, String comment) {
        String query = "INSERT INTO restaurant_reviews (user_id, restaurant_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, restaurantId);
            stmt.setInt(3, rating);
            stmt.setString(4, comment);
            stmt.executeUpdate();
            
            // Update average rating
            try (PreparedStatement update = conn.prepareStatement("UPDATE restaurants SET rating = (SELECT AVG(rating) FROM restaurant_reviews WHERE restaurant_id = ?) WHERE id = ?")) {
                update.setInt(1, restaurantId);
                update.setInt(2, restaurantId);
                update.executeUpdate();
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }
    
    public void addFoodReview(int userId, int foodItemId, int rating, String comment) {
        String query = "INSERT INTO reviews (user_id, food_item_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, foodItemId);
            stmt.setInt(3, rating);
            stmt.setString(4, comment);
            stmt.executeUpdate();
            
            // Update average rating
            try (PreparedStatement update = conn.prepareStatement("UPDATE food_items SET rating = (SELECT AVG(rating) FROM reviews WHERE food_item_id = ?) WHERE id = ?")) {
                update.setInt(1, foodItemId);
                update.setInt(2, foodItemId);
                update.executeUpdate();
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }
    
    public List<Review> getRestaurantReviews(int restaurantId) {
        List<Review> list = new ArrayList<>();
        String query = "SELECT r.*, u.username FROM restaurant_reviews r JOIN users u ON r.user_id = u.id WHERE r.restaurant_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while(rs.next()) {
                    Review rev = new Review();
                    rev.setId(rs.getInt("id"));
                    rev.setUserId(rs.getInt("user_id"));
                    rev.setUsername(rs.getString("username"));
                    rev.setTargetId(rs.getInt("restaurant_id"));
                    rev.setRating(rs.getInt("rating"));
                    rev.setComment(rs.getString("comment"));
                    rev.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(rev);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    public double getRestaurantAverageRating(int restaurantId) {
        String query = "SELECT AVG(rating) FROM restaurant_reviews WHERE restaurant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    return avg > 0 ? avg : 0.0;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }
}