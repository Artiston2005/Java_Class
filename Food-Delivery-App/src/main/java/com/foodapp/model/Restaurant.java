package com.foodapp.model;

public class Restaurant {
    private int id;
    private String name;
    private String logoUrl;
    private double rating;
    private int deliveryTime;
    private String cuisineType;
    private int minOrder;
    private int freeDeliveryAbove;
    private boolean open;
    private String offerText;

    public Restaurant() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(int deliveryTime) { this.deliveryTime = deliveryTime; }

    public String getCuisineType() { return cuisineType; }
    public void setCuisineType(String cuisineType) { this.cuisineType = cuisineType; }

    public int getMinOrder() { return minOrder; }
    public void setMinOrder(int minOrder) { this.minOrder = minOrder; }

    public int getFreeDeliveryAbove() { return freeDeliveryAbove; }
    public void setFreeDeliveryAbove(int freeDeliveryAbove) { this.freeDeliveryAbove = freeDeliveryAbove; }

    public boolean isOpen() { return open; }
    public void setOpen(boolean open) { this.open = open; }

    public String getOfferText() { return offerText; }
    public void setOfferText(String offerText) { this.offerText = offerText; }
}
