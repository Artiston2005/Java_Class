package com.foodapp.controller;

import com.foodapp.dao.OrderDAO;
import com.foodapp.model.Order;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/rider-dashboard")
public class RiderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"DELIVERY_PARTNER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> active = orderDAO.getActiveDeliveriesForRider(user.getId());
        List<Order> available = orderDAO.getAvailableDeliveries();
        List<Order> history = orderDAO.getDeliveredOrdersForRider(user.getId());
        
        request.setAttribute("totalDeliveries", history.size());
        
        double totalEarnings = 0;
        for (Order o : history) {
            totalEarnings += o.getDeliveryFee() > 0 ? o.getDeliveryFee() : 45.0;
        }
        request.setAttribute("totalEarnings", totalEarnings);

        java.util.Map<Integer, User> customerMap = new java.util.HashMap<>();
        java.util.Map<Integer, com.foodapp.model.Restaurant> restaurantMap = new java.util.HashMap<>();
        com.foodapp.dao.UserDAO userDAO = new com.foodapp.dao.UserDAO();

        for (Order o : active) {
            if (!customerMap.containsKey(o.getUserId())) {
                customerMap.put(o.getUserId(), userDAO.getUserById(o.getUserId()));
            }
            if (!restaurantMap.containsKey(o.getId())) {
                restaurantMap.put(o.getId(), orderDAO.getRestaurantByOrderId(o.getId()));
            }
        }
        for (Order o : available) {
            if (!customerMap.containsKey(o.getUserId())) {
                customerMap.put(o.getUserId(), userDAO.getUserById(o.getUserId()));
            }
            if (!restaurantMap.containsKey(o.getId())) {
                restaurantMap.put(o.getId(), orderDAO.getRestaurantByOrderId(o.getId()));
            }
        }

        request.setAttribute("activeDeliveries", active);
        request.setAttribute("availableDeliveries", available);
        request.setAttribute("customerMap", customerMap);
        request.setAttribute("restaurantMap", restaurantMap);
        
        request.getRequestDispatcher("rider_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !"DELIVERY_PARTNER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        if ("ACCEPT_DELIVERY".equals(action)) {
            orderDAO.assignRider(orderId, user.getId(), user.getUsername(), user.getAddress()); // address holds phone for riders
            orderDAO.updateOrderStatus(orderId, "OUT_FOR_DELIVERY");
            
            // Broadcast to customer
            Order o = orderDAO.getOrderById(orderId);
            if(o != null) {
                com.foodapp.websocket.LiveUpdateServer.broadcast("customer", String.valueOf(o.getUserId()), "{\"type\":\"ORDER_STATUS_CHANGED\", \"orderId\":" + orderId + ", \"status\":\"OUT_FOR_DELIVERY\"}");
            }
        } else if ("DELIVERED".equals(action)) {
            orderDAO.updateOrderStatus(orderId, "DELIVERED");
            
            Order o = orderDAO.getOrderById(orderId);
            if(o != null) {
                com.foodapp.websocket.LiveUpdateServer.broadcast("customer", String.valueOf(o.getUserId()), "{\"type\":\"ORDER_STATUS_CHANGED\", \"orderId\":" + orderId + ", \"status\":\"DELIVERED\"}");
            }
        }

        response.sendRedirect("rider-dashboard");
    }
}