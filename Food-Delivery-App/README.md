# 🍕 Foodies - J2EE Food Delivery Application (Zomato Clone)

A comprehensive, full-stack 3-sided marketplace food delivery application built using the classic Java J2EE Web Stack (JSP, Servlets, JDBC, MySQL). Academic project demonstrating RTU Advanced Java syllabus concepts.

---

## 🛠️ Technologies Used

| Layer | Technology |
|---|---|
| **Backend** | Java 11, HttpServlet, JDBC, WebSockets (javax.websocket) |
| **Frontend** | JSP, JSTL, EL, HTML5, CSS3, Bootstrap 5, Vanilla JS, FontAwesome |
| **Database** | MySQL 8 |
| **Web Container** | Apache Tomcat 9 |
| **Build Tool** | Maven |
| **AI Integration** | Google Gemini API (gemini-3.6-flash) via Gson + dotenv-java |

---

## 🏗️ Architecture

Strictly follows **3-Tier MVC** architecture:

- **Models:** `User.java`, `Cart.java`, `CartItem.java`, `Order.java`, `FoodItem.java`, `Restaurant.java`, `Voucher.java`
- **Views:** JSP files (`menu.jsp`, `cart.jsp`, `checkout.jsp`, `tracking.jsp`, `admin.jsp`, etc.)
- **Controllers:** Servlets (`CartServlet`, `CheckoutServlet`, `MenuServlet`, `AdminServlet`, etc.)
- **DAO Pattern:** Fully decoupled SQL layer (`OrderDAO`, `UserDAO`, `FoodItemDAO`, `RestaurantDAO`, `VoucherDAO`)

---

## ✨ Features

### 🧑‍💻 1. Customer Portal

- **User Authentication:** Secure registration and login with session management.
- **Restaurant Browsing & Search:** View all restaurants with live search and 'Veg Only' filter.
- **Categorized Menus:** Food items organized into categories (Starters, Main Course, Desserts, etc.) with empty categories hidden dynamically.
- **Multi-Restaurant Cart System:** Build simultaneous, independent carts from multiple restaurants at once. Each restaurant gets its own isolated cart. Checkout is done per restaurant independently without losing other active carts.
- **Smart Cart Rewards:** Automatic "Free Dessert Delight" unlocked when any single restaurant cart crosses ₹500.
- **Detailed Bill Breakdown:** Itemized receipt with Delivery Fee, Platform Fee, AI Existence Fee, Bad Humour Tax, and GST.
- **Promo Vouchers:** Apply discount codes (`WELCOME50`, `FESTIVE20`) per cart. Supports percentage discounts with cap limits.
- **Checkout & Payments:** Multi-payment support (UPI, Card, Net Banking, COD) with address management.
- **Live Order Tracking:** Real-time WebSocket-powered status updates (Pending → Preparing → Out for Delivery → Delivered) with a Leaflet.js interactive map.
- **Review System:** Rate restaurants and food items out of 5 stars with comments.
- **AI Chatbot Assistant:** Floating Gemini-powered chatbot widget for instant menu recommendations and support.

### 🍽️ 2. Restaurant Admin Dashboard (`/restaurant-admin`)

- **Live Order Feed:** Real-time WebSocket notifications for incoming orders. Accept (PREPARING) or reject orders instantly.
- **Advanced Menu Management:** Full CRUD — add, edit, delete items with category, prep time, pricing, veg/non-veg toggle, image URL, and bestseller badge.
- **Analytics Dashboard:** Total Revenue, Total Orders, Average Customer Rating, Menu Item count, and Today's performance.
- **Customer Review Feed:** Live feed of customer star ratings and comments.

### 🛵 3. Delivery Partner Dashboard (`/rider-dashboard`)

- **Order Pool:** View all orders ready for pickup.
- **Active Delivery Mode:** Claim an order, view pickup/dropoff map routing, and mark as DELIVERED.
- **Rider Analytics:** Total Deliveries, All-Time Earnings, and Active Deliveries count.

### 🔐 4. Global Admin Panel (`/admin`)

- **8-Metric God-Mode Dashboard:** Platform Users, Total Orders, Total Revenue, Platform Commission (10%), Partner Restaurants, Today's Gross Volume.
- **Global Menu Override:** Add or edit items across any restaurant.
- **Order Monitoring:** Live view of all platform orders.

---

## 🚀 Setup Instructions

1. **Database:** Import the provided MySQL dump into your local MySQL server. Database name: `food_delivery`.
2. **Configuration:** Update `DBConnection.java` with your MySQL credentials.
3. **Environment Variables:** Create a `.env` file in the project root:
   ```
   GEMINI_API_KEY=your_api_key_here
   ```
4. **Deployment:** Open in IntelliJ IDEA, configure Apache Tomcat 9, and add the project artifact for deployment.
5. **Run:** Start Tomcat. App launches at `http://localhost:8080/food-delivery-app`.

> **Note:** Java file changes require **Build → Rebuild Project** and a Tomcat restart. JSP changes hot-reload automatically.

---

## 🗂️ Project Structure

```
src/main/
├── java/com/foodapp/
│   ├── controller/     # Servlets (CartServlet, CheckoutServlet, ChatbotServlet, ...)
│   ├── dao/            # Data Access Objects
│   ├── model/          # POJOs (Cart, FoodItem, Order, ...)
│   └── websocket/      # LiveUpdateServer.java
└── webapp/
    ├── includes/       # header.jsp, footer.jsp (AI widget)
    ├── menu.jsp        # Restaurant menu with multi-cart support
    ├── cart.jsp        # Multi-restaurant cart view
    ├── checkout.jsp    # Per-restaurant checkout
    ├── tracking.jsp    # Live order map
    └── ...
```

---

## 🧑‍🎓 Academic Context

Built for RTU Advanced Java syllabus. Demonstrates: Servlet lifecycle, Session management, JDBC with DAO pattern, WebSockets, JSTL/EL, MVC architecture, and REST-style AJAX communication.