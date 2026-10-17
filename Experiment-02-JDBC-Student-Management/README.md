# Experiment 2: Student Registration System (JDBC & MySQL)

## Objective
To develop a database-driven Java desktop application that connects to a MySQL database using Java Database Connectivity (JDBC) to persist student registration records.

## Concepts Covered
- **JDBC Architecture:** `DriverManager`, `Connection`, `PreparedStatement`, `ResultSet`.
- **MySQL Database Integration:** Driver loading (`com.mysql.cj.jdbc.Driver`), connection URL, and parameterized SQL queries.
- **Swing GUI Integration:** Binding desktop form inputs directly to database persistence operations.
- **SQL Operations:** Table creation and data insertion with prepared statements to prevent SQL injection.

## File Structure
```
Experiment-02-JDBC-Student-Management/
├── lib/
│   └── mysql-connector-j-26.7.0.jar   # MySQL JDBC Driver JAR
├── src/
│   ├── App.java                       # Application entry point
│   └── StudentRegistrationSystem.java # GUI & JDBC Database logic
├── schema.sql                         # MySQL database schema setup script
└── README.md                          # Experiment documentation
```

## Prerequisites
- Java Development Kit (JDK 11 or higher)
- MySQL Server installed and running locally on port `3306`

## Database Setup
1. Start MySQL Server.
2. Run the `schema.sql` script or execute the following SQL commands:
   ```sql
   CREATE DATABASE IF NOT EXISTS college;
   USE college;

   CREATE TABLE IF NOT EXISTS student (
       roll_no VARCHAR(50) PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       branch VARCHAR(100) NOT NULL,
       gender VARCHAR(20) NOT NULL
   );
   ```

## How to Compile and Run

1. **Navigate to the experiment directory:**
   ```bash
   cd Experiment-02-JDBC-Student-Management
   ```

2. **Compile the source files with the MySQL JDBC Driver in classpath:**
   - **On Windows (PowerShell/CMD):**
     ```cmd
     javac -cp ".;lib/*" -d bin src/*.java
     ```
   - **On Linux/macOS:**
     ```bash
     javac -cp ".:lib/*" -d bin src/*.java
     ```

3. **Run the application:**
   - **On Windows:**
     ```cmd
     java -cp "bin;lib/*" StudentRegistrationSystem
     ```
   - **On Linux/macOS:**
     ```bash
     java -cp "bin:lib/*" StudentRegistrationSystem
     ```
