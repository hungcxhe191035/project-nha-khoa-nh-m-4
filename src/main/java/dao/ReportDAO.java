package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class ReportDAO {

    /**
     * Lấy tổng quan Dashboard Doanh Thu
     * Trả về Map chứa: total_revenue, today_revenue, total_patients, total_completed_appointments
     */
    public Map<String, Object> getDashboardSummary() {
        Map<String, Object> summary = new HashMap<>();
        
        // 1. Tổng bệnh nhân (Role = PATIENT)
        summary.put("total_patients", countRecords("SELECT COUNT(id) FROM Users WHERE role = 'PATIENT'"));
        
        // 2. Tổng lịch khám đã hoàn thành (COMPLETED)
        summary.put("total_completed_appointments", countRecords("SELECT COUNT(id) FROM Appointments WHERE status = 'COMPLETED'"));
        
        // 3. Tổng tất cả Doanh thu (Dịch vụ + Thuốc đã thanh toán)
        double totalServiceRev = sumRevenue("SELECT SUM(price) FROM MedicalRecord_Services WHERE payment_status = 'PAID'");
        double totalMedicineRev = sumRevenue("SELECT SUM(total_price) FROM Prescription_Details WHERE payment_status = 'PAID'");
        summary.put("total_revenue", totalServiceRev + totalMedicineRev);
        
        // 4. Doanh thu riêng ngày hôm nay
        String todayServiceSql = "SELECT SUM(ms.price) FROM MedicalRecord_Services ms JOIN MedicalRecords mr ON ms.medical_record_id = mr.id WHERE ms.payment_status = 'PAID' AND CAST(mr.created_at AS DATE) = CAST(GETDATE() AS DATE)";
        String todayMedicineSql = "SELECT SUM(pd.total_price) FROM Prescription_Details pd JOIN MedicalRecords mr ON pd.medical_record_id = mr.id WHERE pd.payment_status = 'PAID' AND CAST(mr.created_at AS DATE) = CAST(GETDATE() AS DATE)";
        double todayServiceRev = sumRevenue(todayServiceSql);
        double todayMedicineRev = sumRevenue(todayMedicineSql);
        summary.put("today_revenue", todayServiceRev + todayMedicineRev);

        return summary;
    }

    // --- HELPER METHODS --- //

    private int countRecords(String sql) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private double sumRevenue(String sql) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
