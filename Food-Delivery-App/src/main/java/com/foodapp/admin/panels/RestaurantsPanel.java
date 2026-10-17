package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

/**
 * Restaurants panel — full CRUD for the restaurants table.
 */
public class RestaurantsPanel extends JPanel implements Refreshable {

    private final DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Name", "Cuisine", "Rating", "Delivery (min)", "Min Order (₹)", "Open", "Offer"}, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };
    private final JTable table = new JTable(model);

    public RestaurantsPanel() {
        setLayout(new BorderLayout(8, 8));
        setBackground(UIHelper.BG_DARK);
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        buildUI();
        refresh();
    }

    private void buildUI() {
        UIHelper.styleTable(table);

        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 0));
        toolbar.setBackground(UIHelper.BG_DARK);

        JButton addBtn     = UIHelper.actionButton("➕ Add",      UIHelper.SUCCESS);
        JButton editBtn    = UIHelper.actionButton("✏ Edit",     UIHelper.ACCENT);
        JButton toggleBtn  = UIHelper.actionButton("🔄 Toggle Open", UIHelper.WARNING);
        JButton deleteBtn  = UIHelper.actionButton("🗑 Delete",   UIHelper.DANGER);
        JButton refreshBtn = UIHelper.actionButton("⟳ Refresh",  UIHelper.BG_PANEL);

        toolbar.add(addBtn); toolbar.add(editBtn); toolbar.add(toggleBtn);
        toolbar.add(deleteBtn); toolbar.add(refreshBtn);

        add(toolbar, BorderLayout.NORTH);
        add(UIHelper.scrollPane(table), BorderLayout.CENTER);

        refreshBtn.addActionListener(e -> refresh());
        addBtn.addActionListener(e -> showAddDialog());
        editBtn.addActionListener(e -> showEditDialog());
        toggleBtn.addActionListener(e -> toggleOpen());
        deleteBtn.addActionListener(e -> deleteSelected());
    }

    @Override
    public void refresh() {
        SwingWorker<Void, Void> w = new SwingWorker<>() {
            final java.util.List<Object[]> rows = new java.util.ArrayList<>();

            @Override
            protected Void doInBackground() throws Exception {
                String sql = "SELECT id, name, cuisine_type, rating, delivery_time, min_order, is_open, offer_text FROM restaurants ORDER BY id";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        rows.add(new Object[]{
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("cuisine_type"),
                            String.format("%.1f", rs.getDouble("rating")),
                            rs.getInt("delivery_time"),
                            rs.getInt("min_order"),
                            rs.getBoolean("is_open") ? "✅ Open" : "❌ Closed",
                            rs.getString("offer_text")
                        });
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try { get(); } catch (Exception ex) { JOptionPane.showMessageDialog(RestaurantsPanel.this, ex.getMessage()); return; }
                model.setRowCount(0);
                for (Object[] r : rows) model.addRow(r);
            }
        };
        w.execute();
    }

    private void showAddDialog() {
        JTextField nameF     = UIHelper.darkField(18);
        JTextField cuisineF  = UIHelper.darkField(18);
        JTextField ratingF   = UIHelper.darkField(6);
        JTextField deliveryF = UIHelper.darkField(6);
        JTextField minOrdF   = UIHelper.darkField(6);
        JTextField offerF    = UIHelper.darkField(18);
        JCheckBox openBox    = new JCheckBox("Open", true);
        openBox.setBackground(UIHelper.BG_PANEL);
        openBox.setForeground(UIHelper.TEXT_PRIMARY);

        JPanel form = UsersPanel.buildForm(
            new String[]{"Name:", "Cuisine:", "Rating:", "Delivery Time (min):", "Min Order (₹):", "Offer Text:", ""},
            new Component[]{nameF, cuisineF, ratingF, deliveryF, minOrdF, offerF, openBox});

        int result = JOptionPane.showConfirmDialog(this, form, "Add Restaurant", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO restaurants (name, cuisine_type, rating, delivery_time, min_order, is_open, offer_text) VALUES (?,?,?,?,?,?,?)")) {
                ps.setString(1, nameF.getText().trim());
                ps.setString(2, cuisineF.getText().trim());
                ps.setDouble(3, Double.parseDouble(ratingF.getText().trim()));
                ps.setInt(4, Integer.parseInt(deliveryF.getText().trim()));
                ps.setInt(5, Integer.parseInt(minOrdF.getText().trim()));
                ps.setBoolean(6, openBox.isSelected());
                ps.setString(7, offerF.getText().trim());
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void showEditDialog() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a restaurant first."); return; }
        int id = (int) model.getValueAt(row, 0);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM restaurants WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return;

                JTextField nameF     = UIHelper.darkField(18);
                nameF.setText(rs.getString("name"));
                JTextField cuisineF  = UIHelper.darkField(18);
                cuisineF.setText(rs.getString("cuisine_type"));
                JTextField ratingF   = UIHelper.darkField(6);
                ratingF.setText(String.valueOf(rs.getDouble("rating")));
                JTextField deliveryF = UIHelper.darkField(6);
                deliveryF.setText(String.valueOf(rs.getInt("delivery_time")));
                JTextField minOrdF   = UIHelper.darkField(6);
                minOrdF.setText(String.valueOf(rs.getInt("min_order")));
                JTextField offerF    = UIHelper.darkField(18);
                offerF.setText(rs.getString("offer_text"));

                JPanel form = UsersPanel.buildForm(
                    new String[]{"Name:", "Cuisine:", "Rating:", "Delivery Time (min):", "Min Order (₹):", "Offer Text:"},
                    new Component[]{nameF, cuisineF, ratingF, deliveryF, minOrdF, offerF});

                int result = JOptionPane.showConfirmDialog(this, form, "Edit Restaurant #" + id,
                        JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE restaurants SET name=?, cuisine_type=?, rating=?, delivery_time=?, min_order=?, offer_text=? WHERE id=?")) {
                        upd.setString(1, nameF.getText().trim());
                        upd.setString(2, cuisineF.getText().trim());
                        upd.setDouble(3, Double.parseDouble(ratingF.getText().trim()));
                        upd.setInt(4, Integer.parseInt(deliveryF.getText().trim()));
                        upd.setInt(5, Integer.parseInt(minOrdF.getText().trim()));
                        upd.setString(6, offerF.getText().trim());
                        upd.setInt(7, id);
                        upd.executeUpdate();
                        refresh();
                    }
                }
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    private void toggleOpen() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a restaurant first."); return; }
        int id = (int) model.getValueAt(row, 0);
        String current = (String) model.getValueAt(row, 6);
        boolean nowOpen = current.contains("Open");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE restaurants SET is_open=? WHERE id=?")) {
            ps.setBoolean(1, !nowOpen);
            ps.setInt(2, id);
            ps.executeUpdate();
            refresh();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    private void deleteSelected() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a restaurant first."); return; }
        int id   = (int) model.getValueAt(row, 0);
        String name = (String) model.getValueAt(row, 1);

        int confirm = JOptionPane.showConfirmDialog(this,
                "Delete restaurant \"" + name + "\" (ID=" + id + ")?\nThis will also affect linked food items.",
                "Confirm Delete", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        if (confirm == JOptionPane.YES_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM restaurants WHERE id=?")) {
                ps.setInt(1, id);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }
}
