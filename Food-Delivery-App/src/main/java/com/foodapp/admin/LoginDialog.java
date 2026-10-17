package com.foodapp.admin;

import com.foodapp.util.DBConnection;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Modal login dialog that authenticates against the food_delivery database.
 * Only ADMIN role users are allowed through.
 */
public class LoginDialog extends JDialog {

    private boolean authenticated = false;

    private final JTextField userField   = new JTextField(18);
    private final JPasswordField passField = new JPasswordField(18);
    private final JLabel statusLabel      = new JLabel(" ");

    public LoginDialog(Frame owner) {
        super(owner, "Foodies Admin — Login", true);
        buildUI();
        setSize(420, 280);
        setResizable(false);
        setLocationRelativeTo(owner);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
    }

    private void buildUI() {
        JPanel root = new JPanel(new BorderLayout(10, 10));
        root.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));
        root.setBackground(new Color(30, 30, 46));

        // --- Header ---
        JLabel header = new JLabel("🍔  Foodies Admin Panel", SwingConstants.CENTER);
        header.setFont(new Font("Segoe UI", Font.BOLD, 20));
        header.setForeground(new Color(249, 115, 22));
        root.add(header, BorderLayout.NORTH);

        // --- Form ---
        JPanel form = new JPanel(new GridBagLayout());
        form.setBackground(new Color(30, 30, 46));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(6, 6, 6, 6);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        styleLabel("Username:", form, gbc, 0);
        styleField(userField, form, gbc, 0);

        styleLabel("Password:", form, gbc, 1);
        styleField(passField, form, gbc, 1);

        root.add(form, BorderLayout.CENTER);

        // --- Bottom ---
        JPanel bottom = new JPanel(new BorderLayout(4, 4));
        bottom.setBackground(new Color(30, 30, 46));

        statusLabel.setForeground(new Color(240, 100, 100));
        statusLabel.setHorizontalAlignment(SwingConstants.CENTER);
        bottom.add(statusLabel, BorderLayout.NORTH);

        JButton loginBtn = new JButton("Login");
        loginBtn.setBackground(new Color(249, 115, 22));
        loginBtn.setForeground(Color.WHITE);
        loginBtn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        loginBtn.setFocusPainted(false);
        loginBtn.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        loginBtn.addActionListener(e -> attemptLogin());
        bottom.add(loginBtn, BorderLayout.CENTER);

        root.add(bottom, BorderLayout.SOUTH);

        // Enter key triggers login
        passField.addActionListener(e -> attemptLogin());
        userField.addActionListener(e -> passField.requestFocus());

        setContentPane(root);
    }

    private void styleLabel(String text, JPanel panel, GridBagConstraints gbc, int row) {
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0;
        JLabel lbl = new JLabel(text);
        lbl.setForeground(new Color(200, 200, 220));
        lbl.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        panel.add(lbl, gbc);
    }

    private void styleField(JTextField field, JPanel panel, GridBagConstraints gbc, int row) {
        gbc.gridx = 1; gbc.gridy = row; gbc.weightx = 1;
        field.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        panel.add(field, gbc);
    }

    private void attemptLogin() {
        String username = userField.getText().trim();
        String password = new String(passField.getPassword());

        if (username.isEmpty() || password.isEmpty()) {
            statusLabel.setText("Please enter username and password.");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT role FROM users WHERE username = ? AND password = ?")) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && "ADMIN".equalsIgnoreCase(rs.getString("role"))) {
                    authenticated = true;
                    dispose();
                } else {
                    statusLabel.setText("Invalid credentials or insufficient role.");
                    passField.setText("");
                }
            }
        } catch (Exception ex) {
            statusLabel.setText("DB error: " + ex.getMessage());
        }
    }

    public boolean isAuthenticated() {
        return authenticated;
    }
}
