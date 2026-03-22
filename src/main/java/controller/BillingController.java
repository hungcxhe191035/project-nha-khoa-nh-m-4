package controller;

import dao.MedicalRecordDAO;
import dao.MedicineDAO;
import model.MedicalRecord;
import model.MedicalRecordService;
import model.PrescriptionDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import dao.AppointmentDAO;
import java.util.List;

@WebServlet("/staff/billing")
public class BillingController extends HttpServlet {
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        model.User staff = (model.User) session.getAttribute("user");
        if (!"STAFF".equals(staff.getRole()) && !"ADMIN".equals(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String aptIdStr = request.getParameter("apt_id");
        if (aptIdStr == null || aptIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        int aptId = Integer.parseInt(aptIdStr);
        MedicalRecord record = medicalRecordDAO.getMedicalRecordByAppointment(aptId);

        if (record == null) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?error=not_found");
            return;
        }

        List<MedicalRecordService> services = medicalRecordDAO.getServicesByRecordId(record.getId());
        List<PrescriptionDetail> prescriptions = medicalRecordDAO.getPrescriptionsByRecordId(record.getId());

        // Tính sơ bộ tổng tiền
        double totalServicePrice = 0;
        for (MedicalRecordService s : services) {
            if ("UNPAID".equals(s.getPaymentStatus())) {
                totalServicePrice += s.getPrice();
            }
        }
        
        double maxPrescriptionPrice = 0;
        for (PrescriptionDetail p : prescriptions) {
            if ("UNPAID".equals(p.getPaymentStatus())) {
                maxPrescriptionPrice += p.getTotalPrice();
            }
        }

        request.setAttribute("record", record);
        request.setAttribute("services", services);
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("totalServicePrice", totalServicePrice);
        request.setAttribute("maxPrescriptionPrice", maxPrescriptionPrice);

        request.getRequestDispatcher("/staff/billing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        model.User staff = (model.User) session.getAttribute("user");
        if (!"STAFF".equals(staff.getRole()) && !"ADMIN".equals(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int recordId = Integer.parseInt(request.getParameter("record_id"));

            // 1. Thanh toán toàn bộ Dịch vụ phát sinh
            medicalRecordDAO.updateMedicalRecordServicePayment(recordId);

            // 2. Thanh toán một phần (hoặc toàn bộ) Đơn thuốc (Trừ số lượng tồn kho)
            String[] prescIds = request.getParameterValues("prescription_ids");
            String[] purchasedQtys = request.getParameterValues("purchased_qtys");
            String[] medicineIds = request.getParameterValues("medicine_ids");

            if (prescIds != null && purchasedQtys != null && medicineIds != null) {
                for (int i = 0; i < prescIds.length; i++) {
                    int prescId = Integer.parseInt(prescIds[i]);
                    int qty = Integer.parseInt(purchasedQtys[i]);
                    int medId = Integer.parseInt(medicineIds[i]);

                    if (qty > 0) {
                        double unitPrice = medicineDAO.getMedicinePrice(medId);
                        double newTotal = unitPrice * qty;
                        
                        // Đánh dấu đã thanh toán 1 phần trong DB Đơn Thuốc
                        medicalRecordDAO.payPrescription(prescId, qty, newTotal);
                        
                        // Trừ kho
                        medicineDAO.deductStock(medId, qty);
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/staff/billing-list?msg=payment_success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/billing-list?error=payment_failed");
        }
    }
}
