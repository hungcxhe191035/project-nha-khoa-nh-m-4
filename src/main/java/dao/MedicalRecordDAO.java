package dao;

import model.MedicalRecordService;
import model.PrescriptionDetail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class MedicalRecordDAO {

    /**
     * Tạo mới Hồ Sơ Bệnh Án. Trả về ID của Hồ sơ vừa tạo.
     * @param appointmentId 
     * @param diagnosis Chẩn đoán của GS.BS
     * @return inserted ID, hoặc -1 nếu lỗi.
     */
    public int createMedicalRecord(int appointmentId, String diagnosis) {
        String sql = "INSERT INTO MedicalRecords (appointment_id, diagnosis, total_service_amount) VALUES (?, ?, 0)";
        int generatedId = -1;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, appointmentId);
            ps.setString(2, diagnosis);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    /**
     * Thêm mới Dịch Vụ vệ tinh vào Hồ sơ.
     */
    public boolean addServiceToRecord(MedicalRecordService service) {
        String sql = "INSERT INTO MedicalRecord_Services (medical_record_id, service_id, price) VALUES (?, ?, ?)";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, service.getMedicalRecordId());
            ps.setInt(2, service.getServiceId());
            ps.setDouble(3, service.getPrice());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm mới Đơn thuốc vệ tinh vào Hồ sơ.
     */
    public boolean addPrescriptionToRecord(PrescriptionDetail prescription) {
        String sql = "INSERT INTO Prescription_Details (medical_record_id, medicine_id, prescribed_quantity, total_price) VALUES (?, ?, ?, ?)";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, prescription.getMedicalRecordId());
            ps.setInt(2, prescription.getMedicineId());
            ps.setInt(3, prescription.getPrescribedQuantity());
            ps.setDouble(4, prescription.getTotalPrice());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy MedicalRecord theo Appointment ID
     */
    public model.MedicalRecord getMedicalRecordByAppointment(int appointmentId) {
        String sql = "SELECT * FROM MedicalRecords WHERE appointment_id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                model.MedicalRecord mr = new model.MedicalRecord();
                mr.setId(rs.getInt("id"));
                mr.setAppointmentId(rs.getInt("appointment_id"));
                mr.setDiagnosis(rs.getString("diagnosis"));
                mr.setServicePaymentStatus(rs.getString("service_payment_status"));
                mr.setTotalServiceAmount(rs.getDouble("total_service_amount"));
                mr.setCreatedAt(rs.getDate("created_at"));
                return mr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy Danh sách Dịch vụ phát sinh của một MedicalRecord
     */
    public java.util.List<MedicalRecordService> getServicesByRecordId(int recordId) {
        java.util.List<MedicalRecordService> list = new java.util.ArrayList<>();
        String sql = "SELECT ms.*, s.name as service_name, s.category as service_category " +
                     "FROM MedicalRecord_Services ms " +
                     "JOIN Services s ON ms.service_id = s.id " +
                     "WHERE ms.medical_record_id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MedicalRecordService ms = new MedicalRecordService();
                ms.setId(rs.getInt("id"));
                ms.setMedicalRecordId(rs.getInt("medical_record_id"));
                ms.setServiceId(rs.getInt("service_id"));
                ms.setPrice(rs.getDouble("price"));
                ms.setPaymentStatus(rs.getString("payment_status"));
                ms.setServiceName(rs.getString("service_name"));
                ms.setServiceCategory(rs.getString("service_category"));
                list.add(ms);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy Danh sách Đơn thuốc của một MedicalRecord
     */
    public java.util.List<PrescriptionDetail> getPrescriptionsByRecordId(int recordId) {
        java.util.List<PrescriptionDetail> list = new java.util.ArrayList<>();
        String sql = "SELECT pd.*, m.name as medicine_name, m.price as medicine_price, m.unit as medicine_unit " +
                     "FROM Prescription_Details pd " +
                     "JOIN Medicines m ON pd.medicine_id = m.id " +
                     "WHERE pd.medical_record_id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PrescriptionDetail pd = new PrescriptionDetail();
                pd.setId(rs.getInt("id"));
                pd.setMedicalRecordId(rs.getInt("medical_record_id"));
                pd.setMedicineId(rs.getInt("medicine_id"));
                pd.setPrescribedQuantity(rs.getInt("prescribed_quantity"));
                pd.setPurchasedQuantity(rs.getInt("purchased_quantity"));
                pd.setTotalPrice(rs.getDouble("total_price"));
                pd.setPaymentStatus(rs.getString("payment_status"));
                pd.setMedicineName(rs.getString("medicine_name"));
                pd.setMedicinePrice(rs.getDouble("medicine_price"));
                pd.setMedicineUnit(rs.getString("medicine_unit"));
                list.add(pd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Cập nhật trạng thái thanh toán Dịch vụ
     */
    public boolean updateMedicalRecordServicePayment(int recordId) {
        String sql1 = "UPDATE MedicalRecord_Services SET payment_status = 'PAID' WHERE medical_record_id = ?";
        String sql2 = "UPDATE MedicalRecords SET service_payment_status = 'PAID' WHERE id = ?";
        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(sql1);
                 PreparedStatement ps2 = con.prepareStatement(sql2)) {
                
                ps1.setInt(1, recordId);
                ps1.executeUpdate();
                
                ps2.setInt(1, recordId);
                ps2.executeUpdate();
                
                con.commit();
                return true;
            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thanh toán 1 phần đơn thuốc
     */
    public boolean payPrescription(int prescriptionId, int purchasedQty, double newTotalPrice) {
        String sql = "UPDATE Prescription_Details SET purchased_quantity = ?, total_price = ?, payment_status = 'PAID' WHERE id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, purchasedQty);
            ps.setDouble(2, newTotalPrice);
            ps.setInt(3, prescriptionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thanh toán tất cả đơn thuốc chưa thanh toán của 1 record
     */
    public boolean payAllPrescriptions(int recordId) {
        String sql = "UPDATE Prescription_Details SET purchased_quantity = prescribed_quantity, payment_status = 'PAID' WHERE medical_record_id = ? AND payment_status = 'UNPAID'";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, recordId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
