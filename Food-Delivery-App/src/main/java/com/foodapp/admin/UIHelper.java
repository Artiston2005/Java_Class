package com.foodapp.admin;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.JTableHeader;
import java.awt.*;

/**
 * Shared UI helpers and constants used across all admin panels.
 */
public final class UIHelper {

    // Colour palette
    public static final Color BG_DARK      = new Color(30, 30, 46);
    public static final Color BG_PANEL     = new Color(40, 40, 58);
    public static final Color BG_TABLE     = new Color(35, 35, 50);
    public static final Color ACCENT       = new Color(249, 115, 22);
    public static final Color ACCENT_LIGHT = new Color(251, 146, 60);
    public static final Color TEXT_PRIMARY  = new Color(220, 220, 235);
    public static final Color TEXT_MUTED   = new Color(150, 150, 170);
    public static final Color SUCCESS      = new Color(34, 197, 94);
    public static final Color WARNING      = new Color(234, 179, 8);
    public static final Color DANGER       = new Color(239, 68, 68);
    public static final Color INFO         = new Color(56, 189, 248);

    private UIHelper() {}

    /** Style a JTable with the app's dark theme. */
    public static void styleTable(JTable table) {
        table.setBackground(BG_TABLE);
        table.setForeground(TEXT_PRIMARY);
        table.setGridColor(new Color(60, 60, 80));
        table.setRowHeight(28);
        table.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        table.setSelectionBackground(new Color(249, 115, 22, 180));
        table.setSelectionForeground(Color.WHITE);
        table.setFillsViewportHeight(true);
        table.setShowHorizontalLines(true);
        table.setShowVerticalLines(false);

        JTableHeader header = table.getTableHeader();
        header.setBackground(new Color(20, 20, 35));
        header.setForeground(ACCENT);
        header.setFont(new Font("Segoe UI", Font.BOLD, 13));
        header.setReorderingAllowed(false);

        // Alternate row colours
        table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
            @Override
            public Component getTableCellRendererComponent(JTable t, Object value,
                    boolean isSelected, boolean hasFocus, int row, int col) {
                super.getTableCellRendererComponent(t, value, isSelected, hasFocus, row, col);
                setFont(new Font("Segoe UI", Font.PLAIN, 13));
                if (isSelected) {
                    setBackground(new Color(249, 115, 22, 180));
                    setForeground(Color.WHITE);
                } else {
                    setBackground(row % 2 == 0 ? BG_TABLE : new Color(42, 42, 60));
                    setForeground(TEXT_PRIMARY);
                }
                setBorder(BorderFactory.createEmptyBorder(0, 6, 0, 6));
                return this;
            }
        });
    }

    /** Create a styled action button. */
    public static JButton actionButton(String text, Color bg) {
        JButton btn = new JButton(text);
        btn.setBackground(bg);
        btn.setForeground(Color.WHITE);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        btn.setBorder(BorderFactory.createEmptyBorder(6, 14, 6, 14));
        return btn;
    }

    /** Create a stat card (label + value). */
    public static JPanel statCard(String label, String value, Color accent) {
        JPanel card = new JPanel(new BorderLayout(4, 4));
        card.setBackground(BG_PANEL);
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(accent, 2, true),
                BorderFactory.createEmptyBorder(12, 16, 12, 16)));

        JLabel lblLabel = new JLabel(label);
        lblLabel.setForeground(TEXT_MUTED);
        lblLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));

        JLabel lblValue = new JLabel(value);
        lblValue.setForeground(accent);
        lblValue.setFont(new Font("Segoe UI", Font.BOLD, 26));

        card.add(lblLabel, BorderLayout.NORTH);
        card.add(lblValue, BorderLayout.CENTER);
        return card;
    }

    /** Create a styled scroll pane. */
    public static JScrollPane scrollPane(Component view) {
        JScrollPane sp = new JScrollPane(view);
        sp.getViewport().setBackground(BG_TABLE);
        sp.setBorder(BorderFactory.createLineBorder(new Color(60, 60, 80)));
        return sp;
    }

    /** Create a dark-themed text field. */
    public static JTextField darkField(int cols) {
        JTextField f = new JTextField(cols);
        f.setBackground(new Color(50, 50, 68));
        f.setForeground(TEXT_PRIMARY);
        f.setCaretColor(ACCENT);
        f.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        f.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(80, 80, 100)),
                BorderFactory.createEmptyBorder(4, 8, 4, 8)));
        return f;
    }

    /** Status colour based on order status string. */
    public static Color statusColor(String status) {
        if (status == null) return TEXT_MUTED;
        switch (status.toUpperCase()) {
            case "PENDING":         return WARNING;
            case "CONFIRMED":       return INFO;
            case "PREPARING":       return new Color(168, 85, 247);
            case "OUT_FOR_DELIVERY":return ACCENT_LIGHT;
            case "DELIVERED":       return SUCCESS;
            case "REJECTED":        return DANGER;
            default:                return TEXT_MUTED;
        }
    }
}
