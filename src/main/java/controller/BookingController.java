package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.ScheduleDAO;
import dao.ServiceDAO;
import model.Appointment;
import model.User;
import model.Schedule;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Service;

@WebServlet(name = "BookingController", urlPatterns = {"/patient/booking"})
public class BookingController extends HttpServlet {
    private DoctorDAO doctorDAO;
    private ServiceDAO serviceDAO;
    private ScheduleDAO scheduleDAO;
    private AppointmentDAO aptDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
        serviceDAO = new ServiceDAO();
        scheduleDAO = new ScheduleDAO();
        aptDAO = new AppointmentDAO();
    }

    // Hiển thị Form Đặt Lịch (Giai đoạn 1: Chọn BS và Ngày tháng)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách bác sĩ và dịch vụ chuyển lên JSP
        request.setAttribute("doctors", doctorDAO.getAllDoctors());
        request.setAttribute("services", serviceDAO.getAllServices());
        
        request.getRequestDispatcher("/patient/booking.jsp").forward(request, response);
    }

    // Xử lý Submit đặt lịch hoặc AJAX load giờ trống
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Nếu client gửi action = "get_schedule" (Dùng Ajax/Fetch API từ Frontend)
        if ("get_schedule".equals(action)) {
            int doctorId = Integer.parseInt(request.getParameter("doctor_id"));
            String dateString = request.getParameter("date");
            
            // Ép chuẩn chuỗi ngày YYYY-MM-DD từ HTML thành sql.Date để tránh lỗi parser của SQL Server
            java.sql.Date sqlDate = java.sql.Date.valueOf(dateString);
            
            // Lấy 2 danh sách: Lịch trống & Dịch vụ của Bác đó
            List<Schedule> available = scheduleDAO.getAvailableSchedules(doctorId, sqlDate);
            List<Service> docServices = serviceDAO.getServicesByDoctorId(doctorId);
            
            // Xây dựng chuỗi JSON thủ công cực nhanh (không dùng thư viện ngoài)
            StringBuilder json = new StringBuilder("{");
            
            // 1. Gói danh sách Lịch (Schedules)
            json.append("\"schedules\": [");
            for (int i=0; i<available.size(); i++) {
                Schedule s = available.get(i);
                // Thoát các ký tự đặc biệt có thể có & Format chuẩn JSON
                String text = s.getStartTime() + " - " + s.getEndTime();
                json.append("{\"id\": ").append(s.getId()).append(", \"text\": \"").append(text).append("\"}");
                if (i < available.size() - 1) json.append(",");
            }
            json.append("],"); // <-- Đã xóa khoảng trắng sau dấu phẩy để parse json an toàn
            
            // 2. Gói danh sách Dịch Vụ (Services)
            json.append("\"services\": [");
            for (int i=0; i<docServices.size(); i++) {
                Service s = docServices.get(i);
                // Xử lý an toàn: thay thế ký tự ngoặc kép " có trong description bằng nháy đơn '
                String safeName = s.getName().replace("\"", "'");
                json.append("{\"id\":").append(s.getId()).append(", \"text\":\"").append(safeName).append("\"}");
                if (i < docServices.size() - 1) json.append(",");
            }
            json.append("]");
            
            json.append("}");
            
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(json.toString());
            return;
        }
        
        // Xử lý luồng BOOKING CHÍNH THỨC
        if ("book".equals(action)) {
            HttpSession session = request.getSession();
            User patient = (User) session.getAttribute("user");
            
            if (patient == null || !"PATIENT".equals(patient.getRole())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String docStr = request.getParameter("doctor_id");
            String srvStr = request.getParameter("service_id");
            String schStr = request.getParameter("schedule_id");

            if (docStr == null || docStr.trim().isEmpty() || 
                srvStr == null || srvStr.trim().isEmpty() || 
                schStr == null || schStr.trim().isEmpty()) {
                request.setAttribute("message", "Vui lòng chọn đầy đủ Bác sĩ, Khung giờ và Dịch vụ!");
                request.setAttribute("msgType", "danger");
            } else {
                try {
                    int doctorId = Integer.parseInt(docStr);
                    int serviceId = Integer.parseInt(srvStr);
                    int scheduleId = Integer.parseInt(schStr);
                    
                    Appointment apt = new Appointment();
                    apt.setPatientId(patient.getId());
                    apt.setDoctorId(doctorId);
                    apt.setServiceId(serviceId);
                    apt.setScheduleId(scheduleId);
                    
                    boolean success = aptDAO.createAppointment(apt);
                    if (success) {
                        // Cập nhật lại status của Schedule thành BOOKED để người khác khỏi giành
                        scheduleDAO.updateScheduleStatus(scheduleId, "BOOKED");
                        
                        request.setAttribute("message", "Đặt lịch thành công! Vui lòng chờ phòng khám xác nhận.");
                        request.setAttribute("msgType", "success");
                    } else {
                        request.setAttribute("message", "Đã có lỗi xảy ra! Khung giờ có thể đã được người khác đặt.");
                        request.setAttribute("msgType", "danger");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("message", "Dữ liệu không hợp lệ. Vui lòng tải lại trang và thử lại!");
                    request.setAttribute("msgType", "danger");
                }
            }
            
            // Trả lại dữ liệu trang
            request.setAttribute("doctors", doctorDAO.getAllDoctors());
            request.setAttribute("services", serviceDAO.getAllServices());
            request.getRequestDispatcher("/patient/booking.jsp").forward(request, response);
        }
    }
}
