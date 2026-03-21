package dao;

import model.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean createAppointment(Appointment app) {
        String sql = "INSERT INTO Appointments (patient_id, doctor_id, service_id, schedule_id, status) VALUES (?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, app.getPatientId());
            ps.setInt(2, app.getDoctorId());
            ps.setInt(3, app.getServiceId());
            ps.setInt(4, app.getScheduleId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách lịch hẹn của 1 Bệnh nhân
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        List<Appointment> list = new ArrayList<>();
        // Join 4 bảng để lấy tên thay vì hiện ID
        String sql = "SELECT a.id, a.status, s.name as service_name, " +
                     "d.user_id, u.full_name as doctor_name, " +
                     "sch.work_date, sch.start_time " +
                     "FROM Appointments a " +
                     "JOIN Services s ON a.service_id = s.id " +
                     "JOIN Doctors d ON a.doctor_id = d.id " +
                     "JOIN Users u ON d.user_id = u.id " +
                     "JOIN Schedules sch ON a.schedule_id = sch.id " +
                     "WHERE a.patient_id = ? ORDER BY a.created_at DESC";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setStatus(rs.getString("status"));
                app.setServiceName(rs.getString("service_name"));
                app.setDoctorName(rs.getString("doctor_name"));
                app.setScheduleDate(rs.getDate("work_date").toString());
                app.setScheduleTime(rs.getTime("start_time").toString());
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // [New] Lấy TOÀN BỘ lịch hẹn trong hệ thống cho Lễ Tân / Admin quản lý
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.id, a.status, s.name as service_name, " +
                     "p.full_name as patient_name, " +
                     "d.user_id, u.full_name as doctor_name, " +
                     "sch.work_date, sch.start_time " +
                     "FROM Appointments a " +
                     "JOIN Services s ON a.service_id = s.id " +
                     "JOIN Users p ON a.patient_id = p.id " +
                     "JOIN Doctors d ON a.doctor_id = d.id " +
                     "JOIN Users u ON d.user_id = u.id " +
                     "JOIN Schedules sch ON a.schedule_id = sch.id " +
                     "ORDER BY sch.work_date ASC, sch.start_time ASC";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setStatus(rs.getString("status"));
                app.setPatientName(rs.getString("patient_name")); // Lấy tên bệnh nhân
                app.setServiceName(rs.getString("service_name"));
                app.setDoctorName(rs.getString("doctor_name"));
                app.setScheduleDate(rs.getDate("work_date").toString());
                app.setScheduleTime(rs.getTime("start_time").toString());
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // [New] Cập nhật hình thái Lịch Hẹn (Check-in, Hủy, Hoàn thành)
    public boolean updateAppointmentStatus(int appointmentId, String newStatus) {
        String sql = "UPDATE Appointments SET status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // [New] Lấy thông tin chi tiết 1 Lịch Hẹn dựa vào ID
    public Appointment getAppointmentById(int id) {
        String sql = "SELECT a.*, s.name as service_name, " +
                     "p.full_name as patient_name, " +
                     "d.user_id, u.full_name as doctor_name, " +
                     "sch.work_date, sch.start_time " +
                     "FROM Appointments a " +
                     "JOIN Services s ON a.service_id = s.id " +
                     "JOIN Users p ON a.patient_id = p.id " +
                     "JOIN Doctors d ON a.doctor_id = d.id " +
                     "JOIN Users u ON d.user_id = u.id " +
                     "JOIN Schedules sch ON a.schedule_id = sch.id " +
                     "WHERE a.id = ?";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setPatientId(rs.getInt("patient_id"));
                app.setDoctorId(rs.getInt("doctor_id"));
                app.setServiceId(rs.getInt("service_id"));
                app.setScheduleId(rs.getInt("schedule_id"));
                app.setStatus(rs.getString("status"));
                app.setPatientName(rs.getString("patient_name"));
                app.setServiceName(rs.getString("service_name"));
                app.setDoctorName(rs.getString("doctor_name"));
                app.setScheduleDate(rs.getDate("work_date").toString());
                app.setScheduleTime(rs.getTime("start_time").toString());
                return app;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
