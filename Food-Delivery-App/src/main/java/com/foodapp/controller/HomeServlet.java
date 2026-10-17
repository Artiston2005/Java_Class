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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        restaurantDAO = new RestaurantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();
        request.setAttribute("restaurants", restaurants);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
