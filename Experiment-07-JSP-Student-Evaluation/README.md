# Experiment 7: JavaServer Pages (JSP) & Servlet Data Forwarding

## Objective
To develop a dynamic web application demonstrating JavaServer Pages (JSP), form handling, request attribute forwarding via `RequestDispatcher`, and Expression Language (EL) presentation.

## Concepts Covered
- **JSP Architecture:** Directives (`<%@ page ... %>`), Expression Language (`${param}` / `${attribute}`).
- **Model-to-View Communication:** Capturing HTTP POST form input via `HttpServletRequest`, setting attributes with `request.setAttribute()`, and forwarding via `request.getRequestDispatcher().forward()`.
- **Decoupled Architecture:** Clean separation between input forms (`student.jsp`), processing controllers (`HelloServlet.java`), and presentation views (`result.jsp`).

## File Structure
```
Experiment-07-JSP-Student-Evaluation/
├── pom.xml                                   # Maven build configuration
├── src/
│   └── main/
│       ├── java/com/servlet/
│       │   └── HelloServlet.java             # Controller forwarding form data to JSP
│       └── webapp/
│           ├── student.jsp                   # Student registration input form
│           └── result.jsp                    # Dynamic response view rendering attributes via EL
└── README.md                                 # Documentation
```

## How to Build and Deploy

### Prerequisites
- JDK 11 or higher
- Apache Maven
- Apache Tomcat 10 or 11 (Jakarta Servlet API 6.0)

### 1. Build the WAR package
```bash
cd Experiment-07-JSP-Student-Evaluation
mvn clean package
```
This produces `target/servlet.war`.

### 2. Deploy to Apache Tomcat
1. Deploy `servlet.war` to the `webapps/` directory of your Apache Tomcat server.
2. Start Tomcat (`bin/startup.bat` or `bin/startup.sh`).
3. Open your browser and navigate to:
   ```
   http://localhost:8080/servlet/student.jsp
   ```
4. Fill in the student form (Name, Email, Course, Age) and click **Register**.
5. The form submits to `HelloServlet` (`/hello`), which validates and forwards data to `result.jsp` displaying formatted student information via `${name}`, `${email}`, etc.
