package com.foodapp.admin.panels;

import com.foodapp.admin.Refreshable;
import com.foodapp.admin.UIHelper;
import com.foodapp.util.DBConnection;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.sql.*;

/**
 * SQL Console panel — run arbitrary SQL queries and see results in a table.
 * Includes a history list and query shortcuts.
 */
public class SqlConsolePanel extends JPanel implements Refreshable {

    private final JTextArea queryArea = new JTextArea(6, 60);
    private final JLabel statusLabel  = new JLabel("Ready.");
    private final DefaultTableModel resultModel = new DefaultTableModel();
    private final JTable resultTable = new JTable(resultModel);
    private final DefaultListModel<String> historyModel = new DefaultListModel<>();
    private final JList<String> historyList = new JList<>(historyModel);

    // Quick-select shortcuts
    private static final String[] SHORTCUTS = {
        "SELECT * FROM users ORDER BY id LIMIT 50",
        "SELECT * FROM orders ORDER BY order_date DESC LIMIT 50",
        "SELECT * FROM food_items ORDER BY id LIMIT 50",
        "SELECT * FROM restaurants ORDER BY id",
        "SELECT * FROM vouchers ORDER BY id",
        "SELECT * FROM categories ORDER BY id",
        "SELECT * FROM order_items LIMIT 50",
        "SELECT COUNT(*), status FROM orders GROUP BY status",
        "SELECT u.username, COUNT(o.id) AS total_orders, SUM(o.total_amount) AS total_spent FROM orders o JOIN users u ON o.user_id = u.id GROUP BY u.id ORDER BY total_spent DESC LIMIT 20",
    };

    public SqlConsolePanel() {
        setLayout(new BorderLayout(8, 8));
        setBackground(UIHelper.BG_DARK);
        setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        buildUI();
    }

    private void buildUI() {
        // ── Query editor area ────────────────────────────────────────────
        queryArea.setFont(new Font("JetBrains Mono", Font.PLAIN, 13));
        queryArea.setBackground(new Color(25, 25, 40));
        queryArea.setForeground(new Color(180, 230, 180));
        queryArea.setCaretColor(UIHelper.ACCENT);
        queryArea.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        queryArea.setText(SHORTCUTS[0]);
        queryArea.setLineWrap(true);
        queryArea.setWrapStyleWord(true);

        // Ctrl+Enter runs the query
        queryArea.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, KeyEvent.CTRL_DOWN_MASK), "run");
        queryArea.getActionMap().put("run", new AbstractAction() {
            @Override public void actionPerformed(java.awt.event.ActionEvent e) { runQuery(); }
        });

        JScrollPane editorScroll = UIHelper.scrollPane(queryArea);
        editorScroll.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(UIHelper.ACCENT, 1),
                "SQL Query  (Ctrl+Enter to run)",
                0, 0,
                new Font("Segoe UI", Font.BOLD, 12), UIHelper.ACCENT));

        // ── Toolbar ─────────────────────────────────────────────────────
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 0));
        toolbar.setBackground(UIHelper.BG_DARK);

        JButton runBtn   = UIHelper.actionButton("▶ Run", UIHelper.SUCCESS);
        JButton clearBtn = UIHelper.actionButton("Clear", UIHelper.BG_PANEL);
        JButton exportBtn = UIHelper.actionButton("📋 Copy CSV", UIHelper.INFO);

        // Shortcut picker
        JComboBox<String> shortcutBox = new JComboBox<>(SHORTCUTS);
        shortcutBox.setBackground(UIHelper.BG_PANEL);
        shortcutBox.setForeground(UIHelper.TEXT_PRIMARY);
        shortcutBox.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        shortcutBox.setMaximumSize(new Dimension(300, 28));

        JLabel shortcutLbl = new JLabel("Shortcuts:");
        shortcutLbl.setForeground(UIHelper.TEXT_MUTED);

        toolbar.add(runBtn); toolbar.add(clearBtn); toolbar.add(exportBtn);
        toolbar.add(Box.createHorizontalStrut(16));
        toolbar.add(shortcutLbl); toolbar.add(shortcutBox);

        // ── Result table ─────────────────────────────────────────────────
        UIHelper.styleTable(resultTable);
        JScrollPane resultScroll = UIHelper.scrollPane(resultTable);

        // ── History list ─────────────────────────────────────────────────
        historyList.setBackground(UIHelper.BG_TABLE);
        historyList.setForeground(UIHelper.TEXT_MUTED);
        historyList.setFont(new Font("Monospaced", Font.PLAIN, 11));
        historyList.setSelectionBackground(new Color(249, 115, 22, 120));
        historyList.setSelectionForeground(Color.WHITE);

        JScrollPane historyScroll = UIHelper.scrollPane(historyList);
        historyScroll.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(UIHelper.TEXT_MUTED, 1),
                "History",
                0, 0,
                new Font("Segoe UI", Font.BOLD, 11), UIHelper.TEXT_MUTED));
        historyScroll.setPreferredSize(new Dimension(280, 0));

        // ── Status bar ────────────────────────────────────────────────────
        statusLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        statusLabel.setForeground(UIHelper.TEXT_MUTED);
        statusLabel.setBorder(BorderFactory.createEmptyBorder(2, 4, 2, 4));

        // ── Layout ────────────────────────────────────────────────────────
        JPanel centerPanel = new JPanel(new BorderLayout(8, 8));
        centerPanel.setBackground(UIHelper.BG_DARK);
        centerPanel.add(editorScroll, BorderLayout.NORTH);
        centerPanel.add(resultScroll, BorderLayout.CENTER);
        centerPanel.add(statusLabel,  BorderLayout.SOUTH);

        JSplitPane split = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, centerPanel, historyScroll);
        split.setResizeWeight(0.8);
        split.setDividerSize(6);
        split.setBackground(UIHelper.BG_DARK);

        add(toolbar, BorderLayout.NORTH);
        add(split,   BorderLayout.CENTER);

        // Actions
        runBtn.addActionListener(e -> runQuery());
        clearBtn.addActionListener(e -> { queryArea.setText(""); resultModel.setRowCount(0); resultModel.setColumnCount(0); statusLabel.setText("Cleared."); });
        exportBtn.addActionListener(e -> copyCSV());
        shortcutBox.addActionListener(e -> queryArea.setText((String) shortcutBox.getSelectedItem()));
        historyList.addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && historyList.getSelectedValue() != null)
                queryArea.setText(historyList.getSelectedValue());
        });
    }

    private void runQuery() {
        String sql = queryArea.getText().trim();
        if (sql.isEmpty()) return;

        statusLabel.setText("Running…");
        statusLabel.setForeground(UIHelper.WARNING);

        SwingWorker<Void, Void> w = new SwingWorker<>() {
            String[] cols;
            java.util.List<Object[]> rows = new java.util.ArrayList<>();
            int updateCount = -1;
            String error = null;

            @Override
            protected Void doInBackground() {
                try (Connection conn = DBConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    boolean isResultSet = stmt.execute(sql);
                    if (isResultSet) {
                        try (ResultSet rs = stmt.getResultSet()) {
                            ResultSetMetaData meta = rs.getMetaData();
                            int colCount = meta.getColumnCount();
                            cols = new String[colCount];
                            for (int i = 1; i <= colCount; i++) cols[i - 1] = meta.getColumnLabel(i);
                            while (rs.next()) {
                                Object[] row = new Object[colCount];
                                for (int i = 1; i <= colCount; i++) row[i - 1] = rs.getObject(i);
                                rows.add(row);
                            }
                        }
                    } else {
                        updateCount = stmt.getUpdateCount();
                    }
                } catch (Exception ex) {
                    error = ex.getMessage();
                }
                return null;
            }

            @Override
            protected void done() {
                // Add to history (deduplicated, max 50)
                historyModel.removeElement(sql);
                historyModel.add(0, sql);
                if (historyModel.size() > 50) historyModel.remove(historyModel.size() - 1);

                if (error != null) {
                    statusLabel.setText("Error: " + error);
                    statusLabel.setForeground(UIHelper.DANGER);
                    resultModel.setRowCount(0);
                    resultModel.setColumnCount(0);
                    return;
                }

                resultModel.setRowCount(0);
                if (cols != null) {
                    resultModel.setColumnIdentifiers(cols);
                    for (Object[] r : rows) resultModel.addRow(r);
                    statusLabel.setText("✅  " + rows.size() + " row(s) returned.");
                } else {
                    resultModel.setColumnCount(0);
                    statusLabel.setText("✅  " + updateCount + " row(s) affected.");
                }
                statusLabel.setForeground(UIHelper.SUCCESS);
            }
        };
        w.execute();
    }

    private void copyCSV() {
        if (resultModel.getColumnCount() == 0) return;
        StringBuilder sb = new StringBuilder();
        for (int c = 0; c < resultModel.getColumnCount(); c++) {
            if (c > 0) sb.append(',');
            sb.append(resultModel.getColumnName(c));
        }
        sb.append('\n');
        for (int r = 0; r < resultModel.getRowCount(); r++) {
            for (int c = 0; c < resultModel.getColumnCount(); c++) {
                if (c > 0) sb.append(',');
                Object v = resultModel.getValueAt(r, c);
                sb.append(v == null ? "" : v.toString().replace(",", ";"));
            }
            sb.append('\n');
        }
        java.awt.datatransfer.StringSelection sel = new java.awt.datatransfer.StringSelection(sb.toString());
        java.awt.Toolkit.getDefaultToolkit().getSystemClipboard().setContents(sel, null);
        statusLabel.setText("CSV copied to clipboard (" + resultModel.getRowCount() + " rows).");
        statusLabel.setForeground(UIHelper.SUCCESS);
    }

    @Override
    public void refresh() { /* SQL Console doesn't auto-refresh */ }
}
