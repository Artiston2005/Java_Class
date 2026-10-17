package com.foodapp.admin;

import javax.swing.*;
import java.awt.*;

/**
 * Entry point for the Foodies Swing Admin Application.
 * Run this class directly as a Java application (not via Tomcat).
 */
public class AdminApp {

    public static void main(String[] args) {
        // Use FlatLaf if available; fall back to Nimbus
        try {
            UIManager.setLookAndFeel("com.formdev.flatlaf.FlatDarkLaf");
        } catch (Exception ignored) {
            try {
                for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
                    if ("Nimbus".equals(info.getName())) {
                        UIManager.setLookAndFeel(info.getClassName());
                        break;
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        SwingUtilities.invokeLater(() -> {
            LoginDialog login = new LoginDialog(null);
            login.setVisible(true);
            if (login.isAuthenticated()) {
                MainAdminFrame frame = new MainAdminFrame();
                frame.setVisible(true);
            } else {
                System.exit(0);
            }
        });
    }
}
