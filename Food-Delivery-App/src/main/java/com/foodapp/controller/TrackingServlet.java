package com.foodapp.controller;

import com.foodapp.dao.OrderDAO;
import com.foodapp.dao.RestaurantDAO;
import com.foodapp.model.Order;
import com.foodapp.model.Restaurant;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/track")
public class TrackingServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        restaurantDAO = new RestaurantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Order order = null;
        String orderIdStr = request.getParameter("orderId");
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());

        if (orderIdStr == null) {
            if (!orders.isEmpty()) order = orders.get(0);
        } else {
            int orderId = Integer.parseInt(orderIdStr);
            for (Order o : orders) {
                if (o.getId() == orderId) { order = o; break; }
            }
        }

        if (order != null) {
            request.setAttribute("order", order);

            // Fetch restaurant name
            if (order.getItems() != null && !order.getItems().isEmpty()) {
                com.foodapp.model.Restaurant restaurant = orderDAO.getRestaurantByOrderId(order.getId());
                if (restaurant != null) {
                    request.setAttribute("restaurantName", restaurant.getName());
                    request.setAttribute("restaurantLogo", restaurant.getLogoUrl());
                }
            }
            // Breakdown comes straight from the order — no calculation needed
        }

        request.getRequestDispatcher("tracking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        if ("CANCEL".equals(action)) {
            // Only allow cancel if the order belongs to this user and is still PENDING
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            for (Order o : orders) {
                if (o.getId() == orderId && "PENDING".equals(o.getStatus())) {
                    orderDAO.updateOrderStatus(orderId, "REJECTED");
                    break;
                }
            }
        }

        response.sendRedirect("track?orderId=" + orderId);
    }
}
