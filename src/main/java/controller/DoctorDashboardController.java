package controller;

import dao.DoctorDAO;
import model.Appointment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DoctorDashboardController", urlPatterns = {"/doctor/dashboard"})
public class DoctorDashboardController extends HttpServlet {
    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User doctor = (User) session.getAttribute("user");
        
        // Chỉ cấp quyền cho DOCTOR
        if (!"DOCTOR".equals(doctor.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy danh sách Lịch khám của Bác Sĩ (Dựa trên User ID của bác sĩ đó đang Login)
        List<Appointment> doctorAppointments = doctorDAO.getAppointmentsByDoctorUser(doctor.getId());
        java.util.List<Appointment> confirmedAppointments = new java.util.ArrayList<>();
        for (Appointment apt : doctorAppointments) {
            if ("CONFIRMED".equals(apt.getStatus())) {
                confirmedAppointments.add(apt);
            }
        }
        
        request.setAttribute("appointments", confirmedAppointments);
        
        request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
    }
}
