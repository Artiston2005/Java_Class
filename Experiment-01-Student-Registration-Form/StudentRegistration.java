import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class StudentRegistration extends JFrame implements ActionListener {

    JLabel lblName, lblRoll, lblBranch, lblGender;
    JTextField txtName, txtRoll, txtBranch;
    JRadioButton rbMale, rbFemale;
    ButtonGroup genderGroup;
    JCheckBox chkTerms;
    JButton btnSubmit, btnReset;

    public StudentRegistration() {

        setTitle("Student Registration Form");
        setSize(450, 350);
        setLayout(new GridLayout(7, 2, 10, 10));
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Labels
        lblName = new JLabel("Name:");
        lblRoll = new JLabel("Roll No:");
        lblBranch = new JLabel("Branch:");
        lblGender = new JLabel("Gender:");

        // Text Fields
        txtName = new JTextField();
        txtRoll = new JTextField();
        txtBranch = new JTextField();

        // Radio Buttons
        rbMale = new JRadioButton("Male");
        rbFemale = new JRadioButton("Female");

        genderGroup = new ButtonGroup();
        genderGroup.add(rbMale);
        genderGroup.add(rbFemale);

        JPanel genderPanel = new JPanel();
        genderPanel.add(rbMale);
        genderPanel.add(rbFemale);

        // CheckBox
        chkTerms = new JCheckBox("I accept Terms and Conditions");

        // Buttons
        btnSubmit = new JButton("Submit");
        btnReset = new JButton("Reset");

        btnSubmit.addActionListener(this);
        btnReset.addActionListener(this);

        // Add Components
        add(lblName);
        add(txtName);

        add(lblRoll);
        add(txtRoll);

        add(lblBranch);
        add(txtBranch);

        add(lblGender);
        add(genderPanel);

        add(chkTerms);
        add(new JLabel(""));

        add(btnSubmit);
        add(btnReset);

        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {

        // Submit Button
        if (e.getSource() == btnSubmit) {

            String name = txtName.getText().trim();
            String roll = txtRoll.getText().trim();
            String branch = txtBranch.getText().trim();

            // Name Validation
            if (name.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Name cannot be empty.");
                txtName.requestFocus();
                return;
            }

            if (!name.matches("[A-Za-z ]+")) {
                JOptionPane.showMessageDialog(this,
                        "Name should contain only letters.");
                txtName.requestFocus();
                return;
            }

            // Roll Number Validation
            if (roll.isEmpty()) {
                JOptionPane.showMessageDialog(this,
                        "Roll Number cannot be empty.");
                txtRoll.requestFocus();
                return;
            }

            if (!roll.matches("\\d+")) {
                JOptionPane.showMessageDialog(this,
                        "Roll Number should contain only digits.");
                txtRoll.requestFocus();
                return;
            }

            // Branch Validation
            if (branch.isEmpty()) {
                JOptionPane.showMessageDialog(this,
                        "Branch cannot be empty.");
                txtBranch.requestFocus();
                return;
            }

            if (!branch.matches("[A-Za-z ]+")) {
                JOptionPane.showMessageDialog(this,
                        "Branch should contain only letters.");
                txtBranch.requestFocus();
                return;
            }

            // Gender Validation
            if (!rbMale.isSelected() && !rbFemale.isSelected()) {
                JOptionPane.showMessageDialog(this,
                        "Please select Gender.");
                return;
            }

            // Terms Validation
            if (!chkTerms.isSelected()) {
                JOptionPane.showMessageDialog(this,
                        "Please accept Terms and Conditions.");
                return;
            }

            // Get Gender
            String gender;
            if (rbMale.isSelected())
                gender = "Male";
            else
                gender = "Female";

            // Success Message
            JOptionPane.showMessageDialog(this,
                    "Registration Successful!\n\n"
                            + "Name : " + name
                            + "\nRoll No : " + roll
                            + "\nBranch : " + branch
                            + "\nGender : " + gender);
        }

        // Reset Button
        if (e.getSource() == btnReset) {

            txtName.setText("");
            txtRoll.setText("");
            txtBranch.setText("");

            genderGroup.clearSelection();
            chkTerms.setSelected(false);

            txtName.requestFocus();
        }
    }

    public static void main(String[] args) {
        new StudentRegistration();
    }
}