<%@ page import="java.sql.*, com.foodapp.util.DBConnection" %>
<%
out.println("<h3>Applying Database Fixes...</h3>");
try (Connection conn = DBConnection.getConnection()) {
    Statement s = conn.createStatement();
    
    String[] queries = {
        "ALTER TABLE orders ADD COLUMN payment_method VARCHAR(50) DEFAULT 'COD'",
        "ALTER TABLE orders ADD COLUMN rider_name VARCHAR(100) DEFAULT 'Ravi Kumar'",
        "ALTER TABLE orders ADD COLUMN rider_phone VARCHAR(15) DEFAULT '+91 98765 43210'",
        "ALTER TABLE orders ADD COLUMN rider_rating DECIMAL(2,1) DEFAULT 4.8",
        
        "ALTER TABLE restaurants ADD COLUMN cuisine_type VARCHAR(100) DEFAULT 'Multi-Cuisine'",
        "ALTER TABLE restaurants ADD COLUMN min_order INT DEFAULT 100",
        "ALTER TABLE restaurants ADD COLUMN free_delivery_above INT DEFAULT 299",
        "ALTER TABLE restaurants ADD COLUMN is_open TINYINT(1) DEFAULT 1",
        "ALTER TABLE restaurants ADD COLUMN offer_text VARCHAR(100) DEFAULT NULL",
        
        "ALTER TABLE food_items ADD COLUMN is_bestseller TINYINT(1) DEFAULT 0",
        "ALTER TABLE food_items ADD COLUMN calories INT DEFAULT NULL"
    };
    
    for (String q : queries) {
        try {
            s.executeUpdate(q);
            out.println("<div style='color:green'>Success: " + q + "</div>");
        } catch (Exception e) {
            out.println("<div style='color:orange'>Skipped (probably exists): " + q + "</div>");
        }
    }
    
    String[] updates = {
        "UPDATE restaurants SET cuisine_type='Indian, Tandoor', min_order=100, free_delivery_above=199, offer_text='50% OFF up to &#8377;100' WHERE id=1",
        "UPDATE restaurants SET cuisine_type='American, Fast Food', min_order=150, free_delivery_above=299, offer_text='Free Delivery' WHERE id=2",
        "UPDATE restaurants SET cuisine_type='Italian, Continental', min_order=200, free_delivery_above=399, offer_text='Buy 1 Get 1 Free' WHERE id=3",
        "UPDATE food_items SET is_bestseller=1 WHERE id IN (4,6,18,19,35,36,44)",
        "UPDATE food_items SET calories=320 WHERE id=4",
        "UPDATE food_items SET calories=280 WHERE id=6",
        "UPDATE food_items SET calories=540 WHERE id=18",
        "UPDATE food_items SET calories=890 WHERE id=19",
        "UPDATE food_items SET calories=410 WHERE id=35",
        "UPDATE food_items SET calories=750 WHERE id=36"
    };
    
    for (String u : updates) {
        try {
            s.executeUpdate(u);
            out.println("<div style='color:blue'>Updated: " + u + "</div>");
        } catch (Exception e) {
            out.println("<div style='color:red'>Failed update: " + e.getMessage() + "</div>");
        }
    }
    
    out.println("<br/><b>All database patches applied!</b>");
} catch(Exception e) {
    out.println("<b style='color:red'>Fatal Error: " + e.getMessage() + "</b>");
}
%>
