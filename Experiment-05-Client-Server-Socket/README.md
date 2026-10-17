# Experiment 5: Client-Server Socket Communication

## Objective
To develop a network application using Java Socket Programming demonstrating TCP-based communication between a multi-threaded server and a client.

## Concepts Covered
- **TCP Socket Programming:** `ServerSocket` (server side) and `Socket` (client side).
- **Stream I/O:** `BufferedReader`, `InputStreamReader`, and `PrintWriter` for sending and receiving text over TCP streams.
- **Multithreading:** `ClientHandler` extending `Thread` to handle multiple incoming client connections concurrently.

## File Structure
```
Experiment-05-Client-Server-Socket/
├── server.java    # Multi-threaded TCP server listening on port 5000
├── client.java    # TCP client sending a message and receiving a reply
└── README.md      # Documentation
```

## How to Compile and Run

1. **Navigate to the experiment directory:**
   ```bash
   cd Experiment-05-Client-Server-Socket
   ```

2. **Compile both Java files:**
   ```bash
   javac server.java client.java
   ```

3. **Start the Server** in Terminal 1:
   ```bash
   java server
   ```
   *Output:*
   ```
   Server is listening on port 5000
   ```

4. **Run the Client** in Terminal 2:
   ```bash
   java client
   ```
   *Client Output:*
   ```
   Connected to the server
   Server response: Hello, Client!
   ```
   *Server Output:*
   ```
   New client connected
   Received from client: Hello, Server!
   ```
