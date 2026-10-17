package com.foodapp.controller;

import com.google.gson.*;
import com.foodapp.model.User;
import com.foodapp.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.URI;
import java.net.http.*;
import java.sql.*;
import java.util.*;

@WebServlet("/api/chat")
public class ChatbotServlet extends HttpServlet {

    private static String getApiKey() {
        try {
            File envFile = new File(System.getProperty("user.dir") + "/.env");
            if (!envFile.exists()) envFile = new File("d:/Food delivery app/.env");
            if (envFile.exists()) {
                BufferedReader br = new BufferedReader(new FileReader(envFile));
                String line;
                while ((line = br.readLine()) != null) {
                    line = line.trim();
                    if (line.startsWith("GEMINI_API_KEY")) {
                        String[] parts = line.split("=", 2);
                        if (parts.length == 2) { br.close(); return parts[1].trim().replace("\"", ""); }
                    }
                }
                br.close();
            }
        } catch (Exception e) {}
        String sysKey = System.getenv("GEMINI_API_KEY");
        if (sysKey != null && !sysKey.trim().isEmpty()) return sysKey.trim().replace("\"", "");
        return null;
    }

    private String buildSystemPrompt(User loggedUser) {
        StringBuilder sb = new StringBuilder();

        // Strong authoritative opening
        sb.append("You are 'Foodies AI', the official AI assistant embedded inside the Foodies food delivery app.\n");
        sb.append("CRITICAL RULES:\n");
        sb.append("1. You have FULL access to the live database. The order history below is REAL and belongs to the person talking to you RIGHT NOW.\n");
        sb.append("2. NEVER say 'I don't have access to your orders' or 'I can't see your orders' — you DO have access, it is printed below.\n");
        sb.append("3. NEVER make up prices, items, or order details. Only state facts from the data below.\n");
        sb.append("4. Keep responses short (2-4 sentences), friendly, and use 1-2 emojis.\n");
        sb.append("5. Currency is Indian Rupees (Rs.).\n\n");

        sb.append("PLATFORM RULES:\n");
        sb.append("- Promo codes: WELCOME50 (50% off, max Rs.100), FESTIVE20 (20% off, min order Rs.500)\n");
        sb.append("- Free Dessert Delight unlocked when any single restaurant cart exceeds Rs.500\n");
        sb.append("- Fees per order: Delivery Rs.45, Platform Rs.5, AI Existence Rs.10, Bad Humour Tax Rs.15, GST 5%\n");
        sb.append("- You can have separate carts from multiple restaurants simultaneously\n\n");

        try (Connection conn = DBConnection.getConnection()) {
            Statement stmt = conn.createStatement();

            // All restaurants
            sb.append("=== RESTAURANTS ===\n");
            ResultSet rs = stmt.executeQuery(
                "SELECT id, name, cuisine_type, avg_rating, address FROM restaurants ORDER BY id"
            );
            while (rs.next()) {
                sb.append("- [#").append(rs.getInt("id")).append("] ")
                  .append(rs.getString("name"))
                  .append(" | ").append(rs.getString("cuisine_type"))
                  .append(" | Rating: ").append(rs.getDouble("avg_rating")).append("/5")
                  .append(" | ").append(rs.getString("address") != null ? rs.getString("address") : "Jaipur")
                  .append("\n");
            }
            rs.close();

            // Full menu grouped by restaurant
            sb.append("\n=== FULL MENU ===\n");
            rs = stmt.executeQuery(
                "SELECT f.name, f.price, f.is_veg, f.is_bestseller, f.prep_time, " +
                "c.name AS cat, r.name AS rname " +
                "FROM food_items f " +
                "JOIN restaurants r ON f.restaurant_id = r.id " +
                "LEFT JOIN categories c ON f.category_id = c.id " +
                "ORDER BY f.restaurant_id, f.id"
            );
            String lastR = "";
            while (rs.next()) {
                String rname = rs.getString("rname");
                if (!rname.equals(lastR)) {
                    sb.append("[").append(rname).append("]\n");
                    lastR = rname;
                }
                sb.append("  * ").append(rs.getString("name"))
                  .append(" | Rs.").append((int) rs.getDouble("price"))
                  .append(" | ").append(rs.getBoolean("is_veg") ? "Veg" : "Non-Veg")
                  .append(rs.getString("cat") != null ? " | " + rs.getString("cat") : "")
                  .append(" | ").append(rs.getInt("prep_time")).append(" min")
                  .append(rs.getBoolean("is_bestseller") ? " ★BESTSELLER" : "")
                  .append("\n");
            }
            rs.close();
            stmt.close();

            // User orders
            if (loggedUser != null) {
                sb.append("\n=== CURRENT USER ===\n");
                sb.append("Username: ").append(loggedUser.getUsername()).append("\n");
                sb.append("User ID: ").append(loggedUser.getId()).append("\n\n");

                sb.append("=== THIS USER'S RECENT ORDERS (read this carefully to answer order status questions) ===\n");

                PreparedStatement ps = conn.prepareStatement(
                    "SELECT o.id, o.status, o.total_amount, o.payment_method, o.order_date, " +
                    "r.name AS rname " +
                    "FROM orders o " +
                    "JOIN order_items oi ON oi.order_id = o.id " +
                    "JOIN food_items f ON f.id = oi.food_item_id " +
                    "JOIN restaurants r ON r.id = f.restaurant_id " +
                    "WHERE o.user_id = ? " +
                    "GROUP BY o.id ORDER BY o.order_date DESC LIMIT 5"
                );
                ps.setInt(1, loggedUser.getId());
                rs = ps.executeQuery();

                boolean hasOrders = false;
                while (rs.next()) {
                    hasOrders = true;
                    int orderId = rs.getInt("id");
                    sb.append("Order #").append(orderId)
                      .append(" | Status: ").append(rs.getString("status"))
                      .append(" | Total: Rs.").append(rs.getDouble("total_amount"))
                      .append(" | Payment: ").append(rs.getString("payment_method"))
                      .append(" | Restaurant: ").append(rs.getString("rname"))
                      .append(" | Date: ").append(rs.getString("order_date"))
                      .append("\n");

                    PreparedStatement ps2 = conn.prepareStatement(
                        "SELECT f.name, oi.quantity, oi.price FROM order_items oi " +
                        "JOIN food_items f ON f.id = oi.food_item_id WHERE oi.order_id = ?"
                    );
                    ps2.setInt(1, orderId);
                    ResultSet rs2 = ps2.executeQuery();
                    while (rs2.next()) {
                        sb.append("  - ").append(rs2.getInt("quantity"))
                          .append("x ").append(rs2.getString("name"))
                          .append(" @ Rs.").append(rs2.getDouble("price")).append("\n");
                    }
                    rs2.close(); ps2.close();
                }
                if (!hasOrders) sb.append("This user has no orders yet.\n");
                rs.close(); ps.close();
            } else {
                sb.append("\n=== CURRENT USER ===\n");
                sb.append("Not logged in. Cannot show personal order history.\n");
            }

        } catch (Exception e) {
            sb.append("[DB error: ").append(e.getMessage()).append("]\n");
        }

        sb.append("\nRemember: NEVER say you lack access to orders. The data is above. Answer from it directly.");
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        Map<String, String> result = new HashMap<>();

        try {
            JsonObject requestBody = gson.fromJson(request.getReader(), JsonObject.class);
            String userMessage = requestBody.has("message") ? requestBody.get("message").getAsString() : "";

            if (userMessage.isEmpty()) {
                result.put("reply", "Please ask me a question!");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            String apiKey = getApiKey();
            if (apiKey == null) {
                result.put("reply", "AI is not configured. Please add GEMINI_API_KEY to your .env file.");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            HttpSession session = request.getSession(false);
            User loggedUser = session != null ? (User) session.getAttribute("loggedUser") : null;

            String systemPrompt = buildSystemPrompt(loggedUser);
            String combinedMessage = systemPrompt + "\n\n[USER QUESTION]: " + userMessage;

            JsonObject geminiReq = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject userPart = new JsonObject();
            JsonArray textPartsArray = new JsonArray();
            JsonObject textPart = new JsonObject();
            textPart.addProperty("text", combinedMessage);
            textPartsArray.add(textPart);
            userPart.addProperty("role", "user");
            userPart.add("parts", textPartsArray);
            contents.add(userPart);
            geminiReq.add("contents", contents);

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest apiRequest = HttpRequest.newBuilder()
                    .uri(URI.create("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + apiKey))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(geminiReq.toString()))
                    .build();

            // Retry up to 3 times on 503
            HttpResponse<String> apiResponse = null;
            for (int attempt = 0; attempt < 3; attempt++) {
                apiResponse = client.send(apiRequest, HttpResponse.BodyHandlers.ofString());
                if (apiResponse.statusCode() != 503) break;
                Thread.sleep(1500);
            }

            if (apiResponse.statusCode() == 200) {
                JsonObject jsonResponse = gson.fromJson(apiResponse.body(), JsonObject.class);
                String aiText = jsonResponse.getAsJsonArray("candidates")
                        .get(0).getAsJsonObject()
                        .getAsJsonObject("content")
                        .getAsJsonArray("parts")
                        .get(0).getAsJsonObject()
                        .get("text").getAsString();
                result.put("reply", aiText);
            } else {
                result.put("reply", "The AI service is temporarily busy. Please try again in a moment! 🙏");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("reply", "An error occurred. Please try again.");
        }

        response.getWriter().write(gson.toJson(result));
    }
}