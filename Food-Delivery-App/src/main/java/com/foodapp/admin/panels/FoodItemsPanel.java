package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

/**
 * Food Items panel — full CRUD for the food_items table.
 */
public class FoodItemsPanel extends JPanel implements Refreshable {

    private final DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Name", "Category", "Price (₹)", "Veg", "Rating", "Prep (min)"}, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };
    private final JTable table   = new JTable(model);
    private final JTextField searchField = UIHelper.darkField(20);

    public FoodItemsPanel() {
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

        JLabel sl = new JLabel("Search:");
        sl.setForeground(UIHelper.TEXT_MUTED);
        JButton searchBtn  = UIHelper.actionButton("🔍 Search",  UIHelper.INFO);
        JButton addBtn     = UIHelper.actionButton("➕ Add",     UIHelper.SUCCESS);
        JButton editBtn    = UIHelper.actionButton("✏ Edit",    UIHelper.ACCENT);
        JButton deleteBtn  = UIHelper.actionButton("🗑 Delete",  UIHelper.DANGER);
        JButton refreshBtn = UIHelper.actionButton("⟳ Refresh", UIHelper.BG_PANEL);

        toolbar.add(sl); toolbar.add(searchField); toolbar.add(searchBtn);
        toolbar.add(Box.createHorizontalStrut(16));
        toolbar.add(addBtn); toolbar.add(editBtn); toolbar.add(deleteBtn); toolbar.add(refreshBtn);

        add(toolbar, BorderLayout.NORTH);
        add(UIHelper.scrollPane(table), BorderLayout.CENTER);

        searchField.addActionListener(e -> loadItems(searchField.getText().trim()));
        searchBtn.addActionListener(e -> loadItems(searchField.getText().trim()));
        refreshBtn.addActionListener(e -> refresh());
        addBtn.addActionListener(e -> showAddDialog());
        editBtn.addActionListener(e -> showEditDialog());
        deleteBtn.addActionListener(e -> deleteSelected());
    }

    @Override
    public void refresh() {
        loadItems(searchField.getText().trim());
    }

    private void loadItems(String filter) {
        SwingWorker<Void, Void> w = new SwingWorker<>() {
            final java.util.List<Object[]> rows = new java.util.ArrayList<>();

            @Override
            protected Void doInBackground() throws Exception {
                String sql = filter.isEmpty()
                        ? "SELECT fi.id, fi.name, c.name AS cat, fi.price, fi.is_veg, fi.rating, fi.prep_time " +
                          "FROM food_items fi LEFT JOIN categories c ON fi.category_id = c.id ORDER BY fi.id"
                        : "SELECT fi.id, fi.name, c.name AS cat, fi.price, fi.is_veg, fi.rating, fi.prep_time " +
                          "FROM food_items fi LEFT JOIN categories c ON fi.category_id = c.id " +
                          "WHERE fi.name LIKE ? OR c.name LIKE ? ORDER BY fi.id";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    if (!filter.isEmpty()) {
                        ps.setString(1, "%" + filter + "%");
                        ps.setString(2, "%" + filter + "%");
                    }
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            rows.add(new Object[]{
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getString("cat"),
                                String.format("%.2f", rs.getDouble("price")),
                                rs.getBoolean("is_veg") ? "🥦 Veg" : "🍗 Non-Veg",
                                String.format("%.1f", rs.getDouble("rating")),
                                rs.getInt("prep_time")
                            });
                        }
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try { get(); } catch (Exception ex) { JOptionPane.showMessageDialog(FoodItemsPanel.this, ex.getMessage()); return; }
                model.setRowCount(0);
                for (Object[] r : rows) model.addRow(r);
            }
        };
        w.execute();
    }

    private void showAddDialog() {
        JTextField nameF   = UIHelper.darkField(18);
        JTextField priceF  = UIHelper.darkField(10);
        JTextField prepF   = UIHelper.darkField(6);
        JTextField descF   = UIHelper.darkField(18);
        JTextField imgF    = UIHelper.darkField(18);
        JComboBox<String> vegBox = new JComboBox<>(new String[]{"Veg", "Non-Veg"});
        JTextField catIdF  = UIHelper.darkField(6);

        JPanel form = UsersPanel.buildForm(
            new String[]{"Name:", "Price (₹):", "Prep Time (min):", "Category ID:", "Type:", "Description:", "Image URL:"},
            new Component[]{nameF, priceF, prepF, catIdF, vegBox, descF, imgF});

        int result = JOptionPane.showConfirmDialog(this, form, "Add Food Item", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO food_items (name, price, prep_time, category_id, is_veg, description, image_url) VALUES (?,?,?,?,?,?,?)")) {
                ps.setString(1, nameF.getText().trim());
                ps.setDouble(2, Double.parseDouble(priceF.getText().trim()));
                ps.setInt(3, Integer.parseInt(prepF.getText().trim()));
                ps.setInt(4, Integer.parseInt(catIdF.getText().trim()));
                ps.setBoolean(5, vegBox.getSelectedIndex() == 0);
                ps.setString(6, descF.getText().trim());
                ps.setString(7, imgF.getText().trim());
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void showEditDialog() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select an item first."); return; }
        int id = (int) model.getValueAt(row, 0);

        // Load full row from DB
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM food_items WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return;

                JTextField nameF   = UIHelper.darkField(18);
                nameF.setText(rs.getString("name"));
                JTextField priceF  = UIHelper.darkField(10);
                priceF.setText(String.valueOf(rs.getDouble("price")));
                JTextField prepF   = UIHelper.darkField(6);
                prepF.setText(String.valueOf(rs.getInt("prep_time")));
                JComboBox<String> vegBox = new JComboBox<>(new String[]{"Veg", "Non-Veg"});
                vegBox.setSelectedIndex(rs.getBoolean("is_veg") ? 0 : 1);
                JTextField ratingF = UIHelper.darkField(6);
                ratingF.setText(String.valueOf(rs.getDouble("rating")));
                JTextField descF   = UIHelper.darkField(18);
                descF.setText(rs.getString("description"));
                JTextField imgF    = UIHelper.darkField(18);
                imgF.setText(rs.getString("image_url"));

                JPanel form = UsersPanel.buildForm(
                    new String[]{"Name:", "Price (₹):", "Prep Time (min):", "Type:", "Rating:", "Description:", "Image URL:"},
                    new Component[]{nameF, priceF, prepF, vegBox, ratingF, descF, imgF});

                int result = JOptionPane.showConfirmDialog(this, form, "Edit Food Item #" + id,
                        JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE food_items SET name=?, price=?, prep_time=?, is_veg=?, rating=?, description=?, image_url=? WHERE id=?")) {
                        upd.setString(1, nameF.getText().trim());
                        upd.setDouble(2, Double.parseDouble(priceF.getText().trim()));
                        upd.setInt(3, Integer.parseInt(prepF.getText().trim()));
                        upd.setBoolean(4, vegBox.getSelectedIndex() == 0);
                        upd.setDouble(5, Double.parseDouble(ratingF.getText().trim()));
                        upd.setString(6, descF.getText().trim());
                        upd.setString(7, imgF.getText().trim());
                        upd.setInt(8, id);
                        upd.executeUpdate();
                        refresh();
                    }
                }
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    private void deleteSelected() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select an item first."); return; }
        int id   = (int) model.getValueAt(row, 0);
        String name = (String) model.getValueAt(row, 1);

        int confirm = JOptionPane.showConfirmDialog(this,
                "Delete \"" + name + "\" (ID=" + id + ")?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        if (confirm == JOptionPane.YES_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM food_items WHERE id=?")) {
                ps.setInt(1, id);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }
}
