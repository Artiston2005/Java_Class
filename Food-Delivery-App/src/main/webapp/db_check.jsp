<%@ page import="java.sql.*, com.foodapp.util.DBConnection" %>
<%
out.println("<h3>DB Check</h3>");
try (Connection conn = DBConnection.getConnection()) {
    out.println("<b>Users:</b><br/>");
    Statement s = conn.createStatement();
    ResultSet rs = s.executeQuery("SELECT id, username, address FROM users");
    while(rs.next()) {
        out.println("User " + rs.getInt("id") + " (" + rs.getString("username") + ") Address: [" + rs.getString("address") + "]<br/>");
    }
    
    out.println("<br/><b>Addresses Table:</b><br/>");
    rs = s.executeQuery("SELECT id, user_id, address_text FROM user_addresses");
    while(rs.next()) {
        out.println("Addr " + rs.getInt("id") + " (User " + rs.getInt("user_id") + ") text: [" + rs.getString("address_text") + "]<br/>");
    }
} catch(Exception e) {
    out.println("<b style='color:red'>Error: " + e.getMessage() + "</b>");
}
%>
