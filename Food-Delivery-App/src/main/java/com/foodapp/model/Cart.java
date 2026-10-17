package com.foodapp.model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items;
    private int restaurantId;
    
    public Cart(int restaurantId) {
        this.items = new ArrayList<>();
        this.restaurantId = restaurantId;
    }
    
    public int getRestaurantId() { return restaurantId; }

    public List<CartItem> getItems() {
        return items;
    }

    public void addItem(FoodItem foodItem) {
        addItem(foodItem, 1);
    }

    public void addItem(FoodItem foodItem, int quantity) {
        for (CartItem item : items) {
            if (item.getFoodItem().getId() == foodItem.getId()) {
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        items.add(new CartItem(foodItem, quantity));
    }

    public void removeItem(int foodItemId) {
        items.removeIf(item -> item.getFoodItem().getId() == foodItemId);
    }

    public void updateItemQuantity(int foodItemId, int quantity) {
        if (quantity <= 0) {
            removeItem(foodItemId);
            return;
        }
        for (CartItem item : items) {
            if (item.getFoodItem().getId() == foodItemId) {
                item.setQuantity(quantity);
                return;
            }
        }
    }
    
    public void clear() {
        items.clear();
    }

    private double discountPercent = 0.0;
    private double maxDiscountCap = 9999.0;
    private String appliedVoucher = null;

    public void applyVoucher(String code, double percent, double maxCap) {
        this.appliedVoucher = code;
        this.discountPercent = percent;
        this.maxDiscountCap = maxCap > 0 ? maxCap : 9999.0;
    }

    public void removeVoucher() {
        this.appliedVoucher = null;
        this.discountPercent = 0.0;
        this.maxDiscountCap = 9999.0;
    }

    public String getAppliedVoucher() { return appliedVoucher; }
    public double getDiscountPercent() { return discountPercent; }

    public double getSubTotal() {
        double total = 0;
        for (CartItem item : items) {
            total += item.getSubTotal();
        }
        return total;
    }

    public double getDiscountAmount() {
        double rawDiscount = (getSubTotal() * discountPercent) / 100.0;
        return Math.min(rawDiscount, maxDiscountCap);
    }

    public double getTotalAmount() {
        return getSubTotal() - getDiscountAmount();
    }
}