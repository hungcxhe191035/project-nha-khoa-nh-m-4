package model;
import java.util.Date;

public class MedicalRecord {
    private int id;
    private int appointmentId;
    private String diagnosis;
    private String servicePaymentStatus;
    private double totalServiceAmount;
    private Date createdAt;

    // Constructors
    public MedicalRecord() {}

    public MedicalRecord(int id, int appointmentId, String diagnosis, String servicePaymentStatus, double totalServiceAmount, Date createdAt) {
        this.id = id;
        this.appointmentId = appointmentId;
        this.diagnosis = diagnosis;
        this.servicePaymentStatus = servicePaymentStatus;
        this.totalServiceAmount = totalServiceAmount;
        this.createdAt = createdAt;
    }

    // Getters
    public int getId() { return id; }
    public int getAppointmentId() { return appointmentId; }
    public String getDiagnosis() { return diagnosis; }
    public String getServicePaymentStatus() { return servicePaymentStatus; }
    public double getTotalServiceAmount() { return totalServiceAmount; }
    public Date getCreatedAt() { return createdAt; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    public void setServicePaymentStatus(String servicePaymentStatus) { this.servicePaymentStatus = servicePaymentStatus; }
    public void setTotalServiceAmount(double totalServiceAmount) { this.totalServiceAmount = totalServiceAmount; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
