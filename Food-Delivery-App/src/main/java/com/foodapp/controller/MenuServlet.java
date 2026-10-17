package com.foodapp.controller;

import com.foodapp.dao.CategoryDAO;
import com.foodapp.dao.FoodItemDAO;
import com.foodapp.model.Category;
import com.foodapp.model.FoodItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private CategoryDAO categoryDAO;
    private FoodItemDAO foodItemDAO;

    private com.foodapp.dao.RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
        foodItemDAO = new FoodItemDAO();
        restaurantDAO = new com.foodapp.dao.RestaurantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String restaurantId = request.getParameter("restaurantId");
        String categoryId = request.getParameter("category");
        String isVeg = request.getParameter("veg");
        String sortBy = request.getParameter("sortBy");

        List<Category> categories = categoryDAO.getAllCategories();
        List<FoodItem> foodItems = foodItemDAO.getFoodItems(restaurantId, categoryId, isVeg, sortBy);

        request.setAttribute("categories", categories);
        request.setAttribute("foodItems", foodItems);
        
        if (restaurantId != null && !restaurantId.isEmpty()) {
            com.foodapp.model.Restaurant r = restaurantDAO.getRestaurantById(Integer.parseInt(restaurantId));
            request.setAttribute("restaurant", r);
            request.setAttribute("selectedRestaurantId", restaurantId);
        }

        // Preserve selected filters in UI
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedVeg", isVeg);
        request.setAttribute("selectedSortBy", sortBy);

        request.getRequestDispatcher("menu.jsp").forward(request, response);
    }
}

