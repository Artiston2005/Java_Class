package com.foodapp.model;

public class OrderItem {
    private int id;
    private int orderId;
    private int foodItemId;
    private String foodItemName; // For UI display convenience
    private int quantity;
    private double price;

    public OrderItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getFoodItemId() { return foodItemId; }
    public void setFoodItemId(int foodItemId) { this.foodItemId = foodItemId; }

    public String getFoodItemName() { return foodItemName; }
    public void setFoodItemName(String foodItemName) { this.foodItemName = foodItemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
