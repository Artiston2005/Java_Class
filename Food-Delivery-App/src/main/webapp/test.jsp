<%@ page import="com.foodapp.dao.OrderDAO" %>
<%@ page import="com.foodapp.dao.UserDAO" %>
<%@ page import="com.foodapp.model.Order" %>
<%@ page import="com.foodapp.model.User" %>
<%@ page import="com.foodapp.model.Restaurant" %>
<%@ page import="java.util.*" %>
<%
    try {
        OrderDAO orderDAO = new OrderDAO();
        UserDAO userDAO = new UserDAO();
        out.println("DAOs loaded. ");
        List<Order> available = orderDAO.getAvailableDeliveries();
        out.println("Available size: " + available.size() + ". ");
        for(Order o : available) {
            out.println("Order " + o.getId() + " user=" + o.getUserId() + ". ");
            User u = userDAO.getUserById(o.getUserId());
            out.println("User: " + (u != null ? u.getUsername() : "null") + ". ");
            Restaurant r = orderDAO.getRestaurantByOrderId(o.getId());
            out.println("Rest: " + (r != null ? r.getName() : "null") + ". ");
        }
    } catch(Exception e) {
        out.println("ERROR: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
