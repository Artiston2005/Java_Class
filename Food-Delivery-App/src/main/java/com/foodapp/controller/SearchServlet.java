package com.foodapp.controller;

import com.foodapp.dao.RestaurantDAO;
import com.foodapp.model.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        restaurantDAO = new RestaurantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        
        if (query != null && !query.trim().isEmpty()) {
            List<Restaurant> filtered = restaurantDAO.searchRestaurants(query);
            request.setAttribute("restaurants", filtered);
            request.setAttribute("searchQuery", query);
        } else {
            request.setAttribute("restaurants", restaurantDAO.getAllRestaurants());
        }
        
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
