<%@ page import="java.sql.*, com.foodapp.util.DBConnection" %>
<%
out.println("<h3>Seeding Restaurants and Food Items...</h3>");
try (Connection conn = DBConnection.getConnection()) {
    Statement s = conn.createStatement();
    
    // Seed 5 New Restaurants
    String[] newRestaurants = {
        "INSERT INTO restaurants (name, logo_url, rating, delivery_time, is_active, cuisine_type, min_order, free_delivery_above, is_open, offer_text) VALUES ('Sushi & Sake', 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=150', 4.8, 35, 1, 'Japanese, Sushi', 500, 999, 1, 'Free Miso Soup on &#8377;500+')",
        "INSERT INTO restaurants (name, logo_url, rating, delivery_time, is_active, cuisine_type, min_order, free_delivery_above, is_open, offer_text) VALUES ('Smash Burger Co.', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150', 4.6, 25, 1, 'American, Fast Food', 200, 399, 1, '20% OFF on Burgers')",
        "INSERT INTO restaurants (name, logo_url, rating, delivery_time, is_active, cuisine_type, min_order, free_delivery_above, is_open, offer_text) VALUES ('The Green Bowl', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=150', 4.7, 20, 1, 'Healthy, Salads', 150, 299, 1, 'Guilt-Free Eating')",
        "INSERT INTO restaurants (name, logo_url, rating, delivery_time, is_active, cuisine_type, min_order, free_delivery_above, is_open, offer_text) VALUES ('Wok This Way', 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=150', 4.3, 40, 1, 'Chinese, Pan-Asian', 250, 499, 1, 'Spicy Weekend Offer')",
        "INSERT INTO restaurants (name, logo_url, rating, delivery_time, is_active, cuisine_type, min_order, free_delivery_above, is_open, offer_text) VALUES ('Taco Fiesta', 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=150', 4.5, 30, 1, 'Mexican, Street Food', 200, 349, 1, 'Taco Tuesdays Everyday')"
    };
    
    for (String q : newRestaurants) {
        try {
            s.executeUpdate(q);
            out.println("<div style='color:green'>Added Restaurant: " + q + "</div>");
        } catch (Exception e) {
            out.println("<div style='color:red'>Failed Restaurant: " + e.getMessage() + "</div>");
        }
    }
    
    String[] restNames = {"Sushi & Sake", "Smash Burger Co.", "The Green Bowl", "Wok This Way", "Taco Fiesta"};
    int[] rIds = new int[5];
    for (int i=0; i<restNames.length; i++) {
        ResultSet rs = s.executeQuery("SELECT id FROM restaurants WHERE name = '" + restNames[i] + "' LIMIT 1");
        if (rs.next()) {
            rIds[i] = rs.getInt("id");
        }
    }

    String[][] foods = {
        {"Spicy Tuna Roll", "Fresh tuna with spicy mayo", "450", "0", "1", "15", "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80", "0"},
        {"Salmon Nigiri", "Classic fresh salmon over rice", "350", "0", "2", "10", "https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&q=80", "0"},
        {"Miso Soup", "Traditional warm miso broth", "150", "1", "4", "5", "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=400&q=80", "0"},
        
        {"Double Smash Burger", "Two crispy beef patties with cheese", "299", "0", "1", "15", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80", "1"},
        {"Truffle Fries", "Crispy fries tossed in truffle oil", "199", "1", "2", "10", "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80", "1"},
        {"Vanilla Milkshake", "Classic thick vanilla shake", "149", "1", "4", "5", "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&q=80", "1"},

        {"Quinoa Avocado Salad", "Healthy bowl of greens and quinoa", "250", "1", "1", "10", "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80", "2"},
        {"Detox Green Juice", "Spinach, celery, and apple cold pressed juice", "120", "1", "4", "5", "https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80", "2"},
        {"Grilled Tofu Wrap", "High protein vegan wrap", "180", "1", "1", "12", "https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&q=80", "2"},

        {"Hakka Noodles", "Wok-tossed noodles with veggies", "220", "1", "1", "15", "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&q=80", "3"},
        {"Chilli Chicken", "Spicy soy-glazed chicken", "280", "0", "2", "20", "https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&q=80", "3"},
        {"Veg Spring Rolls", "Crispy fried rolls with sweet chili dip", "150", "1", "2", "10", "https://images.unsplash.com/photo-1596662951482-0c4ba74a6df6?w=400&q=80", "3"},

        {"Chicken Quesadilla", "Cheesy toasted tortilla with spiced chicken", "240", "0", "1", "15", "https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=400&q=80", "4"},
        {"Classic Beef Tacos", "Three soft shell tacos with salsa", "260", "0", "1", "15", "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&q=80", "4"},
        {"Churros with Chocolate", "Crispy fried dough with rich chocolate sauce", "150", "1", "3", "10", "https://images.unsplash.com/photo-1624371414361-e670edf48f8d?w=400&q=80", "4"}
    };

    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO food_items (name, description, price, is_veg, category_id, prep_time, image_url, restaurant_id, is_bestseller) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)");
    
    for (String[] f : foods) {
        int rId = rIds[Integer.parseInt(f[7])];
        if (rId == 0) continue; 
        
        pstmt.setString(1, f[0]);
        pstmt.setString(2, f[1]);
        pstmt.setDouble(3, Double.parseDouble(f[2]));
        pstmt.setBoolean(4, f[3].equals("1"));
        pstmt.setInt(5, Integer.parseInt(f[4]));
        pstmt.setInt(6, Integer.parseInt(f[5]));
        pstmt.setString(7, f[6]);
        pstmt.setInt(8, rId);
        
        try {
            pstmt.executeUpdate();
            out.println("<div style='color:blue'>Added Food: " + f[0] + "</div>");
        } catch(Exception e) {
            out.println("<div style='color:red'>Failed Food: " + f[0] + " - " + e.getMessage() + "</div>");
        }
    }
    
    out.println("<br/><b>Database Successfully Seeded with Restaurants & Food!</b>");
} catch(Exception e) {
    out.println("<b style='color:red'>Fatal Error: " + e.getMessage() + "</b>");
}
%>
