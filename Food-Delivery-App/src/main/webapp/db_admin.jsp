<%@ page import="java.sql.*, com.foodapp.util.DBConnection" %>
<%
try (Connection conn = DBConnection.getConnection()) {
    Statement s = conn.createStatement();
    ResultSet rs = s.executeQuery("SELECT username, password, role FROM users WHERE role = 'ADMIN'");
    while(rs.next()) {
        out.println(rs.getString("username") + ":" + rs.getString("password"));
    }
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
