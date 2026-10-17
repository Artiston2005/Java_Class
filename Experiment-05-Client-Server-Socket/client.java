import java.net.*;
import java.io.*;


public class client {
    public static void main(String[] args) {
        try (Socket socket = new Socket("localhost", 5000)) {
            System.out.println("Connected to the server");

            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            out.println("Hello, Server!");

            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            String
             response = in.readLine();
            System.out.println("Server response: " + response);
        } catch (IOException e) {
            System.out.println("Error occurred: " + e.getMessage());
        }
    }
}