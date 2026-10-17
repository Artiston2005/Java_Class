# Experiment 4: Remote Method Invocation (RMI) Calculator

## Objective
To implement a distributed application using Java Remote Method Invocation (RMI) that enables a client program to invoke mathematical operations running on a remote server.

## Concepts Covered
- **RMI Architecture:** Remote Interface, Remote Object Implementation, RMI Registry, Stub, and Skeleton.
- **`java.rmi.Remote` & `RemoteException`:** Declaring remote methods accessible across the network.
- **`UnicastRemoteObject`:** Exporting the remote server object to listen for incoming RMI calls.
- **`java.rmi.Naming`:** Binding (`rebind`) the implementation object in the RMI registry and looking it up (`lookup`) from the client.

## File Structure
```
Experiment-04-RMI-Calculator/
├── calculator.java       # Remote interface declaring remote methods
├── calculatorimpl.java   # Remote implementation extending UnicastRemoteObject
├── server.java           # RMI server registering the object with Naming.rebind
├── client.java           # RMI client looking up remote object and executing methods
└── README.md             # Documentation
```

## How to Compile and Run

1. **Navigate to the experiment directory:**
   ```bash
   cd Experiment-04-RMI-Calculator
   ```

2. **Compile all Java files:**
   ```bash
   javac *.java
   ```

3. **Start the RMI Registry** (in a separate terminal or background):
   - **On Windows:**
     ```cmd
     start rmiregistry
     ```
   - **On Linux/macOS:**
     ```bash
     rmiregistry &
     ```

4. **Start the Server** (in the first terminal):
   ```bash
   java server
   ```
   *Output:* `RMI Server Started...`

5. **Run the Client** (in a second terminal):
   ```bash
   java client
   ```
   *Expected Output:*
   ```
   Addition = 30
   Subtraction = 10
   ```
