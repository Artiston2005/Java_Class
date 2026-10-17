package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

/**
 * Vouchers panel — full CRUD for the vouchers table.
 */
public class VouchersPanel extends JPanel implements Refreshable {

    private final DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Code", "Discount (%)"}, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };
    private final JTable table = new JTable(model);

    public VouchersPanel() {
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

        JButton addBtn     = UIHelper.actionButton("➕ Add Voucher",  UIHelper.SUCCESS);
        JButton editBtn    = UIHelper.actionButton("✏ Edit",         UIHelper.ACCENT);
        JButton deleteBtn  = UIHelper.actionButton("🗑 Delete",       UIHelper.DANGER);
        JButton refreshBtn = UIHelper.actionButton("⟳ Refresh",      UIHelper.BG_PANEL);

        toolbar.add(addBtn); toolbar.add(editBtn); toolbar.add(deleteBtn); toolbar.add(refreshBtn);

        add(toolbar, BorderLayout.NORTH);
        add(UIHelper.scrollPane(table), BorderLayout.CENTER);

        refreshBtn.addActionListener(e -> refresh());
        addBtn.addActionListener(e -> showAddDialog());
        editBtn.addActionListener(e -> showEditDialog());
        deleteBtn.addActionListener(e -> deleteSelected());
    }

    @Override
    public void refresh() {
        SwingWorker<Void, Void> w = new SwingWorker<>() {
            final java.util.List<Object[]> rows = new java.util.ArrayList<>();

            @Override
            protected Void doInBackground() throws Exception {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                             "SELECT id, code, discount_percent FROM vouchers ORDER BY id");
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        rows.add(new Object[]{
                            rs.getInt("id"),
                            rs.getString("code"),
                            String.format("%.2f%%", rs.getDouble("discount_percent"))
                        });
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try { get(); } catch (Exception ex) { JOptionPane.showMessageDialog(VouchersPanel.this, ex.getMessage()); return; }
                model.setRowCount(0);
                for (Object[] r : rows) model.addRow(r);
            }
        };
        w.execute();
    }

    private void showAddDialog() {
        JTextField codeF     = UIHelper.darkField(16);
        JTextField discountF = UIHelper.darkField(8);

        JPanel form = UsersPanel.buildForm(
            new String[]{"Code:", "Discount (%):"},
            new Component[]{codeF, discountF});

        int result = JOptionPane.showConfirmDialog(this, form, "Add Voucher", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO vouchers (code, discount_percent) VALUES (?,?)")) {
                ps.setString(1, codeF.getText().trim().toUpperCase());
                ps.setDouble(2, Double.parseDouble(discountF.getText().trim()));
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void showEditDialog() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a voucher first."); return; }
        int id = (int) model.getValueAt(row, 0);
        String currentDiscount = ((String) model.getValueAt(row, 2)).replace("%", "").trim();

        JTextField codeF     = UIHelper.darkField(16);
        codeF.setText((String) model.getValueAt(row, 1));
        JTextField discountF = UIHelper.darkField(8);
        discountF.setText(currentDiscount);

        JPanel form = UsersPanel.buildForm(
            new String[]{"Code:", "Discount (%):"},
            new Component[]{codeF, discountF});

        int result = JOptionPane.showConfirmDialog(this, form, "Edit Voucher #" + id, JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE vouchers SET code=?, discount_percent=? WHERE id=?")) {
                ps.setString(1, codeF.getText().trim().toUpperCase());
                ps.setDouble(2, Double.parseDouble(discountF.getText().trim()));
                ps.setInt(3, id);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void deleteSelected() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a voucher first."); return; }
        int id   = (int) model.getValueAt(row, 0);
        String code = (String) model.getValueAt(row, 1);

        int confirm = JOptionPane.showConfirmDialog(this,
                "Delete voucher \"" + code + "\"?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        if (confirm == JOptionPane.YES_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM vouchers WHERE id=?")) {
                ps.setInt(1, id);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }
}
