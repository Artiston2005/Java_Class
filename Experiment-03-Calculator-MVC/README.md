# Experiment 3: Desktop Calculator (MVC Architecture)

## Objective
To implement a desktop calculator application in Java using Swing, strictly adhering to the Model-View-Controller (MVC) architectural design pattern.

## Architecture
This project separates concerns into three distinct layers:

- **Model (`CalculatorModel.java`)**: Handles the core mathematical calculations and business logic (addition, subtraction, multiplication, division).
- **View (`CalculatorView.java`)**: Manages the Graphical User Interface (GUI) layout using Java Swing components (`JFrame`, `JButton`, `JTextField`).
- **Controller (`CalculatorController.java`)**: Acts as an intermediary between Model and View. Listens to button actions, extracts inputs, delegates calculation to the Model, and updates the View with results.
- **Main (`Main.java`)**: Application bootstrap linking the Model, View, and Controller together.

## File Structure
```
Experiment-03-Calculator-MVC/
├── CalculatorController.java  # Controller layer
├── CalculatorModel.java       # Model layer (business logic)
├── CalculatorView.java        # View layer (Swing GUI)
├── Main.java                  # Application entry point
└── README.md                  # Documentation
```

## How to Compile and Run

1. **Navigate to the experiment directory:**
   ```bash
   cd Experiment-03-Calculator-MVC
   ```

2. **Compile all Java files:**
   ```bash
   javac *.java
   ```

3. **Run the application:**
   ```bash
   java Main
   ```

## Features
- Standard arithmetic operations: Addition (`+`), Subtraction (`-`), Multiplication (`*`), and Division (`/`).
- Separation of UI components from business logic for maintainability and scalability.
- Graceful error handling (e.g., division by zero or invalid inputs).
