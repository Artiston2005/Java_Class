import java.sql.*;
public class App {
    public static void main(String[] args) throws Exception {
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/College", 
            "Artiston2005", 
            "Ashwin@2005");

            PreparedStatement ps = con.prepareStatement("insert into Student values(?, ?, ?, ?)");
            ps.setInt(1, 104);
            ps.Int
        System.out.println(con);
        System.out.println("Connection created");
        con.close();
    }
}
