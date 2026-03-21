package dao;

import model.Schedule;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    // List available schedules
    public List<Schedule> getAvailableSchedules(int doctorId, java.sql.Date date) {
        // [HOTFIX] Auto generate schedules if empty
        autoGenerateSchedulesIfEmpty(doctorId, date);
        
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT * FROM Schedules WHERE doctor_id = ? AND work_date = ? AND status = 'AVAILABLE'";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setId(rs.getInt("id"));
                s.setDoctorId(rs.getInt("doctor_id"));
                s.setWorkDate(rs.getDate("work_date"));
                s.setStartTime(rs.getTime("start_time"));
                s.setEndTime(rs.getTime("end_time"));
                s.setStatus(rs.getString("status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update status 
    public boolean updateScheduleStatus(int id, String newStatus) {
        String sql = "UPDATE Schedules SET status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Auto generate 6 default shifts if none exist for that day
    private void autoGenerateSchedulesIfEmpty(int doctorId, java.sql.Date date) {
        String checkSql = "SELECT COUNT(*) FROM Schedules WHERE doctor_id = ? AND work_date = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
            
            psCheck.setInt(1, doctorId);
            psCheck.setDate(2, date);
            ResultSet rs = psCheck.executeQuery();
            
            if (rs.next() && rs.getInt(1) == 0) {
                // Generate 6 default shifts 
                String insertSql = "INSERT INTO Schedules (doctor_id, work_date, start_time, end_time, status) VALUES (?, ?, ?, ?, 'AVAILABLE')";
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    String[][] defaultShifts = {
                        {"08:00:00", "09:00:00"},
                        {"09:00:00", "10:00:00"},
                        {"10:00:00", "11:00:00"},
                        {"14:00:00", "15:00:00"},
                        {"15:00:00", "16:00:00"},
                        {"16:00:00", "17:00:00"}
                    };
                    
                    for (String[] shift : defaultShifts) {
                        psInsert.setInt(1, doctorId);
                        psInsert.setDate(2, date);
                        psInsert.setTime(3, java.sql.Time.valueOf(shift[0]));
                        psInsert.setTime(4, java.sql.Time.valueOf(shift[1]));
                        psInsert.addBatch();
                    }
                    psInsert.executeBatch();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
