package com.foodapp.controller;

import com.foodapp.util.DBConnection;
import com.foodapp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/favorites")
public class FavoritesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // We will fetch lists of favorite restaurants and foods, but for Phase 1 MVP, we just render the page.
        request.getRequestDispatcher("favorites.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            response.setStatus(401);
            return;
        }

        String targetType = request.getParameter("type"); // 'FOOD' or 'RESTAURANT'
        int targetId = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DBConnection.getConnection()) {
            // Check if it exists
            boolean exists = false;
            try (PreparedStatement check = conn.prepareStatement("SELECT id FROM favorites WHERE user_id=? AND target_type=? AND target_id=?")) {
                check.setInt(1, user.getId());
                check.setString(2, targetType);
                check.setInt(3, targetId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) exists = true;
                }
            }

            if (exists) {
                try (PreparedStatement del = conn.prepareStatement("DELETE FROM favorites WHERE user_id=? AND target_type=? AND target_id=?")) {
                    del.setInt(1, user.getId());
                    del.setString(2, targetType);
                    del.setInt(3, targetId);
                    del.executeUpdate();
                }
                response.getWriter().write("{\"status\":\"removed\"}");
            } else {
                try (PreparedStatement ins = conn.prepareStatement("INSERT INTO favorites (user_id, target_type, target_id) VALUES (?, ?, ?)")) {
                    ins.setInt(1, user.getId());
                    ins.setString(2, targetType);
                    ins.setInt(3, targetId);
                    ins.executeUpdate();
                }
                response.getWriter().write("{\"status\":\"added\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        }
    }
}