package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

/**
 * Users panel — full CRUD for the users table.
 */
public class UsersPanel extends JPanel implements Refreshable {

    private final DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Username", "Role", "Address"}, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };
    private final JTable table = new JTable(model);
    private final JTextField searchField = UIHelper.darkField(20);

    public UsersPanel() {
        setLayout(new BorderLayout(8, 8));
        setBackground(UIHelper.BG_DARK);
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        buildUI();
        refresh();
    }

    private void buildUI() {
        UIHelper.styleTable(table);

        // Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 0));
        toolbar.setBackground(UIHelper.BG_DARK);

        JLabel searchLbl = new JLabel("Search:");
        searchLbl.setForeground(UIHelper.TEXT_MUTED);

        JButton searchBtn  = UIHelper.actionButton("🔍 Search", UIHelper.INFO);
        JButton addBtn     = UIHelper.actionButton("➕ Add User", UIHelper.SUCCESS);
        JButton editBtn    = UIHelper.actionButton("✏ Edit", UIHelper.ACCENT);
        JButton deleteBtn  = UIHelper.actionButton("🗑 Delete", UIHelper.DANGER);
        JButton refreshBtn = UIHelper.actionButton("⟳ Refresh", UIHelper.BG_PANEL);

        toolbar.add(searchLbl);
        toolbar.add(searchField);
        toolbar.add(searchBtn);
        toolbar.add(Box.createHorizontalStrut(16));
        toolbar.add(addBtn);
        toolbar.add(editBtn);
        toolbar.add(deleteBtn);
        toolbar.add(refreshBtn);

        add(toolbar, BorderLayout.NORTH);
        add(UIHelper.scrollPane(table), BorderLayout.CENTER);

        // Actions
        searchField.addActionListener(e -> loadUsers(searchField.getText().trim()));
        searchBtn.addActionListener(e -> loadUsers(searchField.getText().trim()));
        refreshBtn.addActionListener(e -> refresh());
        addBtn.addActionListener(e -> showAddDialog());
        editBtn.addActionListener(e -> showEditDialog());
        deleteBtn.addActionListener(e -> deleteSelected());
    }

    @Override
    public void refresh() {
        loadUsers(searchField.getText().trim());
    }

    private void loadUsers(String filter) {
        SwingWorker<Void, Void> w = new SwingWorker<>() {
            final Object[][] rows = new Object[500][];
            int count = 0;

            @Override
            protected Void doInBackground() throws Exception {
                String sql = filter.isEmpty()
                        ? "SELECT id, username, role, address FROM users ORDER BY id"
                        : "SELECT id, username, role, address FROM users WHERE username LIKE ? OR role LIKE ? ORDER BY id";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    if (!filter.isEmpty()) {
                        ps.setString(1, "%" + filter + "%");
                        ps.setString(2, "%" + filter + "%");
                    }
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next() && count < 500) {
                            rows[count++] = new Object[]{
                                rs.getInt("id"),
                                rs.getString("username"),
                                rs.getString("role"),
                                rs.getString("address")
                            };
                        }
                    }
                }
                return null;
            }

            @Override
            protected void done() {
                try { get(); } catch (Exception ex) { JOptionPane.showMessageDialog(UsersPanel.this, ex.getMessage()); return; }
                model.setRowCount(0);
                for (int i = 0; i < count; i++) model.addRow(rows[i]);
            }
        };
        w.execute();
    }

    private void showAddDialog() {
        JTextField uField = UIHelper.darkField(18);
        JTextField pField = UIHelper.darkField(18);
        JComboBox<String> roleBox = new JComboBox<>(new String[]{"CUSTOMER", "ADMIN", "RIDER", "RESTAURANT_ADMIN"});
        JTextField aField = UIHelper.darkField(18);

        JPanel form = buildForm(
            new String[]{"Username:", "Password:", "Role:", "Address:"},
            new Component[]{uField, pField, roleBox, aField});

        int result = JOptionPane.showConfirmDialog(this, form, "Add User", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO users (username, password, role, address) VALUES (?,?,?,?)")) {
                ps.setString(1, uField.getText().trim());
                ps.setString(2, pField.getText().trim());
                ps.setString(3, (String) roleBox.getSelectedItem());
                ps.setString(4, aField.getText().trim());
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void showEditDialog() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a user first."); return; }

        int id       = (int) model.getValueAt(row, 0);
        JTextField uField = UIHelper.darkField(18);
        uField.setText((String) model.getValueAt(row, 1));
        JComboBox<String> roleBox = new JComboBox<>(new String[]{"CUSTOMER", "ADMIN", "RIDER", "RESTAURANT_ADMIN"});
        roleBox.setSelectedItem(model.getValueAt(row, 2));
        JTextField aField = UIHelper.darkField(18);
        aField.setText((String) model.getValueAt(row, 3));

        JPanel form = buildForm(
            new String[]{"Username:", "Role:", "Address:"},
            new Component[]{uField, roleBox, aField});

        int result = JOptionPane.showConfirmDialog(this, form, "Edit User", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE users SET username=?, role=?, address=? WHERE id=?")) {
                ps.setString(1, uField.getText().trim());
                ps.setString(2, (String) roleBox.getSelectedItem());
                ps.setString(3, aField.getText().trim());
                ps.setInt(4, id);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void deleteSelected() {
        int row = table.getSelectedRow();
        if (row < 0) { JOptionPane.showMessageDialog(this, "Select a user first."); return; }
        int id = (int) model.getValueAt(row, 0);
        String username = (String) model.getValueAt(row, 1);

        int confirm = JOptionPane.showConfirmDialog(this,
                "Delete user \"" + username + "\" (ID=" + id + ")?",
                "Confirm Delete", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        if (confirm == JOptionPane.YES_OPTION) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id=?")) {
                ps.setInt(1, id);
                ps.executeUpdate();
                refresh();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    static JPanel buildForm(String[] labels, Component[] fields) {
        JPanel p = new JPanel(new GridBagLayout());
        p.setBackground(UIHelper.BG_PANEL);
        p.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;
        for (int i = 0; i < labels.length; i++) {
            gbc.gridx = 0; gbc.gridy = i; gbc.weightx = 0;
            JLabel lbl = new JLabel(labels[i]);
            lbl.setForeground(UIHelper.TEXT_PRIMARY);
            p.add(lbl, gbc);
            gbc.gridx = 1; gbc.weightx = 1;
            p.add(fields[i], gbc);
        }
        return p;
    }
}
