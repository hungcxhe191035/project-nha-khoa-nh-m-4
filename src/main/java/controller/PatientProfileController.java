package controller;

import dao.AppointmentDAO;
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

@WebServlet(name = "PatientProfileController", urlPatterns = {"/patient/profile"})
public class PatientProfileController extends HttpServlet {
    private AppointmentDAO aptDAO;

    @Override
    public void init() {
        aptDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User patient = (User) session.getAttribute("user");
        
        // Chỉ bện nhân mới vào được trang này
        if (!"PATIENT".equals(patient.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy lịch sử Appointment của Patient này
        List<Appointment> myAppointments = aptDAO.getAppointmentsByPatient(patient.getId());
        request.setAttribute("appointments", myAppointments);
        
        request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
    }
}
