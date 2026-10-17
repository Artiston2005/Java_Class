# Experiment 6: Java Servlets, Filters, and Session Management

## Objective
To develop a modular web application in Java demonstrating the complete Servlet Lifecycle, Filter chains (Authentication and Request Logging), Event Listeners, and Session-based Authentication using Apache Tomcat and Maven.

## Concepts Covered
- **Servlet Architecture:** `HttpServlet`, `doGet`, `doPost`, annotation-based mapping (`@WebServlet`).
- **Servlet Filters:** `@WebFilter`, filter chains (`FilterChain`), request interception (`AuthFilter`, `RequestLoggingFilter`).
- **Session Management:** `HttpSession` (`session.setAttribute`, `session.getAttribute`, `session.invalidate`) for secure login and logout.
- **Application Lifecycle Listeners:** `@WebListener` (`ServletContextListener` in `AppListener`) to handle application startup and shutdown events.
- **Maven Webapp Archetype:** Standard packaging into a `.war` file for deployment to servlet containers like Apache Tomcat.

## File Structure
```
Experiment-06-Java-Servlets/
├── pom.xml                                   # Maven dependencies and build configuration
├── src/
│   └── main/
│       ├── java/com/servlet/
│       │   ├── AppListener.java              # Application lifecycle listener
│       │   ├── AuthFilter.java               # Authentication filter protecting routes
│       │   ├── HelloServlet.java             # Introductory servlet
│       │   ├── HomeServlet.java              # Protected dashboard servlet
│       │   ├── LoginServlet.java             # User authentication servlet
│       │   ├── LogoutServlet.java            # Session termination servlet
│       │   ├── RequestLoggingFilter.java     # HTTP request audit logging filter
│       │   └── StudentServlet.java           # Student record handling servlet
│       └── webapp/
│           └── index.html                    # Web landing page
└── README.md                                 # Documentation
```

## How to Build and Deploy

### Prerequisites
- JDK 11 or higher
- Apache Maven
- Apache Tomcat 10 or 11 (Jakarta Servlet API 6.0)

### 1. Build the WAR package using Maven
```bash
cd Experiment-06-Java-Servlets
mvn clean package
```
This generates the deployable `target/servlet.war` file.

### 2. Deploy to Apache Tomcat
1. Copy the generated `servlet.war` into Tomcat's `webapps/` folder:
   - For example: `C:\Users\ashwi\OneDrive\Desktop\Java_Class\Experiment-06-Java-Servlets\apache-tomcat-11.0.26\webapps\`
2. Start Tomcat using `bin/startup.bat` (Windows) or `bin/startup.sh` (Linux/macOS).
3. Access the application in your browser:
   - **Landing Page:** `http://localhost:8080/servlet/`
   - **Login Endpoint:** `http://localhost:8080/servlet/login`
   - **Protected Home:** `http://localhost:8080/servlet/home`
   - **Student Endpoint:** `http://localhost:8080/servlet/student`
