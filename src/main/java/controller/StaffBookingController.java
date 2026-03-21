package controller;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.ScheduleDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Appointment;
import model.Schedule;
import model.Service;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffBookingController", urlPatterns = {"/staff/booking"})
public class StaffBookingController extends HttpServlet {
    private DoctorDAO doctorDAO = new DoctorDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private ScheduleDAO scheduleDAO = new ScheduleDAO();
    private AppointmentDAO aptDAO = new AppointmentDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User staff = (User) session.getAttribute("user");
        if (!"STAFF".equals(staff.getRole()) && !"ADMIN".equals(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.setAttribute("patients", userDAO.getAllPatients());
        request.setAttribute("doctors", doctorDAO.getAllDoctors());
        request.setAttribute("services", serviceDAO.getAllServices());
        
        request.getRequestDispatcher("/staff/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("get_schedule".equals(action)) {
            int doctorId = Integer.parseInt(request.getParameter("doctor_id"));
            String dateString = request.getParameter("date");
            
            java.sql.Date sqlDate = java.sql.Date.valueOf(dateString);
            
            List<Schedule> available = scheduleDAO.getAvailableSchedules(doctorId, sqlDate);
            List<Service> docServices = serviceDAO.getServicesByDoctorId(doctorId);
            
            StringBuilder json = new StringBuilder("{");
            json.append("\"schedules\": [");
            for (int i=0; i<available.size(); i++) {
                Schedule s = available.get(i);
                String text = s.getStartTime() + " - " + s.getEndTime();
                json.append("{\"id\": ").append(s.getId()).append(", \"text\": \"").append(text).append("\"}");
                if (i < available.size() - 1) json.append(",");
            }
            json.append("],"); 
            
            json.append("\"services\": [");
            for (int i=0; i<docServices.size(); i++) {
                Service s = docServices.get(i);
                String safeName = s.getName().replace("\"", "'");
                json.append("{\"id\":").append(s.getId()).append(", \"text\":\"").append(safeName).append("\"}");
                if (i < docServices.size() - 1) json.append(",");
            }
            json.append("]}");
            
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(json.toString());
            return;
        }
        
        if ("book".equals(action)) {
            String patientStr = request.getParameter("patient_id");
            String docStr = request.getParameter("doctor_id");
            String srvStr = request.getParameter("service_id");
            String schStr = request.getParameter("schedule_id");

            if (patientStr == null || patientStr.isEmpty() ||
                docStr == null || docStr.isEmpty() || 
                srvStr == null || srvStr.isEmpty() || 
                schStr == null || schStr.isEmpty()) {
                request.setAttribute("message", "Vui lòng chọn đầy đủ Bệnh nhân, Bác sĩ, Khung giờ và Dịch vụ!");
                request.setAttribute("msgType", "danger");
            } else {
                try {
                    int patientId = Integer.parseInt(patientStr);
                    int doctorId = Integer.parseInt(docStr);
                    int serviceId = Integer.parseInt(srvStr);
                    int scheduleId = Integer.parseInt(schStr);
                    
                    Appointment apt = new Appointment();
                    apt.setPatientId(patientId);
                    apt.setDoctorId(doctorId);
                    apt.setServiceId(serviceId);
                    apt.setScheduleId(scheduleId);
                    
                    boolean success = aptDAO.createAppointment(apt);
                    if (success) {
                        scheduleDAO.updateScheduleStatus(scheduleId, "BOOKED");
                        // Gửi thẳng về danh sách Dashboard
                        response.sendRedirect(request.getContextPath() + "/staff/dashboard?msg=booked_success");
                        return;
                    } else {
                        request.setAttribute("message", "Đã có lỗi xảy ra! Khung giờ có thể đã trùng lặp.");
                        request.setAttribute("msgType", "danger");
                    }
                } catch (Exception e) {
                    request.setAttribute("message", "Dữ liệu không hợp lệ!");
                    request.setAttribute("msgType", "danger");
                }
            }
            
            // Nếu lỗi mới load lại trang này
            request.setAttribute("patients", userDAO.getAllPatients());
            request.setAttribute("doctors", doctorDAO.getAllDoctors());
            request.setAttribute("services", serviceDAO.getAllServices());
            request.getRequestDispatcher("/staff/booking.jsp").forward(request, response);
        }
    }
}
