package com.foodapp.admin;

import com.foodapp.admin.panels.*;

import javax.swing.*;
import java.awt.*;

/**
 * Main application window with a tabbed layout for all admin sections.
 */
public class MainAdminFrame extends JFrame {

    public MainAdminFrame() {
        super("🍔 Foodies Admin Panel");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setMinimumSize(new Dimension(1100, 700));
        setPreferredSize(new Dimension(1280, 800));

        buildUI();

        pack();
        setLocationRelativeTo(null);
    }

    private void buildUI() {
        // Dark toolbar at top
        JPanel topBar = new JPanel(new BorderLayout());
        topBar.setBackground(new Color(20, 20, 35));
        topBar.setBorder(BorderFactory.createEmptyBorder(8, 16, 8, 16));

        JLabel title = new JLabel("🍔  Foodies Admin Panel");
        title.setForeground(new Color(249, 115, 22));
        title.setFont(new Font("Segoe UI", Font.BOLD, 18));
        topBar.add(title, BorderLayout.WEST);

        JButton refreshBtn = new JButton("⟳ Refresh");
        refreshBtn.setBackground(new Color(249, 115, 22));
        refreshBtn.setForeground(Color.WHITE);
        refreshBtn.setFocusPainted(false);
        refreshBtn.setFont(new Font("Segoe UI", Font.BOLD, 12));
        refreshBtn.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        topBar.add(refreshBtn, BorderLayout.EAST);

        // Tabbed pane
        JTabbedPane tabs = new JTabbedPane(JTabbedPane.TOP);
        tabs.setFont(new Font("Segoe UI", Font.BOLD, 13));
        tabs.setBackground(new Color(30, 30, 46));

        DashboardPanel dashboard = new DashboardPanel();
        UsersPanel      users   = new UsersPanel();
        OrdersPanel     orders  = new OrdersPanel();
        FoodItemsPanel  food    = new FoodItemsPanel();
        RestaurantsPanel rests  = new RestaurantsPanel();
        VouchersPanel   vouchers = new VouchersPanel();
        SqlConsolePanel sql     = new SqlConsolePanel();

        tabs.addTab("📊 Dashboard",   dashboard);
        tabs.addTab("👤 Users",       users);
        tabs.addTab("📦 Orders",      orders);
        tabs.addTab("🍕 Food Items",  food);
        tabs.addTab("🏠 Restaurants", rests);
        tabs.addTab("🎟 Vouchers",    vouchers);
        tabs.addTab("🖥 SQL Console", sql);

        // Refresh button updates whichever panel is visible
        refreshBtn.addActionListener(e -> {
            Component sel = tabs.getSelectedComponent();
            if (sel instanceof Refreshable) ((Refreshable) sel).refresh();
        });

        // Auto-refresh on tab switch
        tabs.addChangeListener(e -> {
            Component sel = tabs.getSelectedComponent();
            if (sel instanceof Refreshable) ((Refreshable) sel).refresh();
        });

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(topBar, BorderLayout.NORTH);
        getContentPane().add(tabs, BorderLayout.CENTER);
    }
}
