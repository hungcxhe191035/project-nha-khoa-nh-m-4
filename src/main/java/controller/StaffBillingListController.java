package controller;

import dao.AppointmentDAO;
import dao.MedicalRecordDAO;
import model.Appointment;
import model.MedicalRecord;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/staff/billing-list")
public class StaffBillingListController extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

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

        // Lấy tất cả lịch hẹn và lọc ra những lịch đã hoàn thành để thanh toán / xem thuốc
        List<Appointment> allAppointments = appointmentDAO.getAllAppointments();
        List<Appointment> completedAppointments = new ArrayList<>();
        MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
        
        for (Appointment apt : allAppointments) {
            if ("COMPLETED".equals(apt.getStatus())) {
                MedicalRecord record = medicalRecordDAO.getMedicalRecordByAppointment(apt.getId());
                // Nếu chưa viết bệnh án HOẶC bệnh án chưa thanh toán (tức là != "PAID") thì mới hiện lên nhắc nhở
                if (record == null || !"PAID".equals(record.getServicePaymentStatus())) {
                    completedAppointments.add(apt);
                }
            }
        }

        request.setAttribute("appointments", completedAppointments);
        request.getRequestDispatcher("/staff/billing-list.jsp").forward(request, response);
    }
}
