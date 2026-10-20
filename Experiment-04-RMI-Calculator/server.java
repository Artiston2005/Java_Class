import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class server {
    public static void main(String[] args) {
        try {
            // Create in-process RMI registry on default port 1099
            Registry registry = LocateRegistry.createRegistry(1099);

            calculatorimpl obj = new calculatorimpl();
            registry.rebind("calculator", obj);
            System.out.println("RMI Server Started...");
        } catch (Exception e) {
            System.out.println("Server error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
