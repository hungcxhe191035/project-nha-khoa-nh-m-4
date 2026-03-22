package controller;

import dao.AppointmentDAO;
import dao.MedicalRecordDAO;
import model.Appointment;
import model.MedicalRecord;
import model.MedicalRecordService;
import model.PrescriptionDetail;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PatientRecordController", urlPatterns = {"/patient/record"})
public class PatientRecordController extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private MedicalRecordDAO medicalRecordDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        medicalRecordDAO = new MedicalRecordDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User patient = (User) session.getAttribute("user");
        if (!"PATIENT".equals(patient.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String aptIdStr = request.getParameter("apt_id");
        if (aptIdStr == null || aptIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/profile");
            return;
        }

        try {
            int aptId = Integer.parseInt(aptIdStr);
            
            // Validate that this appointment belongs to the logged-in patient
            Appointment appointment = appointmentDAO.getAppointmentById(aptId);
            if (appointment == null || appointment.getPatientId() != patient.getId()) {
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            MedicalRecord record = medicalRecordDAO.getMedicalRecordByAppointment(aptId);
            if (record == null) {
                // Return to profile with an error message or just redirect
                response.sendRedirect(request.getContextPath() + "/patient/profile?error=no_record");
                return;
            }

            List<MedicalRecordService> services = medicalRecordDAO.getServicesByRecordId(record.getId());
            List<PrescriptionDetail> prescriptions = medicalRecordDAO.getPrescriptionsByRecordId(record.getId());

            request.setAttribute("appointment", appointment);
            request.setAttribute("record", record);
            request.setAttribute("services", services);
            request.setAttribute("prescriptions", prescriptions);

            request.getRequestDispatcher("/patient/record.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        }
    }
}
