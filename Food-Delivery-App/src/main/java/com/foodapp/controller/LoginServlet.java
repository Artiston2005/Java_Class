package com.foodapp.controller;

import com.foodapp.dao.UserDAO;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(username.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);

            // Role-based redirect
            switch (user.getRole()) {
                case "ADMIN":
                    response.sendRedirect("admin");
                    break;
                case "RESTAURANT_OWNER":
                    response.sendRedirect("restaurant-admin");
                    break;
                case "DELIVERY_PARTNER":
                    response.sendRedirect("rider-dashboard");
                    break;
                default: // CUSTOMER
                    response.sendRedirect("home");
                    break;
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
