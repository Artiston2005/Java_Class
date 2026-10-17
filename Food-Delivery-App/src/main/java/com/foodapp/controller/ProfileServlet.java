package com.foodapp.controller;

import com.foodapp.dao.AddressDAO;
import com.foodapp.dao.OrderDAO;
import com.foodapp.dao.UserDAO;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private AddressDAO addressDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        addressDAO = new AddressDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        request.setAttribute("orders", orderDAO.getOrdersByUserId(user.getId()));
        request.setAttribute("addresses", addressDAO.getAddressesByUserId(user.getId()));
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        String action = request.getParameter("action");
        if ("addAddress".equals(action)) {
            String label   = request.getParameter("label");
            String flatNo  = request.getParameter("flatNo");
            String area    = request.getParameter("area");
            String pincode = request.getParameter("pincode");
            String landmark = request.getParameter("landmark");

            StringBuilder fullAddress = new StringBuilder();
            if (flatNo != null && !flatNo.trim().isEmpty()) fullAddress.append(flatNo).append(", ");
            if (area != null && !area.trim().isEmpty()) fullAddress.append(area);
            if (landmark != null && !landmark.trim().isEmpty()) fullAddress.append(", Near ").append(landmark);
            if (pincode != null && !pincode.trim().isEmpty()) fullAddress.append(" - ").append(pincode);

            double lat = 0, lng = 0;
            try { lat = Double.parseDouble(request.getParameter("lat")); } catch (Exception ignored) {}
            try { lng = Double.parseDouble(request.getParameter("lng")); } catch (Exception ignored) {}

            com.foodapp.model.Address a = new com.foodapp.model.Address();
            a.setUserId(user.getId());
            a.setLabel(label != null ? label : "Home");
            a.setAddressText(fullAddress.toString());
            a.setLatitude(lat);
            a.setLongitude(lng);

            if (addressDAO.addAddress(a)) {
                // Update primary address in users table and session
                userDAO.updateAddress(user.getId(), fullAddress.toString());
                user.setAddress(fullAddress.toString());
                session.setAttribute("loggedUser", user);
                session.setAttribute("profileMessage", "Address saved successfully!");
            } else {
                session.setAttribute("profileError", "Failed to save address to database.");
            }
                } else if ("rateOrder".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            try (java.sql.Connection conn = com.foodapp.util.DBConnection.getConnection()) {
                // 1. Get the restaurant ID for this order
                int restaurantId = -1;
                try (java.sql.PreparedStatement stmt = conn.prepareStatement(
                        "SELECT f.restaurant_id FROM order_items oi JOIN food_items f ON oi.food_item_id = f.id WHERE oi.order_id = ? LIMIT 1")) {
                    stmt.setInt(1, orderId);
                    try (java.sql.ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) restaurantId = rs.getInt(1);
                    }
                }
                
                com.foodapp.dao.ReviewDAO reviewDAO = new com.foodapp.dao.ReviewDAO();
                
                // 2. Add Restaurant Review
                if (restaurantId != -1) {
                    int restRating = 5;
                    try { restRating = Integer.parseInt(request.getParameter("restaurantRating")); } catch (Exception ignored){}
                    String restComment = request.getParameter("restaurantComment");
                    reviewDAO.addRestaurantReview(user.getId(), restaurantId, restRating, restComment);
                }
                
                // 3. Add Food Reviews (we need to find all food item params)
                java.util.Enumeration<String> params = request.getParameterNames();
                while (params.hasMoreElements()) {
                    String param = params.nextElement();
                    if (param.startsWith("foodRating_")) {
                        int foodId = Integer.parseInt(param.substring("foodRating_".length()));
                        int foodRating = Integer.parseInt(request.getParameter(param));
                        String foodComment = request.getParameter("foodComment_" + foodId);
                        reviewDAO.addFoodReview(user.getId(), foodId, foodRating, foodComment);
                    }
                }
                
                // Update order to rated
                try (java.sql.PreparedStatement stmt = conn.prepareStatement("UPDATE orders SET rating = 1 WHERE id = ?")) {
                    stmt.setInt(1, orderId);
                    stmt.executeUpdate();
                }

                session.setAttribute("profileMessage", "Detailed ratings submitted successfully!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("profileError", "Failed to submit rating.");
            }
        }

        response.sendRedirect("profile");
    }
}

