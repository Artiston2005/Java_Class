# Java Class Lab Experiments & J2EE Capstone Project

[![Java](https://img.shields.io/badge/Java-11%20%7C%2017-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Maven](https://img.shields.io/badge/Apache%20Maven-3.9+-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)](https://maven.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-9%20%2F%2011-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)](https://tomcat.apache.org/)

This repository contains the complete collection of academic laboratory experiments and the full-stack Java/J2EE capstone project for Advanced Java Coursework.

---

## 📂 Repository Structure

```
Java_Class/
├── Experiment-01-Student-Registration-Form/  # GUI with Swing, AWT & Event Handling
├── Experiment-02-JDBC-Student-Management/    # MySQL Database connectivity via JDBC
├── Experiment-03-Calculator-MVC/             # Desktop Calculator adhering to MVC Pattern
├── Experiment-04-RMI-Calculator/             # Distributed computing via Java RMI
├── Experiment-05-Client-Server-Socket/       # TCP Socket programming with Multi-threading
├── Experiment-06-Java-Servlets/              # Servlets, Filters, Listeners & Sessions
├── Experiment-07-JSP-Student-Evaluation/     # JavaServer Pages, RequestDispatcher & EL
├── Food-Delivery-App/                        # Full-Stack J2EE Food Delivery Web Application
├── .gitignore                                # Git ignore configuration
└── README.md                                 # Master repository documentation
```

---

## 🧪 Lab Experiments Index

| # | Folder / Experiment Name | Core Technologies | Key Concepts Demonstrated |
|---|--------------------------|-------------------|---------------------------|
| **01** | [`Experiment-01-Student-Registration-Form`](./Experiment-01-Student-Registration-Form) | Java Swing, AWT | Graphical form design, `GridLayout`, event handling with `ActionListener`, dialog alerts. |
| **02** | [`Experiment-02-JDBC-Student-Management`](./Experiment-02-JDBC-Student-Management) | JDBC, MySQL, Swing | Database connection (`DriverManager`), `PreparedStatement`, SQL injection prevention, GUI persistence. |
| **03** | [`Experiment-03-Calculator-MVC`](./Experiment-03-Calculator-MVC) | Java Swing, MVC | Model-View-Controller separation of concerns, decoupling UI from arithmetic logic. |
| **04** | [`Experiment-04-RMI-Calculator`](./Experiment-04-RMI-Calculator) | Java RMI, Remote Objects | Distributed computing, Remote Interface, `UnicastRemoteObject`, `rmiregistry`, `Naming.rebind` & `Naming.lookup`. |
| **05** | [`Experiment-05-Client-Server-Socket`](./Experiment-05-Client-Server-Socket) | Java Networking, Threads | TCP `ServerSocket` & `Socket`, Stream I/O (`BufferedReader`, `PrintWriter`), multithreaded client handler. |
| **06** | [`Experiment-06-Java-Servlets`](./Experiment-06-Java-Servlets) | Jakarta Servlets, Maven, Tomcat | Servlet lifecycle (`@WebServlet`), `AuthFilter`, `RequestLoggingFilter`, `@WebListener`, `HttpSession` auth. |
| **07** | [`Experiment-07-JSP-Student-Evaluation`](./Experiment-07-JSP-Student-Evaluation) | JSP, Servlets, EL | Server-side rendering, `RequestDispatcher.forward()`, form parameter processing, Expression Language (`${}`). |

---

## 🍕 Capstone Project: Foodies — Food Delivery Web Application

Located in [`Food-Delivery-App`](./Food-Delivery-App)

**Foodies** is a full-featured, 3-sided marketplace food delivery application built using the classic **Java J2EE Web Stack** (JSP, Servlets, JDBC, MySQL) with real-time WebSockets and Google Gemini AI integration.

### 🛠️ Technology Stack
- **Backend:** Java 11+, `HttpServlet`, JDBC, WebSockets (`javax.websocket`)
- **Frontend:** JSP, JSTL, Expression Language (EL), HTML5, CSS3, Bootstrap 5, FontAwesome, Leaflet.js
- **Database:** MySQL 8+ with Connection Pooling
- **Web Container:** Apache Tomcat 9 / 10+
- **Build System:** Apache Maven
- **AI Integration:** Google Gemini AI API (`gemini-1.5-flash`) via Gson and Dotenv

### 🏗️ Architecture (3-Tier MVC)
- **Model Layer:** Encapsulates business entities (`User`, `Restaurant`, `FoodItem`, `Cart`, `Order`, `Voucher`, `Address`, `Review`).
- **View Layer:** Dynamic JSP interfaces (`home.jsp`, `menu.jsp`, `cart.jsp`, `checkout.jsp`, `tracking.jsp`, `admin.jsp`, `restaurant-admin.jsp`).
- **Controller Layer:** `HttpServlet` controllers (`HomeServlet`, `MenuServlet`, `CartServlet`, `CheckoutServlet`, `TrackingServlet`, `AdminServlet`, `ChatbotServlet`).
- **Data Access Objects (DAO):** Decoupled SQL persistence layer (`UserDAO`, `RestaurantDAO`, `FoodItemDAO`, `OrderDAO`, `VoucherDAO`, `AddressDAO`, `ReviewDAO`).

### ✨ Core Features
1. **Customer Portal:**
   - Registration, secure authentication, session management.
   - Restaurant discovery, live search, and 'Veg Only' filters.
   - **Isolated Multi-Restaurant Carts:** Maintain distinct carts across multiple restaurants simultaneously without item collisions.
   - Promo voucher application (`WELCOME50`, `FESTIVE20`) with automatic discount calculation.
   - Real-time order tracking with WebSockets and interactive Leaflet map.
   - AI Chatbot assistant powered by Google Gemini for smart dish recommendations.
2. **Restaurant Partner Portal (`/restaurant-admin`):**
   - Real-time WebSocket order stream (Accept, Reject, Update preparation status).
   - Menu management CRUD with category, pricing, veg/non-veg status, and badge flags.
3. **Delivery Rider Portal (`/rider`):**
   - Live dispatched order feed with GPS-simulated delivery checkpoints.
4. **Master Admin Dashboard (`/admin`):**
   - Platform revenue statistics, platform fee analytics, user and restaurant management, voucher creation.

### 🔐 Demo Credentials
| Role | Email | Password | Access Area |
|---|---|---|---|
| **Customer** | `john@example.com` | `password123` | Storefront & Carts |
| **Restaurant Admin** | `admin@burgerking.com` | `admin123` | `/restaurant-admin` |
| **Delivery Rider** | `rider@speedy.com` | `rider123` | `/rider` |
| **Platform Admin** | `admin@foodies.com` | `admin123` | `/admin` |

---

## 🚀 Getting Started

### 1. Prerequisites
- **JDK:** Java SE Development Kit 11 or higher
- **Maven:** Apache Maven 3.8+
- **MySQL Server:** Version 8.0+ running on port `3306`
- **Servlet Container:** Apache Tomcat 9 or 11

### 2. Database Setup for the Project
Execute the SQL migration scripts located in `Food-Delivery-App/src/main/resources/`:
```bash
mysql -u root -p < Food-Delivery-App/src/main/resources/schema.sql
mysql -u root -p < Food-Delivery-App/src/main/resources/create_addresses_table.sql
mysql -u root -p < Food-Delivery-App/src/main/resources/insert_50_items.sql
mysql -u root -p < Food-Delivery-App/src/main/resources/flagship_migration.sql
```

### 3. Build & Package
To package any experiment or the food delivery app:
```bash
# Example: Package Food Delivery App
cd Food-Delivery-App
mvn clean package
```
Deploy the generated `.war` file from `target/` into Tomcat's `webapps/` folder and start Tomcat.

---

## 📌 Submission Checklist

- [x] Repository created with a clean, professional structure.
- [x] All 7 lab experiments organized into distinct folders (`Experiment-01` to `Experiment-07`).
- [x] Java Project (`Food-Delivery-App`) fully organized with source code, database scripts, and assets.
- [x] Comprehensive root `README.md` and dedicated per-experiment documentation.
- [x] Clean `.gitignore` excluding build artifacts, cache, and sensitive `.env` secrets.
- [x] Accessible repository URL ready for Google Form submission:
  - **Repository URL:** `https://github.com/Artiston2005/Java_Class`

---

## 👤 Author
- **GitHub:** [@Artiston2005](https://github.com/Artiston2005)
