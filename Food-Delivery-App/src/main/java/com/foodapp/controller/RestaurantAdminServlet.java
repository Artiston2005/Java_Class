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

@WebServlet("/restaurant-admin")
public class RestaurantAdminServlet extends HttpServlet {
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

        if (user == null || !"RESTAURANT_OWNER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        Restaurant myRestaurant = restaurantDAO.getRestaurantByOwnerId(user.getId());
        if (myRestaurant == null) {
            request.setAttribute("error", "You do not own any restaurant yet.");
            request.getRequestDispatcher("restaurant_admin.jsp").forward(request, response);
            return;
        }

        // Load all orders for this restaurant
        List<Order> orders = orderDAO.getOrdersByRestaurantId(myRestaurant.getId());

        // Pending count for the badge
        int cPending = 0, cPreparing = 0, cOut = 0, cDelivered = 0, cRejected = 0;
        for (Order o : orders) {
            String s = o.getStatus();
            if ("PENDING".equals(s)) cPending++;
            else if ("PREPARING".equals(s)) cPreparing++;
            else if ("OUT_FOR_DELIVERY".equals(s)) cOut++;
            else if ("DELIVERED".equals(s)) cDelivered++;
            else if ("REJECTED".equals(s)) cRejected++;
        }

        // view=live shows only active orders needing action
        String view = request.getParameter("view");
        if ("live".equals(view)) {
            List<Order> liveOrders = new java.util.ArrayList<>();
            for (Order o : orders) {
                String s = o.getStatus();
                if ("PENDING".equals(s) || "PREPARING".equals(s)) liveOrders.add(o);
            }
            request.setAttribute("liveOrders", liveOrders);
            request.setAttribute("viewMode", "live");
        } else {
            request.setAttribute("allOrders", orders);
            request.setAttribute("recentOrders", orders.subList(0, Math.min(15, orders.size())));
            request.setAttribute("viewMode", "dashboard");
        }

        // Stats
        int todayOrders = orderDAO.getRestaurantTodayOrders(myRestaurant.getId());
        double todayRevenue = orderDAO.getRestaurantTodayRevenue(myRestaurant.getId());

        request.setAttribute("restaurant", myRestaurant);
        request.setAttribute("totalMenuCount", new com.foodapp.dao.FoodItemDAO().getFoodItems(String.valueOf(myRestaurant.getId()), null, null, null).size());
        request.setAttribute("averageRating", String.format("%.1f", myRestaurant.getRating()));
        request.setAttribute("totalOrders", orderDAO.getRestaurantTotalOrders(myRestaurant.getId()));
        request.setAttribute("totalRevenue", String.format("%.0f", orderDAO.getRestaurantTotalRevenue(myRestaurant.getId())));
        request.setAttribute("todayOrders", todayOrders);
        request.setAttribute("todayRevenue", String.format("%.0f", todayRevenue));
        request.setAttribute("pendingCount", cPending);
        request.setAttribute("chartPending", cPending);
        request.setAttribute("chartPreparing", cPreparing);
        request.setAttribute("chartOut", cOut);
        request.setAttribute("chartDelivered", cDelivered);
        request.setAttribute("chartRejected", cRejected);
        com.foodapp.dao.ReviewDAO reviewDAO = new com.foodapp.dao.ReviewDAO();
        request.setAttribute("reviews", reviewDAO.getRestaurantReviews(myRestaurant.getId()));

        request.getRequestDispatcher("restaurant_admin.jsp").forward(request, response);
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

        if ("updateOrderStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            orderDAO.updateOrderStatus(orderId, status);

            // Broadcast real-time update to the customer
            Order o = orderDAO.getOrderById(orderId);
            if (o != null) {
                String msg = "{\"type\":\"ORDER_STATUS_CHANGED\",\"orderId\":" + orderId + ",\"status\":\"" + status + "\"}";
                com.foodapp.websocket.LiveUpdateServer.broadcast("customer", String.valueOf(o.getUserId()), msg);
            }
            // If order is now PREPARING, alert ALL connected riders
            if ("PREPARING".equals(status)) {
                String riderMsg = "{\"type\":\"NEW_DELIVERY_AVAILABLE\",\"orderId\":" + orderId + "}";
                com.foodapp.websocket.LiveUpdateServer.broadcastToRole("rider", riderMsg);
            }
        }

        // Preserve the view mode after action
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("view=live")) {
            response.sendRedirect("restaurant-admin?view=live");
        } else {
            response.sendRedirect("restaurant-admin");
        }
    }
}
