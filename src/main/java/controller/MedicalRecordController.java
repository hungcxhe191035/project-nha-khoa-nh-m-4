package controller;

import dao.MedicalRecordDAO;
import dao.ServiceDAO;
import dao.MedicineDAO;
import dao.AppointmentDAO;
import model.MedicalRecordService;
import model.PrescriptionDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/doctor/record")
public class MedicalRecordController extends HttpServlet {
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private MedicineDAO medicineDAO = new MedicineDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO(); // Giả định Service có update status

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String aptIdStr = request.getParameter("apt_id");
        if (aptIdStr == null || aptIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }

        // Lấy danh mục Thuốc và Dịch Vụ đẩy ra màn hình để Bác sĩ có dropdown chọn lựa
        request.setAttribute("servicesList", serviceDAO.getAllServices());
        request.setAttribute("medicinesList", medicineDAO.getAllMedicines());
        
        // Pass ID lịch hẹn để form nộp đi
        request.setAttribute("apt_id", aptIdStr);
        request.getRequestDispatcher("/doctor/examination.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int aptId = Integer.parseInt(request.getParameter("apt_id"));
            String diagnosis = request.getParameter("diagnosis");

            // Kiểm tra rỗng chẩn đoán
            if (diagnosis == null || diagnosis.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập chẩn đoán bệnh.");
                doGet(request, response);
                return;
            }

            // 1. Tạo Medical Record
            int recordId = medicalRecordDAO.createMedicalRecord(aptId, diagnosis);
            if (recordId <= 0) {
                throw new Exception("Lỗi khi tạo Bệnh Án mới.");
            }

            // 2. Kê thêm Dịch Vụ (Mũi tên xuống từ Array)
            String[] serviceIds = request.getParameterValues("service_ids");
            if (serviceIds != null) {
                for (String sid : serviceIds) {
                    if (!sid.isEmpty()) {
                        int serviceId = Integer.parseInt(sid);
                        double price = serviceDAO.getServicePrice(serviceId); // Cần tạo thêm bên ServiceDAO
                        
                        MedicalRecordService ms = new MedicalRecordService();
                        ms.setMedicalRecordId(recordId);
                        ms.setServiceId(serviceId);
                        ms.setPrice(price);
                        medicalRecordDAO.addServiceToRecord(ms);
                    }
                }
            }

            // 3. Kê Thuốc (Medicine_id và Quantity nhận dạng Arrays song song)
            String[] medicineIds = request.getParameterValues("medicine_ids");
            String[] quantities = request.getParameterValues("quantities");
            
            if (medicineIds != null && quantities != null) {
                for (int i = 0; i < medicineIds.length; i++) {
                    if (!medicineIds[i].isEmpty() && !quantities[i].isEmpty()) {
                        int medId = Integer.parseInt(medicineIds[i]);
                        int qty = Integer.parseInt(quantities[i]);
                        
                        double unitPrice = medicineDAO.getMedicinePrice(medId); // Get Info
                        double total = unitPrice * qty;
                        
                        PrescriptionDetail pd = new PrescriptionDetail();
                        pd.setMedicalRecordId(recordId);
                        pd.setMedicineId(medId);
                        pd.setPrescribedQuantity(qty);
                        pd.setTotalPrice(total);
                        medicalRecordDAO.addPrescriptionToRecord(pd);
                    }
                }
            }

            // 4. Update Appointment Status => COMPLETED
            appointmentDAO.updateAppointmentStatus(aptId, "COMPLETED");

            // OK -> Về Dashboard
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình lưu: " + e.getMessage());
            doGet(request, response);
        }
    }
}
