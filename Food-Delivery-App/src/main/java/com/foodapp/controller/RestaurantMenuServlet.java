package com.foodapp.controller;

import com.foodapp.dao.FoodItemDAO;
import com.foodapp.dao.RestaurantDAO;
import com.foodapp.dao.CategoryDAO;
import com.foodapp.model.Category;
import java.util.List;
import com.foodapp.model.Restaurant;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/restaurant-menu")
public class RestaurantMenuServlet extends HttpServlet {
    private FoodItemDAO foodItemDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        foodItemDAO = new FoodItemDAO();
        restaurantDAO = new RestaurantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"RESTAURANT_OWNER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        Restaurant r = restaurantDAO.getRestaurantByOwnerId(user.getId());
        if (r != null) {
            request.setAttribute("restaurant", r);
            request.setAttribute("menuItems", foodItemDAO.getFoodItems(String.valueOf(r.getId()), null, null, null));
            CategoryDAO categoryDAO = new CategoryDAO();
            request.setAttribute("allCategories", categoryDAO.getAllCategories());
        }

        request.getRequestDispatcher("restaurant_menu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"RESTAURANT_OWNER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("addFood".equals(action)) {
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            boolean isVeg = Boolean.parseBoolean(request.getParameter("isVeg"));
            String imageUrl = request.getParameter("imageUrl");
            String desc = request.getParameter("description");
            int rId = Integer.parseInt(request.getParameter("restaurantId"));

            String query = "INSERT INTO food_items (name, price, is_veg, image_url, description, restaurant_id, prep_time, category_id) VALUES (?, ?, ?, ?, ?, ?, 15, 1)";
            try (java.sql.Connection conn = com.foodapp.util.DBConnection.getConnection();
                 java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name);
                stmt.setDouble(2, price);
                stmt.setBoolean(3, isVeg);
                stmt.setString(4, imageUrl);
                stmt.setString(5, desc);
                stmt.setInt(6, rId);
                stmt.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
        } else if ("deleteFood".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            try (java.sql.Connection conn = com.foodapp.util.DBConnection.getConnection();
                 java.sql.PreparedStatement stmt = conn.prepareStatement("DELETE FROM food_items WHERE id = ?")) {
                stmt.setInt(1, foodId);
                stmt.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
                } else if ("editFood".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            boolean isVeg = Boolean.parseBoolean(request.getParameter("isVeg"));
            try (java.sql.Connection conn = com.foodapp.util.DBConnection.getConnection();
                 java.sql.PreparedStatement stmt = conn.prepareStatement("UPDATE food_items SET name=?, price=?, is_veg=? WHERE id=?")) {
                stmt.setString(1, name);
                stmt.setDouble(2, price);
                stmt.setBoolean(3, isVeg);
                stmt.setInt(4, foodId);
                stmt.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
        } else if ("toggleAvailable".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            boolean available = Boolean.parseBoolean(request.getParameter("available"));
            try (java.sql.Connection conn = com.foodapp.util.DBConnection.getConnection();
                 java.sql.PreparedStatement stmt = conn.prepareStatement("UPDATE food_items SET is_available=? WHERE id=?")) {
                stmt.setBoolean(1, available);
                stmt.setInt(2, foodId);
                stmt.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
        }

        response.sendRedirect("restaurant-menu");
    }
}

