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

@WebServlet(name = "StaffDashboardController", urlPatterns = {"/staff/dashboard"})
public class StaffDashboardController extends HttpServlet {
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

        User staff = (User) session.getAttribute("user");
        
        // Phân quyền: Ngăn cản nếu không phải STAFF hoặc ADMIN
        if (!"STAFF".equals(staff.getRole()) && !"ADMIN".equals(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy tất cả lịch hẹn đẩy ra giao diện Lễ Tân
        List<Appointment> allAppointments = aptDAO.getAllAppointments();
        request.setAttribute("appointments", allAppointments);
        
        request.getRequestDispatcher("/staff/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        
        if ("confirm".equals(action)) {
            aptDAO.updateAppointmentStatus(appointmentId, "CONFIRMED");
            request.getSession().setAttribute("message", "Đã duyệt Lịch hẹn #" + appointmentId);
        } else if ("cancel".equals(action)) {
            aptDAO.updateAppointmentStatus(appointmentId, "CANCELLED");
            request.getSession().setAttribute("message", "Đã HỦY Lịch hẹn #" + appointmentId);
        }

        // Redirect để tránh lỗi Form Resubmission (PRG pattern)
        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
    }
}
