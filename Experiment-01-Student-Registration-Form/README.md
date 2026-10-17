# Experiment 1: Student Registration Form (Swing GUI)

## Objective
To design and implement a Graphical User Interface (GUI) based Student Registration Form in Java using the Swing and AWT libraries with event handling.

## Concepts Covered
- **Java Swing Components:** `JFrame`, `JLabel`, `JTextField`, `JRadioButton`, `ButtonGroup`, `JCheckBox`, `JButton`, `JOptionPane`.
- **Layout Management:** `GridLayout` for structured form layout.
- **Event Handling:** `ActionListener` interface and `actionPerformed` event handling for form submission and input validation/reset.

## File Structure
```
Experiment-01-Student-Registration-Form/
├── StudentRegistration.java    # Main application containing GUI and Event Handling
└── README.md                   # Experiment documentation
```

## How to Compile and Run

1. **Open Terminal / Command Prompt** inside this folder:
   ```bash
   cd Experiment-01-Student-Registration-Form
   ```

2. **Compile the Java file:**
   ```bash
   javac StudentRegistration.java
   ```

3. **Run the application:**
   ```bash
   java StudentRegistration
   ```

## Application Features
- Captures Student Name, Roll Number, Branch, and Gender.
- Checkbox verification for Terms & Conditions agreement.
- Input validation ensuring all fields are filled before submitting.
- Displays submitted details in a formatted dialog confirmation box.
- Reset button to clear all input fields.
