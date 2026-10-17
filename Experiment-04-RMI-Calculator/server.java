import java.rmi.Naming;
public class server {
    public static void main(String[] args) {
        try {
            calculatorimpl obj = new calculatorimpl();
            Naming.rebind("rmi://localhost/calculator", obj);
            System.out.println("RMI Server Started...");
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}