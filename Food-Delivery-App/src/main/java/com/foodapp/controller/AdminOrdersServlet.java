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

@WebServlet("/admin/orders")
public class AdminOrdersServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Order> orders = orderDAO.getAllOrders();
        
        com.foodapp.dao.UserDAO userDAO = new com.foodapp.dao.UserDAO();
        java.util.Map<String, java.util.List<Order>> groupedOrders = new java.util.LinkedHashMap<>();
        java.util.Map<Integer, String> userNames = new java.util.HashMap<>();

        for (Order o : orders) {
            // Fetch username
            if (!userNames.containsKey(o.getUserId())) {
                User u = userDAO.getUserById(o.getUserId());
                userNames.put(o.getUserId(), u != null ? u.getUsername() : "User #" + o.getUserId());
            }

            // Fetch restaurant
            com.foodapp.model.Restaurant r = orderDAO.getRestaurantByOrderId(o.getId());
            String rName = (r != null) ? r.getName() : "Unknown Restaurant";
            
            groupedOrders.computeIfAbsent(rName, k -> new java.util.ArrayList<>()).add(o);
        }

        request.setAttribute("groupedOrders", groupedOrders);
        request.setAttribute("userNames", userNames);
        request.getRequestDispatcher("/admin_orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        if (status != null && !status.isEmpty()) {
            orderDAO.updateOrderStatus(orderId, status);
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
