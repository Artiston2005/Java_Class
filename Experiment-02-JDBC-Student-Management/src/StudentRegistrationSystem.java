import javax.swing.*;
import java.awt.event.*;
import java.sql.*;

public class StudentRegistrationSystem extends JFrame implements ActionListener {

    JLabel title;
    
    JLabel lblName, lblRoll, lblBranch, lblGender;

    JTextField txtName, txtRoll, txtBranch;


    JRadioButton male, female;
    ButtonGroup genderGroup;

    JCheckBox terms;

    JButton submit, reset;

    Connection con;

    public StudentRegistrationSystem() {

        // Database connection
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/college",
                    "Artiston2005",
                    "Ashwin@2005"
            );

        } catch (Exception e) {
            JOptionPane.showMessageDialog(
                    this,
                    "Database Connection Failed\n" + e.getMessage()
            );
        }

        setTitle("Student Registration Form");
        setSize(450, 450);
        setLayout(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Title
        title = new JLabel(
                "Student Registration Form",
                SwingConstants.CENTER
        );

        title.setBounds(50, 20, 350, 30);
        add(title);

        // Student Name
        lblName = new JLabel("Student Name");
        lblName.setBounds(40, 70, 120, 30);
        add(lblName);

        txtName = new JTextField();
        txtName.setBounds(170, 70, 200, 30);
        add(txtName);

        // Roll Number
        lblRoll = new JLabel("Roll Number");
        lblRoll.setBounds(40, 115, 120, 30);
        add(lblRoll);

        txtRoll = new JTextField();
        txtRoll.setBounds(170, 115, 200, 30);
        add(txtRoll);

        // Branch
        lblBranch = new JLabel("Branch");
        lblBranch.setBounds(40, 160, 120, 30);
        add(lblBranch);

        txtBranch = new JTextField();
        txtBranch.setBounds(170, 160, 200, 30);
        add(txtBranch);

        // Gender
        lblGender = new JLabel("Gender");
        lblGender.setBounds(40, 205, 120, 30);
        add(lblGender);

        male = new JRadioButton("Male");
        male.setBounds(170, 205, 80, 30);
        add(male);

        female = new JRadioButton("Female");
        female.setBounds(260, 205, 100, 30);
        add(female);

        genderGroup = new ButtonGroup();
        genderGroup.add(male);
        genderGroup.add(female);

        // Terms
        terms = new JCheckBox(
                "I accept Terms & Conditions"
        );

        terms.setBounds(40, 250, 250, 30);
        add(terms);

        // Submit
        submit = new JButton("Submit");
        submit.setBounds(100, 310, 100, 35);
        submit.addActionListener(this);
        add(submit);

        // Reset
        reset = new JButton("Reset");
        reset.setBounds(230, 310, 100, 35);
        reset.addActionListener(this);
        add(reset);

        setVisible(true);
    }

    // Save data into MySQL
    void saveData() {

        try {

            String gender;

            if (male.isSelected())
                gender = "Male";
            else
                gender = "Female";

            String sql =
                    "insert into student " +
                    "(roll_no, name, branch, gender) " +
                    "values (?, ?, ?, ?)";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(
                    1,
                    Integer.parseInt(txtRoll.getText())
            );

            ps.setString(
                    2,
                    txtName.getText()
            );

            ps.setString(
                    3,
                    txtBranch.getText()
            );

            ps.setString(
                    4,
                    gender
            );

            ps.executeUpdate();

            JOptionPane.showMessageDialog(
                    this,
                    "Registration Successful\n\n" +
                    "Name : " + txtName.getText() +
                    "\nRoll Number : " + txtRoll.getText() +
                    "\nGender : " + gender +
                    "\nBranch : " + txtBranch.getText()
            );

            ps.close();

        } catch (Exception e) {

            JOptionPane.showMessageDialog(
                    this,
                    "Database Error\n" + e.getMessage()
            );
        }
    }

    public void actionPerformed(ActionEvent e) {

        // Reset
        if (e.getSource() == reset) {

            txtName.setText("");
            txtRoll.setText("");
            txtBranch.setText("");

            genderGroup.clearSelection();

            terms.setSelected(false);

            return;
        }

        // Submit
        if (e.getSource() == submit) {

            if (txtName.getText().trim().isEmpty()) {

                JOptionPane.showMessageDialog(
                        this,
                        "Please enter Student Name"
                );

                return;
            }

            if (txtRoll.getText().trim().isEmpty()) {

                JOptionPane.showMessageDialog(
                        this,
                        "Please enter Roll Number"
                );

                return;
            }

            if (txtBranch.getText().trim().isEmpty()) {

                JOptionPane.showMessageDialog(
                        this,
                        "Please enter Branch"
                );

                return;
            }

            if (!male.isSelected() && !female.isSelected()) {

                JOptionPane.showMessageDialog(
                        this,
                        "Please select Gender"
                );

                return;
            }

            if (!terms.isSelected()) {

                JOptionPane.showMessageDialog(
                        this,
                        "Please accept Terms & Conditions"
                );

                return;
            }

            saveData();
        }
    }

    public static void main(String[] args) {

        new StudentRegistrationSystem();
    }
}