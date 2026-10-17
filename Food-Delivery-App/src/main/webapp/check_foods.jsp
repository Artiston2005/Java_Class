<%@ page import="java.sql.*, com.foodapp.util.DBConnection" %>
<%
try (Connection conn = DBConnection.getConnection()) {
    Statement s = conn.createStatement();
    ResultSet rs = s.executeQuery("SELECT r.id, r.name, COUNT(f.id) as food_count FROM restaurants r LEFT JOIN food_items f ON r.id = f.restaurant_id GROUP BY r.id, r.name");
    while(rs.next()) {
        out.println(rs.getInt("id") + " | " + rs.getString("name") + " | " + rs.getInt("food_count"));
    }
} catch(Exception e) { out.println(e.getMessage()); }
%>
