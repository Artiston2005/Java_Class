package com.foodapp.controller;

import com.foodapp.dao.FoodItemDAO;
import com.foodapp.dao.OrderDAO;
import com.foodapp.dao.UserDAO;
import com.foodapp.model.FoodItem;
import com.foodapp.model.Order;
import com.foodapp.model.User;
import com.foodapp.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private FoodItemDAO foodItemDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        foodItemDAO = new FoodItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        // Stats for analytics cards
        request.setAttribute("totalOrders", orderDAO.getTotalOrders());
        request.setAttribute("totalRevenue", String.format("%.0f", orderDAO.getTotalRevenue()));
        request.setAttribute("todayOrders", orderDAO.getTodayOrders());
        request.setAttribute("todayRevenue", String.format("%.0f", orderDAO.getTodayRevenue()));
        request.setAttribute("totalItems", foodItemDAO.getTotalFoodItems());
        
        UserDAO userDAO = new UserDAO();
        com.foodapp.dao.RestaurantDAO restaurantDAO = new com.foodapp.dao.RestaurantDAO();
        request.setAttribute("totalUsers", userDAO.getTotalUsers());
        request.setAttribute("totalRestaurants", restaurantDAO.getTotalRestaurants());

        // Recent 5 orders + Status Breakdown for Chart
        List<Order> orders = orderDAO.getAllOrders();
        
        long chartPending = 0, chartPreparing = 0, chartOut = 0, chartDelivered = 0, chartRejected = 0;
        for (Order o : orders) {
            if ("PENDING".equals(o.getStatus())) chartPending++;
            else if ("PREPARING".equals(o.getStatus())) chartPreparing++;
            else if ("OUT_FOR_DELIVERY".equals(o.getStatus())) chartOut++;
            else if ("DELIVERED".equals(o.getStatus())) chartDelivered++;
            else if ("REJECTED".equals(o.getStatus())) chartRejected++;
        }
        
        request.setAttribute("chartPending", chartPending);
        request.setAttribute("chartPreparing", chartPreparing);
        request.setAttribute("chartOut", chartOut);
        request.setAttribute("chartDelivered", chartDelivered);
        request.setAttribute("chartRejected", chartRejected);

        com.foodapp.dao.CategoryDAO categoryDAO = new com.foodapp.dao.CategoryDAO();
        request.setAttribute("allRestaurants", restaurantDAO.getAllRestaurants());
        request.setAttribute("allCategories", categoryDAO.getAllCategories());
        
        // Fetch existing food items and group by restaurant
        java.util.List<com.foodapp.model.FoodItem> itemsList = foodItemDAO.getFoodItems(null, null, null, null);
        java.util.List<com.foodapp.model.Restaurant> rList = restaurantDAO.getAllRestaurants();
        java.util.Map<Integer, String> rMap = new java.util.HashMap<>();
        for (com.foodapp.model.Restaurant r : rList) {
            rMap.put(r.getId(), r.getName());
        }
        
        java.util.Map<String, java.util.List<com.foodapp.model.FoodItem>> groupedFoodItems = new java.util.LinkedHashMap<>();
        for (com.foodapp.model.FoodItem item : itemsList) {
            String rName = rMap.getOrDefault(item.getRestaurantId(), "Unknown Restaurant");
            groupedFoodItems.computeIfAbsent(rName, k -> new java.util.ArrayList<>()).add(item);
        }
        
        request.setAttribute("groupedFoodItems", groupedFoodItems);

        request.setAttribute("recentOrders", orders.subList(0, Math.min(5, orders.size())));

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        String action = request.getParameter("action");

        if ("addItem".equals(action)) {
            String itemIdStr = request.getParameter("itemId");
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int prepTime = Integer.parseInt(request.getParameter("prepTime"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            boolean isVeg = Boolean.parseBoolean(request.getParameter("isVeg"));
            String imageUrl = request.getParameter("imageUrl");
            String description = request.getParameter("description");

            if (itemIdStr != null && !itemIdStr.trim().isEmpty()) {
                // UPDATE existing item
                int itemId = Integer.parseInt(itemIdStr);
                String query = "UPDATE food_items SET name=?, description=?, price=?, is_veg=?, category_id=?, prep_time=?, image_url=?, restaurant_id=? WHERE id=?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, name);
                    stmt.setString(2, description);
                    stmt.setDouble(3, price);
                    stmt.setBoolean(4, isVeg);
                    stmt.setInt(5, categoryId);
                    stmt.setInt(6, prepTime);
                    stmt.setString(7, imageUrl);
                    stmt.setInt(8, restaurantId);
                    stmt.setInt(9, itemId);
                    stmt.executeUpdate();
                } catch (SQLException e) { e.printStackTrace(); }
            } else {
                // INSERT new item
                String query = "INSERT INTO food_items (name, description, price, is_veg, category_id, prep_time, image_url, restaurant_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, name);
                    stmt.setString(2, description);
                    stmt.setDouble(3, price);
                    stmt.setBoolean(4, isVeg);
                    stmt.setInt(5, categoryId);
                    stmt.setInt(6, prepTime);
                    stmt.setString(7, imageUrl);
                    stmt.setInt(8, restaurantId);
                    stmt.executeUpdate();
                } catch (SQLException e) { e.printStackTrace(); }
            }
        } else if ("updateOrderStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status"); // 'Preparing' (Accept) or 'Cancelled' (Reject)
            orderDAO.updateOrderStatus(orderId, status);
        }

        response.sendRedirect("admin?success=true");
    }
}
