package model;

public class PrescriptionDetail {
    private int id;
    private int medicalRecordId;
    private int medicineId;
    private int prescribedQuantity;
    private int purchasedQuantity;
    private double totalPrice;
    private String paymentStatus;

    // Fields mở rộng để hiển thị bảng Đơn thuốc
    private String medicineName;
    private double medicinePrice;
    private String medicineUnit;

    public PrescriptionDetail() {}

    public PrescriptionDetail(int id, int medicalRecordId, int medicineId, int prescribedQuantity, int purchasedQuantity, double totalPrice, String paymentStatus) {
        this.id = id;
        this.medicalRecordId = medicalRecordId;
        this.medicineId = medicineId;
        this.prescribedQuantity = prescribedQuantity;
        this.purchasedQuantity = purchasedQuantity;
        this.totalPrice = totalPrice;
        this.paymentStatus = paymentStatus;
    }

    // Getters
    public int getId() { return id; }
    public int getMedicalRecordId() { return medicalRecordId; }
    public int getMedicineId() { return medicineId; }
    public int getPrescribedQuantity() { return prescribedQuantity; }
    public int getPurchasedQuantity() { return purchasedQuantity; }
    public double getTotalPrice() { return totalPrice; }
    public String getPaymentStatus() { return paymentStatus; }
    
    // Getters for extend fields
    public String getMedicineName() { return medicineName; }
    public double getMedicinePrice() { return medicinePrice; }
    public String getMedicineUnit() { return medicineUnit; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setMedicalRecordId(int medicalRecordId) { this.medicalRecordId = medicalRecordId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }
    public void setPrescribedQuantity(int prescribedQuantity) { this.prescribedQuantity = prescribedQuantity; }
    public void setPurchasedQuantity(int purchasedQuantity) { this.purchasedQuantity = purchasedQuantity; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    // Setters for extend fields
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }
    public void setMedicinePrice(double medicinePrice) { this.medicinePrice = medicinePrice; }
    public void setMedicineUnit(String medicineUnit) { this.medicineUnit = medicineUnit; }
}
