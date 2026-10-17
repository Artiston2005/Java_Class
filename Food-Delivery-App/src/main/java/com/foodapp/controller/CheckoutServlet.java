package com.foodapp.controller;

import com.foodapp.model.Cart;
import com.foodapp.model.User;
import com.foodapp.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String rIdParam = request.getParameter("restaurantId");
        
        if (rIdParam == null) {
            response.sendRedirect("cart");
            return;
        }
        
        int rId = Integer.parseInt(rIdParam);
        @SuppressWarnings("unchecked")
        Map<Integer, Cart> multiCart = (Map<Integer, Cart>) session.getAttribute("multiCart");
        
        if (multiCart != null && multiCart.containsKey(rId)) {
            Cart cart = multiCart.get(rId);
            request.setAttribute("checkoutCart", cart); // Use a specific request attribute for checkout.jsp
            
            com.foodapp.dao.RestaurantDAO restaurantDAO = new com.foodapp.dao.RestaurantDAO();
            com.foodapp.model.Restaurant restaurant = restaurantDAO.getRestaurantById(rId);
            request.setAttribute("restaurant", restaurant);
            
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        } else {
            response.sendRedirect("cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        String rIdParam = request.getParameter("restaurantId");
        if (rIdParam == null) {
            response.sendRedirect("cart");
            return;
        }
        int rId = Integer.parseInt(rIdParam);

        @SuppressWarnings("unchecked")
        Map<Integer, Cart> multiCart = (Map<Integer, Cart>) session.getAttribute("multiCart");
        
        if (multiCart != null && multiCart.containsKey(rId)) {
            Cart cart = multiCart.get(rId);

            double finalAmount = cart.getTotalAmount() + 60.0 + (cart.getTotalAmount() * 0.05); // Standardized fees
            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.isEmpty()) paymentMethod = "COD";

            OrderDAO orderDAO = new OrderDAO();
            boolean success = orderDAO.createOrder(user.getId(), cart, finalAmount, paymentMethod);

            if (success) {
                int latestOrderId = orderDAO.getLatestOrderIdForUser(user.getId());
                
                // Real-time broadcast to Restaurant Owner
                com.foodapp.websocket.LiveUpdateServer.broadcast("restaurant", String.valueOf(rId), "{\"type\":\"NEW_ORDER\", \"orderId\":" + latestOrderId + "}");

                multiCart.remove(rId); // Remove only this specific cart!
                session.setAttribute("successMessage", "Order placed successfully!");
                response.sendRedirect("track?orderId=" + latestOrderId);
            } else {
                response.sendRedirect("checkout?restaurantId=" + rId + "&error=true");
            }
        } else {
            response.sendRedirect("cart");
        }
    }
}