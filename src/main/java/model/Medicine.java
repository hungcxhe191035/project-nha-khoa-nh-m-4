package model;

import java.sql.Timestamp;

public class Medicine {
    private int id;
    private String name;
    private String unit;
    private double price;
    private int stockQuantity;
    private Timestamp createdAt;

    public Medicine() {}

    public Medicine(int id, String name, String unit, double price, int stockQuantity) {
        this.id = id;
        this.name = name;
        this.unit = unit;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    // Getters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
