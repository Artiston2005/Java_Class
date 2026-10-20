import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

public class server {
    public static void main(String[] args) {
        try {
            // Automatically start RMI registry on port 1099 if not already running
            try {
                LocateRegistry.createRegistry(1099);
                System.out.println("RMI Registry started on port 1099...");
            } catch (Exception e) {
                // Registry already running
            }

            calculatorimpl obj = new calculatorimpl();
            Naming.rebind("rmi://localhost/calculator", obj);
            System.out.println("RMI Server Started...");
        } catch (Exception e) {
            System.out.println("Server error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
