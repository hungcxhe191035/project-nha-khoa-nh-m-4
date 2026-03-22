package controller;

import dao.AppointmentDAO;
import dao.MedicalRecordDAO;
import dao.MedicineDAO;
import dao.ServiceDAO;
import model.Appointment;
import model.MedicalRecord;
import model.MedicalRecordService;
import model.Medicine;
import model.PrescriptionDetail;
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

@WebServlet(name = "DoctorExaminationController", urlPatterns = {"/doctor/examination"})
public class DoctorExaminationController extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private MedicalRecordDAO medicalRecordDAO;
    private MedicineDAO medicineDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        medicalRecordDAO = new MedicalRecordDAO();
        medicineDAO = new MedicineDAO();
        serviceDAO = new ServiceDAO();
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

        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Lấy thông tin Appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                return;
            }
            request.setAttribute("appointment", appointment);

            // Kiểm tra xem đã có MedicalRecord chưa
            MedicalRecord record = medicalRecordDAO.getMedicalRecordByAppointment(appointmentId);
            if (record != null) {
                request.setAttribute("record", record);
                
                // Lấy danh sách dịch vụ đã kê
                List<MedicalRecordService> recordServices = medicalRecordDAO.getServicesByRecordId(record.getId());
                request.setAttribute("recordServices", recordServices);
                
                // Lấy danh sách thuốc đã kê
                List<PrescriptionDetail> prescriptions = medicalRecordDAO.getPrescriptionsByRecordId(record.getId());
                request.setAttribute("prescriptions", prescriptions);
                
                request.getRequestDispatcher("/doctor/record-detail.jsp").forward(request, response);
                return;
            }

            // Lấy danh sách thuốc và dịch vụ để hiển thị trong form kê thêm
            List<Medicine> allMedicines = medicineDAO.getAllMedicines();
            request.setAttribute("allMedicines", allMedicines);
            
            List<Service> allServices = serviceDAO.getAllServices();
            request.setAttribute("allServices", allServices);

            request.getRequestDispatcher("/doctor/examination.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        try {
            int appointmentId = Integer.parseInt(request.getParameter("apt_id"));
            String diagnosis = request.getParameter("diagnosis");
            
            // 1. Tạo Medical Record
            int recordId = medicalRecordDAO.createMedicalRecord(appointmentId, diagnosis);
            
            if (recordId > 0) {
                // 2. Thêm Dịch vụ phát sinh (nếu có)
                String[] serviceIds = request.getParameterValues("service_ids");
                if (serviceIds != null) {
                    for (String sid : serviceIds) {
                        if (sid != null && !sid.trim().isEmpty()) {
                            int serviceId = Integer.parseInt(sid);
                            double price = serviceDAO.getServicePrice(serviceId);
                            MedicalRecordService ms = new MedicalRecordService();
                            ms.setMedicalRecordId(recordId);
                            ms.setServiceId(serviceId);
                            ms.setPrice(price);
                            medicalRecordDAO.addServiceToRecord(ms);
                        }
                    }
                }

                // 3. Thêm Đơn thuốc (nếu có)
                String[] medicineIds = request.getParameterValues("medicine_ids");
                String[] quantities = request.getParameterValues("quantities");
                
                if (medicineIds != null && quantities != null && medicineIds.length == quantities.length) {
                    for (int i = 0; i < medicineIds.length; i++) {
                        String mid = medicineIds[i];
                        String qty = quantities[i];
                        
                        if (mid != null && !mid.trim().isEmpty() && qty != null && !qty.trim().isEmpty()) {
                            int medicineId = Integer.parseInt(mid);
                            int quantity = Integer.parseInt(qty);
                            double price = medicineDAO.getMedicinePrice(medicineId);
                            
                            PrescriptionDetail pd = new PrescriptionDetail();
                            pd.setMedicalRecordId(recordId);
                            pd.setMedicineId(medicineId);
                            pd.setPrescribedQuantity(quantity);
                            pd.setTotalPrice(price * quantity);
                            medicalRecordDAO.addPrescriptionToRecord(pd);
                        }
                    }
                }

                // 4. Update trạng thái Appointment -> COMPLETED
                appointmentDAO.updateAppointmentStatus(appointmentId, "COMPLETED");
                
                // Redirect về dashboard với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard?success=1");
            } else {
                // Lỗi tạo record
                request.setAttribute("error", "Lỗi lưu bệnh án. Vui lòng thử lại!");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            doGet(request, response);
        }
    }
}
