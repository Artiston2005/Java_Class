package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import java.awt.*;
import java.sql.*;

/**
 * Dashboard panel — shows live stats cards and today's revenue chart.
 */
public class DashboardPanel extends JPanel implements Refreshable {

    private JLabel lblTotalOrders   = new JLabel("...");
    private JLabel lblTodayOrders   = new JLabel("...");
    private JLabel lblTotalRevenue  = new JLabel("...");
    private JLabel lblTodayRevenue  = new JLabel("...");
    private JLabel lblTotalUsers    = new JLabel("...");
    private JLabel lblPendingOrders = new JLabel("...");
    private JTextArea recentArea    = new JTextArea();

    public DashboardPanel() {
        setLayout(new BorderLayout(12, 12));
        setBackground(UIHelper.BG_DARK);
        setBorder(BorderFactory.createEmptyBorder(16, 16, 16, 16));
        buildUI();
        refresh();
    }

    private void buildUI() {
        // Stats grid
        JPanel stats = new JPanel(new GridLayout(2, 3, 12, 12));
        stats.setBackground(UIHelper.BG_DARK);

        stats.add(wrapCard("📦 Total Orders",     lblTotalOrders,   UIHelper.ACCENT));
        stats.add(wrapCard("📅 Today's Orders",   lblTodayOrders,   UIHelper.INFO));
        stats.add(wrapCard("💰 Total Revenue",    lblTotalRevenue,  UIHelper.SUCCESS));
        stats.add(wrapCard("💵 Today's Revenue",  lblTodayRevenue,  UIHelper.WARNING));
        stats.add(wrapCard("👤 Total Users",      lblTotalUsers,    new Color(168, 85, 247)));
        stats.add(wrapCard("⏳ Pending Orders",   lblPendingOrders, UIHelper.DANGER));

        add(stats, BorderLayout.NORTH);

        // Recent orders
        JLabel title = new JLabel("Recent Orders");
        title.setForeground(UIHelper.TEXT_PRIMARY);
        title.setFont(new Font("Segoe UI", Font.BOLD, 15));
        title.setBorder(BorderFactory.createEmptyBorder(8, 0, 4, 0));

        recentArea.setEditable(false);
        recentArea.setFont(new Font("Monospaced", Font.PLAIN, 12));
        recentArea.setBackground(UIHelper.BG_TABLE);
        recentArea.setForeground(UIHelper.TEXT_PRIMARY);
        recentArea.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));

        JPanel center = new JPanel(new BorderLayout(4, 4));
        center.setBackground(UIHelper.BG_DARK);
        center.add(title, BorderLayout.NORTH);
        center.add(UIHelper.scrollPane(recentArea), BorderLayout.CENTER);

        add(center, BorderLayout.CENTER);
    }

    private JPanel wrapCard(String label, JLabel valueLabel, Color accent) {
        JPanel card = new JPanel(new BorderLayout(4, 4));
        card.setBackground(UIHelper.BG_PANEL);
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(accent, 2, true),
                BorderFactory.createEmptyBorder(12, 16, 12, 16)));

        JLabel lbl = new JLabel(label);
        lbl.setForeground(UIHelper.TEXT_MUTED);
        lbl.setFont(new Font("Segoe UI", Font.PLAIN, 12));

        valueLabel.setForeground(accent);
        valueLabel.setFont(new Font("Segoe UI", Font.BOLD, 28));

        card.add(lbl, BorderLayout.NORTH);
        card.add(valueLabel, BorderLayout.CENTER);
        return card;
    }

    @Override
    public void refresh() {
        SwingWorker<Void, Void> worker = new SwingWorker<>() {
            int totalOrders, todayOrders, totalUsers, pendingOrders;
            double totalRevenue, todayRevenue;
            StringBuilder recent = new StringBuilder();

            @Override
            protected Void doInBackground() throws Exception {
                try (Connection conn = DBConnection.getConnection()) {
                    totalOrders  = scalar(conn, "SELECT COUNT(*) FROM orders");
                    todayOrders  = scalar(conn, "SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURDATE()");
                    totalUsers   = scalar(conn, "SELECT COUNT(*) FROM users");
                    pendingOrders = scalar(conn, "SELECT COUNT(*) FROM orders WHERE status = 'PENDING'");
                    totalRevenue  = scalarDouble(conn, "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE status != 'REJECTED'");
                    todayRevenue  = scalarDouble(conn, "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE DATE(order_date) = CURDATE() AND status != 'REJECTED'");

                    // Recent 10 orders
                    recent.append(String.format("%-6s %-12s %-12s %s%n", "ID", "Status", "Amount", "Date"));
                    recent.append("-".repeat(60)).append("\n");
                    try (PreparedStatement ps = conn.prepareStatement(
                            "SELECT o.id, o.status, o.total_amount, o.order_date, u.username " +
                            "FROM orders o JOIN users u ON o.user_id = u.id " +
                            "ORDER BY o.order_date DESC LIMIT 10");
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            recent.append(String.format("%-6d %-12s ₹%-11.2f %s  (%s)%n",
                                    rs.getInt("id"),
                                    rs.getString("status"),
                                    rs.getDouble("total_amount"),
                                    rs.getTimestamp("order_date"),
                                    rs.getString("username")));
                        }
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try {
                    get();
                    lblTotalOrders.setText(String.valueOf(totalOrders));
                    lblTodayOrders.setText(String.valueOf(todayOrders));
                    lblTotalRevenue.setText("₹" + String.format("%.2f", totalRevenue));
                    lblTodayRevenue.setText("₹" + String.format("%.2f", todayRevenue));
                    lblTotalUsers.setText(String.valueOf(totalUsers));
                    lblPendingOrders.setText(String.valueOf(pendingOrders));
                    recentArea.setText(recent.toString());
                } catch (Exception ex) {
                    recentArea.setText("Error loading data: " + ex.getMessage());
                }
            }
        };
        worker.execute();
    }

    private int scalar(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private double scalarDouble(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }
}
