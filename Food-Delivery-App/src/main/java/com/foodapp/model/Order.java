package com.foodapp.model;

import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private Date orderDate;
    private double totalAmount;
    private String status;
    private String paymentMethod;
    private String riderName;
    private String riderPhone;
    private List<OrderItem> items;

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getRiderName() { return riderName; }
    public void setRiderName(String riderName) { this.riderName = riderName; }

    public String getRiderPhone() { return riderPhone; }
    public void setRiderPhone(String riderPhone) { this.riderPhone = riderPhone; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
        private int riderId;
    public int getRiderId() { return riderId; }
    public void setRiderId(int riderId) { this.riderId = riderId; }
    private int rating;
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }




    // ── Price breakdown fields ───────────────────────────────────────
    private double itemSubtotal;
    private double discountAmount;
    private double deliveryFee   = 45.0;
    private double platformFee   = 5.0;
    private double aiFee         = 10.0;
    private double humourTax     = 15.0;
    private double gstAmount;

    public double getItemSubtotal()  { return itemSubtotal; }
    public void setItemSubtotal(double v) { this.itemSubtotal = v; }
    public double getDiscountAmount()  { return discountAmount; }
    public void setDiscountAmount(double v) { this.discountAmount = v; }
    public double getDeliveryFee()     { return deliveryFee; }
    public void setDeliveryFee(double v) { this.deliveryFee = v; }
    public double getPlatformFee()     { return platformFee; }
    public void setPlatformFee(double v) { this.platformFee = v; }
    public double getAiFee()           { return aiFee; }
    public void setAiFee(double v) { this.aiFee = v; }
    public double getHumourTax()       { return humourTax; }
    public void setHumourTax(double v) { this.humourTax = v; }
    public double getGstAmount()       { return gstAmount; }
    public void setGstAmount(double v) { this.gstAmount = v; }

}