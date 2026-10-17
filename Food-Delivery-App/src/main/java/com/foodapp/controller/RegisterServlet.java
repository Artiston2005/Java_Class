package com.foodapp.controller;

import com.foodapp.dao.UserDAO;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        String role = request.getParameter("role");
        
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        
        if ("RESTAURANT_OWNER".equals(role) || "DELIVERY_PARTNER".equals(role)) {
            newUser.setRole(role);
        } else {
            newUser.setRole("CUSTOMER");
        }
        
        newUser.setAddress("");

        boolean success = userDAO.registerUser(newUser);
        if (success) {
            response.sendRedirect("login.jsp?registered=true");
        } else {
            request.setAttribute("errorMessage", "Username already taken. Try another.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}