package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

/**
 * Orders panel — view all orders, filter by status, update status, and see details.
 */
public class OrdersPanel extends JPanel implements Refreshable {

    private final DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "User", "Status", "Amount (₹)", "Payment", "Rider", "Date"}, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };
    private final JTable table   = new JTable(model);
    private final JComboBox<String> statusFilter = new JComboBox<>(
            new String[]{"All", "PENDING", "CONFIRMED", "PREPARING", "OUT_FOR_DELIVERY", "DELIVERED", "REJECTED"});

    public OrdersPanel() {
        setLayout(new BorderLayout(8, 8));
        setBackground(UIHelper.BG_DARK);
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        buildUI();
        refresh();
    }

    private void buildUI() {
        UIHelper.styleTable(table);

        // Colour-code the Status column
        table.getColumnModel().getColumn(2).setCellRenderer(new DefaultTableCellRenderer() {
            @Override
            public Component getTableCellRendererComponent(JTable t, Object value,
                    boolean sel, boolean focus, int row, int col) {
                super.getTableCellRendererComponent(t, value, sel, focus, row, col);
                String status = value == null ? "" : value.toString();
                setForeground(sel ? Color.WHITE : UIHelper.statusColor(status));
                setBorder(BorderFactory.createEmptyBorder(0, 6, 0, 6));
                return this;
            }
        });

        // Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 0));
        toolbar.setBackground(UIHelper.BG_DARK);

        JLabel filterLbl = new JLabel("Status:");
        filterLbl.setForeground(UIHelper.TEXT_MUTED);

        statusFilter.setBackground(UIHelper.BG_PANEL);
        statusFilter.setForeground(UIHelper.TEXT_PRIMARY);

        JButton filterBtn    = UIHelper.actionButton("Filter", UIHelper.INFO);
        JButton updateBtn    = UIHelper.actionButton("✏ Update Status", UIHelper.ACCENT);
        JButton detailBtn    = UIHelper.actionButton("🔍 Details", UIHelper.BG_PANEL);
        JButton refreshBtn   = UIHelper.actionButton("⟳ Refresh", UIHelper.BG_PANEL);

        toolbar.add(filterLbl);
        toolbar.add(statusFilter);
        toolbar.add(filterBtn);
        toolbar.add(Box.createHorizontalStrut(16));
        toolbar.add(updateBtn);
        toolbar.add(detailBtn);
        toolbar.add(refreshBtn);

        add(toolbar, BorderLayout.NORTH);
        add(UIHelper.scrollPane(table), BorderLayout.CENTER);

        filterBtn.addActionListener(e -> refresh());
        refreshBtn.addActionListener(e -> refresh());
        updateBtn.addActionListener(e -> showUpdateStatusDialog());
        detailBtn.addActionListener(e -> showDetails());
    }

    @Override
    public void refresh() {
        String filter = (String) statusFilter.getSelectedItem();
        SwingWorker<Void, Void> w = new SwingWorker<>() {
            final java.util.List<Object[]> rows = new java.util.ArrayList<>();

            @Override
            protected Void doInBackground() throws Exception {
                String sql = "All".equals(filter)
                        ? "SELECT o.id, u.username, o.status, o.total_amount, o.payment_method, o.rider_name, o.order_date " +
                          "FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC LIMIT 500"
                        : "SELECT o.id, u.username, o.status, o.total_amount, o.payment_method, o.rider_name, o.order_date " +
                          "FROM orders o JOIN users u ON o.user_id = u.id WHERE o.status = ? ORDER BY o.order_date DESC LIMIT 500";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    if (!"All".equals(filter)) ps.setString(1, filter);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            rows.add(new Object[]{
                                rs.getInt("id"),
                                rs.getString("username"),
                                rs.getString("status"),
                                String.format("%.2f", rs.getDouble("total_amount")),
                                rs.getString("payment_method"),
                                rs.getString("rider_name"),
                                rs.getTimestamp("order_date")
                            });
                        }
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try { get(); } catch (Exception ex) { JOptionPane.showMessageDialog(OrdersPanel.this, ex.getMessage()); return; }
                model.setRowCount(0);
                for (Object[] r : rows) model.addRow(r);
            }
        };
        w.execute();
    }

    private void showUpdateStatusDialog() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select an order first."); return; }
        int orderId = (int) model.getValueAt(row, 0);

        JComboBox<String> statusBox = new JComboBox<>(
                new String[]{"PENDING", "CONFIRMED", "PREPARING", "OUT_FOR_DELIVERY", "DELIVERED", "REJECTED"});
        statusBox.setSelectedItem(model.getValueAt(row, 2));
        statusBox.setBackground(UIHelper.BG_PANEL);
        statusBox.setForeground(UIHelper.TEXT_PRIMARY);

        JPanel form = new JPanel(new GridLayout(1, 2, 8, 8));
        form.setBackground(UIHelper.BG_PANEL);
        JLabel lbl = new JLabel("New Status:");
        lbl.setForeground(UIHelper.TEXT_PRIMARY);
        form.add(lbl);
        form.add(statusBox);

        int result = JOptionPane.showConfirmDialog(this, form,
                "Update Order #" + orderId + " Status", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("UPDATE orders SET status=? WHERE id=?")) {
                ps.setString(1, (String) statusBox.getSelectedItem());
                ps.setInt(2, orderId);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void showDetails() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select an order first."); return; }
        int orderId = (int) model.getValueAt(row, 0);

        StringBuilder sb = new StringBuilder();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT oi.quantity, oi.price, f.name FROM order_items oi " +
                     "JOIN food_items f ON oi.food_item_id = f.id WHERE oi.order_id = ?")) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                sb.append(String.format("Order #%d — Items:%n%n", orderId));
                sb.append(String.format("%-30s %5s %10s%n", "Item", "Qty", "Price"));
                sb.append("-".repeat(48)).append("\n");
                while (rs.next()) {
                    sb.append(String.format("%-30s %5d ₹%9.2f%n",
                            rs.getString("name"),
                            rs.getInt("quantity"),
                            rs.getDouble("price")));
                }
            }
        } catch (Exception ex) {
            sb.append("Error: ").append(ex.getMessage());
        }

        JTextArea ta = new JTextArea(sb.toString());
        ta.setEditable(false);
        ta.setFont(new Font("Monospaced", Font.PLAIN, 13));
        ta.setBackground(UIHelper.BG_TABLE);
        ta.setForeground(UIHelper.TEXT_PRIMARY);
        JOptionPane.showMessageDialog(this, new JScrollPane(ta),
                "Order Details", JOptionPane.PLAIN_MESSAGE);
    }
}
