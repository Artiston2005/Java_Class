<%@ page import="java.sql.*, com.foodapp.util.DBConnection" %>
<%
try (Connection conn = DBConnection.getConnection()) {
    Statement s = conn.createStatement();
    ResultSet rs = s.executeQuery("DESCRIBE restaurants");
    while(rs.next()) {
        out.println(rs.getString("Field") + " - " + rs.getString("Type"));
    }
} catch(Exception e) { out.println(e.getMessage()); }
%>
