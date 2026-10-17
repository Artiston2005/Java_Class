package com.foodapp.dao;

import com.foodapp.model.Address;
import com.foodapp.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public List<Address> getAddressesByUserId(int userId) {
        List<Address> addresses = new ArrayList<>();
        String query = "SELECT * FROM user_addresses WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Address a = new Address();
                    a.setId(rs.getInt("id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setLabel(rs.getString("label"));
                    a.setAddressText(rs.getString("address_text"));
                    a.setLatitude(rs.getDouble("latitude"));
                    a.setLongitude(rs.getDouble("longitude"));
                    addresses.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addresses;
    }

    public boolean addAddress(Address address) {
        String query = "INSERT INTO user_addresses (user_id, label, address_text, latitude, longitude) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, address.getUserId());
            stmt.setString(2, address.getLabel());
            stmt.setString(3, address.getAddressText());
            stmt.setDouble(4, address.getLatitude());
            stmt.setDouble(5, address.getLongitude());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
