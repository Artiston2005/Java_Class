package com.foodapp.dao;

import com.foodapp.model.FoodItem;
import com.foodapp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodItemDAO {

    private FoodItem mapRow(ResultSet rs) throws SQLException {
        FoodItem item = new FoodItem();
        item.setId(rs.getInt("id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getDouble("price"));
        item.setVeg(rs.getBoolean("is_veg"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setRating(rs.getDouble("rating"));
        item.setPrepTime(rs.getInt("prep_time"));
        item.setImageUrl(rs.getString("image_url"));
        item.setRestaurantId(rs.getInt("restaurant_id"));
        try { item.setBestseller(rs.getBoolean("is_bestseller")); } catch (SQLException ignored) {}
        try { int cal = rs.getInt("calories"); if (!rs.wasNull()) item.setCalories(cal); } catch (SQLException ignored) {}
        return item;
    }

    public List<FoodItem> getFoodItems(String restaurantIdStr, String categoryIdStr, String isVegStr, String sortByStr) {
        List<FoodItem> items = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM food_items WHERE 1=1");

        if (restaurantIdStr != null && !restaurantIdStr.isEmpty()) query.append(" AND restaurant_id = ?");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) query.append(" AND category_id = ?");
        if (isVegStr != null && !isVegStr.isEmpty()) query.append(" AND is_veg = ?");

        if ("rating".equals(sortByStr)) query.append(" ORDER BY rating DESC");
        else if ("fast".equals(sortByStr)) query.append(" ORDER BY prep_time ASC");
        else if ("price_asc".equals(sortByStr)) query.append(" ORDER BY price ASC");
        else if ("price_desc".equals(sortByStr)) query.append(" ORDER BY price DESC");
        else query.append(" ORDER BY rating DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            int paramIndex = 1;
            if (restaurantIdStr != null && !restaurantIdStr.isEmpty()) stmt.setInt(paramIndex++, Integer.parseInt(restaurantIdStr));
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) stmt.setInt(paramIndex++, Integer.parseInt(categoryIdStr));
            if (isVegStr != null && !isVegStr.isEmpty()) stmt.setBoolean(paramIndex++, Boolean.parseBoolean(isVegStr));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) items.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return items;
    }

    public FoodItem getFoodItemById(int id) {
        String query = "SELECT * FROM food_items WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<FoodItem> getBestsellers(int limit) {
        List<FoodItem> items = new ArrayList<>();
        String query = "SELECT * FROM food_items WHERE is_bestseller = 1 ORDER BY rating DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) items.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return items;
    }

    // Admin: total items, revenue
    public int getTotalFoodItems() {
        String query = "SELECT COUNT(*) FROM food_items";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}

