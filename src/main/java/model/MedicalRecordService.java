package model;

public class MedicalRecordService {
    private int id;
    private int medicalRecordId;
    private int serviceId;
    private double price;
    private String paymentStatus;

    // Các trường mở rộng để phục vụ hiển thị UI
    private String serviceName;
    private String serviceCategory;

    public MedicalRecordService() {}

    public MedicalRecordService(int id, int medicalRecordId, int serviceId, double price, String paymentStatus) {
        this.id = id;
        this.medicalRecordId = medicalRecordId;
        this.serviceId = serviceId;
        this.price = price;
        this.paymentStatus = paymentStatus;
    }

    // Getters
    public int getId() { return id; }
    public int getMedicalRecordId() { return medicalRecordId; }
    public int getServiceId() { return serviceId; }
    public double getPrice() { return price; }
    public String getPaymentStatus() { return paymentStatus; }

    public String getServiceName() { return serviceName; }
    public String getServiceCategory() { return serviceCategory; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setMedicalRecordId(int medicalRecordId) { this.medicalRecordId = medicalRecordId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public void setPrice(double price) { this.price = price; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public void setServiceCategory(String serviceCategory) { this.serviceCategory = serviceCategory; }
}
