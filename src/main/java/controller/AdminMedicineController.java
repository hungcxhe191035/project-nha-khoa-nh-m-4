package controller;

import dao.MedicineDAO;
import model.Medicine;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/medicines")
public class AdminMedicineController extends HttpServlet {
    private MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User admin = (User) session.getAttribute("user");
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.setAttribute("medicines", medicineDAO.getAllMedicines());
        request.getRequestDispatcher("/admin/medicines.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User admin = (User) session.getAttribute("user");
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            if ("add".equals(action)) {
                Medicine m = new Medicine();
                m.setName(request.getParameter("name"));
                m.setUnit(request.getParameter("unit"));
                m.setPrice(Double.parseDouble(request.getParameter("price")));
                m.setStockQuantity(Integer.parseInt(request.getParameter("stock_quantity")));
                
                if (medicineDAO.addMedicine(m)) {
                    session.setAttribute("message", "Thêm thuốc thành công!");
                } else {
                    session.setAttribute("error", "Lỗi khi thêm thuốc!");
                }
            } else if ("update".equals(action)) {
                Medicine m = new Medicine();
                m.setId(Integer.parseInt(request.getParameter("id")));
                m.setName(request.getParameter("name"));
                m.setUnit(request.getParameter("unit"));
                m.setPrice(Double.parseDouble(request.getParameter("price")));
                m.setStockQuantity(Integer.parseInt(request.getParameter("stock_quantity")));
                
                if (medicineDAO.updateMedicine(m)) {
                    session.setAttribute("message", "Cập nhật thuốc thành công!");
                } else {
                    session.setAttribute("error", "Lỗi khi cập nhật!");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (medicineDAO.deleteMedicine(id)) {
                    session.setAttribute("message", "Đã xóa thuốc khỏi hệ thống");
                } else {
                    session.setAttribute("error", "Đang có đơn thuốc sử dụng loại thuốc này, không thể xóa!");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Dữ liệu nhập không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/medicines");
    }
}
