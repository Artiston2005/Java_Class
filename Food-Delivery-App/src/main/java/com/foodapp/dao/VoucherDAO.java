package com.foodapp.dao;

import com.foodapp.model.Voucher;
import com.foodapp.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VoucherDAO {
    
    public Voucher getVoucher(String code) {
        Voucher voucher = null;
        String query = "SELECT * FROM vouchers WHERE code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    voucher = new Voucher();
                    voucher.setCode(rs.getString("code"));
                    voucher.setDiscountPercent(rs.getDouble("discount_percent"));
                    voucher.setMinOrderAmount(rs.getDouble("min_order_amount"));
                    voucher.setMaxDiscountCap(rs.getDouble("max_discount_cap"));
                    voucher.setExpiryDate(rs.getDate("expiry_date"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return voucher;
    }
}
