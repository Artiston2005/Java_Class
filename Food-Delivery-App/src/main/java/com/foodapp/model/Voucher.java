package com.foodapp.model;
import java.util.Date;
public class Voucher {
    private String code;
    private double discountPercent;
    private double minOrderAmount;
    private double maxDiscountCap;
    private Date expiryDate;

    public Voucher() {}

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public double getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(double minOrderAmount) { this.minOrderAmount = minOrderAmount; }

    public double getMaxDiscountCap() { return maxDiscountCap; }
    public void setMaxDiscountCap(double maxDiscountCap) { this.maxDiscountCap = maxDiscountCap; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    
    public boolean isValidForAmount(double amount) {
        return amount >= minOrderAmount;
    }
}