package com.foodapp.dao;

import com.foodapp.model.Cart;
import com.foodapp.model.CartItem;
import com.foodapp.model.Order;
import com.foodapp.model.OrderItem;
import com.foodapp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(int userId, Cart cart, double totalAmount) {
        return createOrder(userId, cart, totalAmount, "COD");
    }

    public boolean createOrder(int userId, Cart cart, double totalAmount, String paymentMethod) {
        String insertOrderSql = "INSERT INTO orders " +
            "(user_id, total_amount, status, payment_method, " +
            " item_subtotal, discount_amount, delivery_fee, platform_fee, ai_fee, humour_tax, gst_amount) " +
            "VALUES (?, ?, 'PENDING', ?, ?, ?, 45.00, 5.00, 10.00, 15.00, ?)";
        String insertItemSql = "INSERT INTO order_items (order_id, food_item_id, quantity, price) VALUES (?, ?, ?, ?)";

        double subTotal      = cart.getSubTotal();
        double discount      = cart.getDiscountAmount();
        double netItemTotal  = subTotal - discount;
        double gst           = Math.round(netItemTotal * 0.05 * 100.0) / 100.0;

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int orderId = -1;
            try (PreparedStatement stmt = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setDouble(2, totalAmount);
                stmt.setString(3, paymentMethod);
                stmt.setDouble(4, subTotal);
                stmt.setDouble(5, discount);
                stmt.setDouble(6, gst);
                stmt.executeUpdate();
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) orderId = rs.getInt(1);
                }
            }

            if (orderId != -1) {
                try (PreparedStatement stmt = conn.prepareStatement(insertItemSql)) {
                    for (CartItem item : cart.getItems()) {
                        stmt.setInt(1, orderId);
                        stmt.setInt(2, item.getFoodItem().getId());
                        stmt.setInt(3, item.getQuantity());
                        stmt.setDouble(4, item.getFoodItem().getPrice());
                        stmt.addBatch();
                    }
                    stmt.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    public int getLatestOrderIdForUser(int userId) {
        String query = "SELECT id FROM orders WHERE user_id = ? ORDER BY order_date DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(buildOrder(rs, conn));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) orders.add(buildOrder(rs, conn));
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

        public Order getOrderById(int orderId) {
        String query = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    return order;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
            public List<Order> getDeliveredOrdersForRider(int riderId) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE rider_id = ? AND status = 'DELIVERED' ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, riderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(buildOrder(rs, conn));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }
    public List<Order> getAvailableDeliveries() {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE status = 'PREPARING' AND (rider_id IS NULL OR rider_id = 0) ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Order order = buildOrder(rs, conn);
                orders.add(order);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public List<Order> getActiveDeliveriesForRider(int riderId) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE rider_id = ? AND status != 'DELIVERED' ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, riderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = buildOrder(rs, conn);
                    orders.add(order);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public boolean assignRider(int orderId, int riderId, String riderName, String riderPhone) {
        String query = "UPDATE orders SET rider_id = ?, rider_name = ?, rider_phone = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, riderId);
            stmt.setString(2, riderName);
            stmt.setString(3, riderPhone);
            stmt.setInt(4, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String query = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Admin stats
    public int getTotalOrders() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM orders");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getTotalRevenue() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT SUM(total_amount) FROM orders WHERE status != 'REJECTED'");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTodayOrders() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURDATE()");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getTodayRevenue() {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE DATE(order_date) = CURDATE() AND status != 'REJECTED'");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Order buildOrder(ResultSet rs, Connection conn) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        try { order.setPaymentMethod(rs.getString("payment_method")); } catch (SQLException ignored) {}
        try { order.setRiderName(rs.getString("rider_name")); } catch (SQLException ignored) {}
        try { order.setRiderPhone(rs.getString("rider_phone")); } catch (SQLException ignored) {}
        try { order.setRiderId(rs.getInt("rider_id")); } catch (SQLException ignored) {}
        try { order.setRating(rs.getInt("rating")); } catch (SQLException ignored) {}
        try { order.setItemSubtotal(rs.getDouble("item_subtotal")); } catch (SQLException ignored) {}
        try { order.setDiscountAmount(rs.getDouble("discount_amount")); } catch (SQLException ignored) {}
        try { order.setDeliveryFee(rs.getDouble("delivery_fee")); } catch (SQLException ignored) {}
        try { order.setPlatformFee(rs.getDouble("platform_fee")); } catch (SQLException ignored) {}
        try { order.setAiFee(rs.getDouble("ai_fee")); } catch (SQLException ignored) {}
        try { order.setHumourTax(rs.getDouble("humour_tax")); } catch (SQLException ignored) {}
        try { order.setGstAmount(rs.getDouble("gst_amount")); } catch (SQLException ignored) {}
        order.setItems(getOrderItems(order.getId(), conn));
        return order;
    }

    private List<OrderItem> getOrderItems(int orderId, Connection conn) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String query = "SELECT oi.*, f.name FROM order_items oi JOIN food_items f ON oi.food_item_id = f.id WHERE oi.order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setFoodItemId(rs.getInt("food_item_id"));
                    item.setFoodItemName(rs.getString("name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    items.add(item);
                }
            }
        }
        return items;
    }
    public int getRestaurantTodayOrders(int restaurantId) {
        String query = "SELECT COUNT(DISTINCT o.id) FROM orders o JOIN order_items oi ON o.id = oi.order_id JOIN food_items f ON oi.food_item_id = f.id WHERE f.restaurant_id = ? AND DATE(o.order_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getRestaurantTodayRevenue(int restaurantId) {
        String query = "SELECT COALESCE(SUM(oi.price * oi.quantity), 0) FROM order_items oi JOIN orders o ON oi.order_id = o.id JOIN food_items f ON oi.food_item_id = f.id WHERE f.restaurant_id = ? AND DATE(o.order_date) = CURDATE() AND o.status != 'REJECTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }

    public List<Order> getOrdersByRestaurantId(int restaurantId) {
        List<Order> orders = new ArrayList<>();
        // Note: A simpler approach for an MVP: an order belongs to a restaurant if its first item belongs to that restaurant.
        // We'll join orders -> order_items -> food_items -> restaurant
        String query = "SELECT DISTINCT o.* FROM orders o JOIN order_items oi ON o.id = oi.order_id JOIN food_items f ON oi.food_item_id = f.id WHERE f.restaurant_id = ? ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(buildOrder(rs, conn));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public int getRestaurantTotalOrders(int restaurantId) {
        String query = "SELECT COUNT(DISTINCT o.id) FROM orders o JOIN order_items oi ON o.id = oi.order_id JOIN food_items f ON oi.food_item_id = f.id WHERE f.restaurant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getRestaurantTotalRevenue(int restaurantId) {
        String query = "SELECT SUM(oi.price * oi.quantity) FROM order_items oi JOIN orders o ON oi.order_id = o.id JOIN food_items f ON oi.food_item_id = f.id WHERE f.restaurant_id = ? AND o.status != 'REJECTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }




    public com.foodapp.model.Restaurant getRestaurantByOrderId(int orderId) {
        String query = "SELECT r.* FROM restaurants r JOIN food_items f ON r.id = f.restaurant_id JOIN order_items oi ON f.id = oi.food_item_id WHERE oi.order_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    com.foodapp.model.Restaurant r = new com.foodapp.model.Restaurant();
                    r.setId(rs.getInt("id"));
                    r.setName(rs.getString("name"));
                    try { r.setLogoUrl(rs.getString("logo_url")); } catch (java.sql.SQLException ignored) {}
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

}
