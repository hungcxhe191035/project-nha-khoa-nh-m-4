package dao;

import model.User;
import model.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {

    // Lấy tất cả bác sĩ để khách chọn lúc book lịch
    public List<User> getAllDoctors() {
        List<User> list = new ArrayList<>();
        // Join Users và Doctors
        String sql = "SELECT d.id as doctor_id, u.full_name, d.specialty " + 
                     "FROM Doctors d JOIN Users u ON d.user_id = u.id";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User doctor = new User();
                doctor.setId(rs.getInt("doctor_id")); // Chú ý: Đây là ID của bảng Doctors, ko phải Users
                doctor.setFullName(rs.getString("full_name"));
                doctor.setRole(rs.getString("specialty")); // Tạm mượn trường role để lưu Specialty hiển thị ra View
                list.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // [New] Lấy lịch khám (đã duyệt) của riêng 1 Bác sĩ dựa theo USER_ID
    public List<Appointment> getAppointmentsByDoctorUser(int userId) {
        List<Appointment> list = new ArrayList<>();
        // Tìm ra ID Bác sĩ dựa vào ID User đang đăng nhập, sau đó truy vấn Lịch
        String sql = "SELECT a.id, a.status, s.name as service_name, " +
                     "p.full_name as patient_name, " +
                     "sch.work_date, sch.start_time " +
                     "FROM Appointments a " +
                     "JOIN Services s ON a.service_id = s.id " +
                     "JOIN Users p ON a.patient_id = p.id " +
                     "JOIN Doctors d ON a.doctor_id = d.id " +
                     "JOIN Schedules sch ON a.schedule_id = sch.id " +
                     "WHERE d.user_id = ? AND (a.status = 'CONFIRMED' OR a.status = 'COMPLETED') " +
                     "ORDER BY sch.work_date ASC, sch.start_time ASC";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
             ps.setInt(1, userId);
             ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment app = new Appointment();
                app.setId(rs.getInt("id"));
                app.setStatus(rs.getString("status"));
                app.setPatientName(rs.getString("patient_name")); 
                app.setServiceName(rs.getString("service_name"));
                app.setScheduleDate(rs.getDate("work_date").toString());
                app.setScheduleTime(rs.getTime("start_time").toString());
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
