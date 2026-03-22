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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/doctor/history")
public class DoctorHistoryController extends HttpServlet {
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
        
        if (!"DOCTOR".equals(doctor.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        List<Appointment> allAppointments = doctorDAO.getAppointmentsByDoctorUser(doctor.getId());
        List<Appointment> completedAppointments = new ArrayList<>();
        
        for (Appointment apt : allAppointments) {
            if ("COMPLETED".equals(apt.getStatus())) {
                completedAppointments.add(apt);
            }
        }

        request.setAttribute("appointments", completedAppointments);
        request.getRequestDispatcher("/doctor/history.jsp").forward(request, response);
    }
}
