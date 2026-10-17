# Foodies - Food Delivery Platform (Zomato Clone)
## Technical Documentation

Foodies is a comprehensive, real-time, multi-tier food delivery ecosystem. It features role-based access for Customers, Restaurant Owners, Delivery Partners, and Platform Administrators. Built for the RTU Advanced Java syllabus.

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Java 11, Java Servlets (HttpServlet), JSP, WebSockets (javax.websocket) |
| **Database** | MySQL 8 (JDBC via DriverManager) |
| **Frontend** | HTML5, CSS3, Bootstrap 5, Vanilla JavaScript, FontAwesome 6 |
| **AI Integration** | Google Gemini API (`gemini-3.6-flash`) via Gson + dotenv-java |
| **Server** | Apache Tomcat 9 |
| **Build Tool** | Maven |

---

## Platform Architecture & Features

### 1. Customer Experience

- **Categorized Menus:** Browse restaurants and filter items by distinct categories (Starters, Main Course, etc.) with empty categories dynamically hidden based on live search and Veg-Only filters.
- **Multi-Restaurant Cart System:** The session stores a `Map<Integer, Cart>` keyed by `restaurantId`. Customers can build simultaneous, independent carts from multiple restaurants. Checkout is fully isolated per restaurant — checking out one cart never disturbs another.
- **Floating Cart Bar:** A persistent red footer bar appears when items are in the cart, showing live item count and a direct "View Cart" link.
- **Smart Cart Rewards:** Automatic "Free Dessert Delight" row injected into the cart when any single restaurant's subtotal crosses ₹500.
- **Detailed Bill Breakdown:** Itemized receipt — Item Total, Promo Discount, Delivery Partner Fee (₹45), Platform Fee (₹5), AI Existence Fee (₹10), Bad Humour Tax (₹15), GST (5%).
- **Promo Vouchers:** Apply discount codes (`WELCOME50`, `FESTIVE20`) per individual restaurant cart. Supports percentage discounts with a configurable cap amount.
- **Checkout & Payments:** Multi-payment support (UPI, Card, Net Banking, COD) with a card preview UI and address selection (Home, Work, Other).
- **Real-Time Tracking:** Place orders and track delivery status with live WebSocket updates and a Leaflet.js interactive map route showing path between restaurant and the user.
- **Favorites & Reviews:** "Heart" items to a dedicated dashboard. Rate restaurants and food items (1-5 stars) with text comments. Ratings update the global average dynamically.
- **AI Chatbot Assistant:** Floating bouncing robot widget (bottom-left) powered by the Google Gemini API. Stops bouncing when clicked. Provides instant menu help, order guidance, and recommendations.

### 2. Restaurant Owner Dashboard (`/restaurant-admin`)

- **Live Order Feed:** Real-time WebSocket notifications for incoming orders. Accept (→ PREPARING) or reject orders instantly from the dashboard.
- **Advanced Menu Management:** Full CRUD — add, edit, delete items with category assignment, prep time, pricing, veg/non-veg toggle, image URL, calories, and bestseller badge.
- **Analytics Dashboard:** Total Revenue, Total Orders, Average Customer Rating (live), Menu Item Count, Today's Orders, and Today's Revenue.
- **Customer Review Feed:** Live feed of customer text comments and star ratings directly on the dashboard.

### 3. Delivery Partner Dashboard (`/rider-dashboard`)

- **Order Pool:** View all orders in PREPARING status ready for pickup.
- **Active Delivery Mode:** Claim an order, view pickup/dropoff details with Leaflet.js map routing, and mark as DELIVERED — which broadcasts a WebSocket event to update the customer's tracking page in real-time.
- **Rider Analytics:** Top-row cards showing Total Deliveries Completed, All-Time Earnings, and Active Deliveries.

### 4. Foodies HQ Admin (`/admin`)

- **8-Metric God-Mode Dashboard:** Platform Users, Total Orders, Total Revenue, Platform Commission (10% cut), Partner Restaurants, Total Menu Items, Today's Gross Volume.
- **Global Menu Override:** Add or edit food items across any restaurant on the platform.
- **Order Monitoring:** Live view of all platform-wide orders.

---

## Multi-Cart Architecture (Key Design Decision)

The session previously stored a single `Cart` object under `sessionScope.cart`. This has been refactored to a `Map<Integer, Cart>` stored as `sessionScope.multiCart`, where the key is `restaurantId`.

**Flow:**
1. User clicks "Add" on a menu item → `CartServlet` fetches the item's `restaurantId` via `FoodItemDAO`.
2. If no cart exists for that `restaurantId`, a new `Cart` is created and inserted into the map.
3. `cart.jsp` receives the `multiCart` map, iterates over it, and renders a **separate card per restaurant** — each with its own item table, promo code field, bill breakdown, and "Checkout This Order" button.
4. Checkout passes `restaurantId` as a hidden input → `CheckoutServlet` pulls the correct `Cart` from the map, processes the order, and removes **only that restaurant's cart** from the map. Other active carts remain untouched.

---

## Database Schema Highlights

| Table | Key Columns |
|---|---|
| `users` | `id`, `role` (CUSTOMER / RESTAURANT_OWNER / DELIVERY_PARTNER / ADMIN) |
| `restaurants` | `id`, `owner_id` (FK → users), `avg_rating` (cached) |
| `food_items` | `id`, `restaurant_id`, `category_id`, `is_veg`, `prep_time`, `is_bestseller` |
| `orders` | `id`, `user_id`, `status` (PENDING / PREPARING / OUT_FOR_DELIVERY / DELIVERED), `total_amount` |
| `order_items` | `order_id`, `food_item_id`, `quantity`, `price` |
| `restaurant_reviews` | `id`, `restaurant_id`, `user_id`, `rating`, `comment` |
| `vouchers` | `id`, `code`, `discount_percent`, `min_order_amount`, `max_discount_cap` |

---

## AI Chatbot Integration

- **Servlet:** `ChatbotServlet.java` mapped to `/api/chat`
- **API:** Google Gemini `gemini-3.6-flash` model via direct HTTP POST using `java.net.http.HttpClient`
- **API Key:** Loaded securely from `.env` file using `dotenv-java` (never committed to Git)
- **Frontend:** Floating widget in `footer.jsp` with fetch-based AJAX. Renders markdown bold (`**text**`) as HTML `<strong>`.

---

## RTU Syllabus Coverage

| Syllabus Topic | How We Used It |
|---|---|
| **MVC Architecture** | Strict separation: Models (`.java` POJOs), Views (`.jsp` files), Controllers (Servlet classes) |
| **JDBC** | DAO layer (`OrderDAO`, `FoodItemDAO`, etc.) with `PreparedStatement` and `ResultSet` |
| **Servlets** | All business logic in `HttpServlet` subclasses with `doGet`/`doPost` |
| **Sessions** | `HttpSession` for login state (`loggedUser`) and multi-restaurant cart (`multiCart`) |
| **JSP** | Primary view technology for all dynamic page rendering |
| **EL (Expression Language)** | Used throughout JSPs: `${sessionScope.multiCart}`, `${cart.subTotal}` |
| **JSTL** | `<c:forEach>` for loops, `<c:if>` / `<c:choose>` for conditional rendering |
| **WebSockets** | `LiveUpdateServer.java` — real-time live tracking and restaurant order notifications |
| **N-Tier Architecture** | Client Tier (Browser) → Web Tier (Tomcat/Servlets) → Data Tier (MySQL) |

---

## Topics Not Included & Academic Justifications

| Topic | Justification |
|---|---|
| **Swing / Applets** | Legacy desktop tech. Modern browsers dropped Java Applet support due to security vulnerabilities. We use J2EE web stack for a portable, mobile-accessible web app. |
| **RMI** | Designed for Java-to-Java LAN communication. Our browser-based app communicates via HTTP/WebSockets, which has fully replaced RMI in the industry. |
| **JNDI** | Used for configuring connection pools via `context.xml`. We used direct `DriverManager.getConnection()` for simplicity and maximum portability across machines. |
| **Custom Tag Extensions** | Superseded by the industry-standard JSTL. We use JSTL and `<jsp:include>` directives throughout instead of custom tag files. |
| **i18n** | Application is intentionally scoped to the Indian market (INR ₹, Indian city names). Multi-language bundles add no backend learning value at this stage. |
| **Servlet Filters** | Authentication is handled inline within each Servlet's `doGet`/`doPost` for clarity. This makes the code path explicit and easier to trace during academic evaluation. |