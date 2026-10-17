package com.foodapp.controller;

import com.foodapp.dao.FoodItemDAO;
import com.foodapp.model.Cart;
import com.foodapp.model.FoodItem;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private FoodItemDAO foodItemDAO;

    @Override
    public void init() {
        foodItemDAO = new FoodItemDAO();
    }

        @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Cart> multiCart = (Map<Integer, Cart>) session.getAttribute("multiCart");
        if (multiCart != null && !multiCart.isEmpty()) {
            com.foodapp.dao.RestaurantDAO restaurantDAO = new com.foodapp.dao.RestaurantDAO();
            Map<Integer, com.foodapp.model.Restaurant> cartRestaurants = new HashMap<>();
            for (Integer rId : multiCart.keySet()) {
                cartRestaurants.put(rId, restaurantDAO.getRestaurantById(rId));
            }
            request.setAttribute("cartRestaurants", cartRestaurants);
        }
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        Map<Integer, Cart> multiCart = (Map<Integer, Cart>) session.getAttribute("multiCart");
        if (multiCart == null) {
            multiCart = new HashMap<>();
            session.setAttribute("multiCart", multiCart);
        }

        if ("clear".equals(action)) {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            multiCart.remove(restaurantId);
            response.sendRedirect("cart");
            return;
        }

        if ("add".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int quantity = 1;
            try {
                if (request.getParameter("quantity") != null) {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                }
            } catch (NumberFormatException ignored) {}
            
            FoodItem item = foodItemDAO.getFoodItemById(foodId);
            if (item != null) {
                int rId = item.getRestaurantId();
                multiCart.putIfAbsent(rId, new Cart(rId));
                multiCart.get(rId).addItem(item, quantity);
            }
            
            // Handle AJAX request
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                int totalItems = multiCart.values().stream().flatMap(c -> c.getItems().stream()).mapToInt(com.foodapp.model.CartItem::getQuantity).sum();
                response.getWriter().write("{\"status\": \"success\", \"cartCount\": " + totalItems + "}");
                return;
            }
            response.sendRedirect("menu");
        } else if ("remove".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            FoodItem item = foodItemDAO.getFoodItemById(foodId);
            if (item != null) {
                int rId = item.getRestaurantId();
                if (multiCart.containsKey(rId)) {
                    multiCart.get(rId).removeItem(foodId);
                    if (multiCart.get(rId).getItems().isEmpty()) {
                        multiCart.remove(rId);
                    }
                }
            }
            response.sendRedirect("cart");
        } else if ("apply_voucher".equals(action)) {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            String code = request.getParameter("voucherCode") != null ? request.getParameter("voucherCode").trim().toUpperCase() : "";
            com.foodapp.dao.VoucherDAO voucherDAO = new com.foodapp.dao.VoucherDAO();
            com.foodapp.model.Voucher voucher = voucherDAO.getVoucher(code);
            
            if (voucher != null && multiCart.containsKey(restaurantId) && voucher.isValidForAmount(multiCart.get(restaurantId).getSubTotal())) {
                multiCart.get(restaurantId).applyVoucher(voucher.getCode(), voucher.getDiscountPercent(), voucher.getMaxDiscountCap());
                session.setAttribute("voucherSuccess", "Voucher applied successfully!");
            } else {
                com.foodapp.model.Voucher v2 = voucherDAO.getVoucher(code);
                if (v2 != null && multiCart.containsKey(restaurantId) && !v2.isValidForAmount(multiCart.get(restaurantId).getSubTotal())) {
                    session.setAttribute("voucherError", "Minimum order of \u20b9" + (int)v2.getMinOrderAmount() + " required for this voucher!");
                } else {
                    session.setAttribute("voucherError", "Invalid or expired voucher code.");
                }
            }
            response.sendRedirect("cart");
        } else if ("remove_voucher".equals(action)) {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            if (multiCart.containsKey(restaurantId)) {
                multiCart.get(restaurantId).removeVoucher();
            }
            response.sendRedirect("cart");
        } else if ("update".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            FoodItem item = foodItemDAO.getFoodItemById(foodId);
            if (item != null) {
                int rId = item.getRestaurantId();
                if (multiCart.containsKey(rId)) {
                    multiCart.get(rId).updateItemQuantity(foodId, quantity);
                    if (multiCart.get(rId).getItems().isEmpty()) {
                        multiCart.remove(rId);
                    }
                }
            }
            
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                int totalItems = multiCart.values().stream().flatMap(c -> c.getItems().stream()).mapToInt(com.foodapp.model.CartItem::getQuantity).sum();
                response.getWriter().write("{\"status\": \"success\", \"cartCount\": " + totalItems + "}");
                return;
            }
            response.sendRedirect("cart");
            return;
        }
    }
}