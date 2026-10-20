import java.sql.*;

public class App {
    public static void main(String[] args) throws Exception {
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/college", 
            "Artiston2005", 
            "Ashwin@2005");

        System.out.println(con);
        System.out.println("Connection created successfully");

        // Example: Inserting a student record using PreparedStatement
        /*
        PreparedStatement ps = con.prepareStatement("insert into student values(?, ?, ?, ?)");
        ps.setString(1, "104");
        ps.setString(2, "Ashwin Yadav");
        ps.setString(3, "CSE");
        ps.setString(4, "Male");
        int rows = ps.executeUpdate();
        System.out.println("Rows inserted: " + rows);
        ps.close();
        */

        con.close();
    }
}
