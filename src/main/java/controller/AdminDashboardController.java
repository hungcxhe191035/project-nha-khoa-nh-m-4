package controller;

import dao.ReportDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

//hung ddziiii
@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User admin = (User) session.getAttribute("user");

        // Cổng Check Security Cứng (Chỉ Admin mới có quyền truy cập URL này)
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy dữ liệu Map từ DAO
        Map<String, Object> summary = reportDAO.getDashboardSummary();
        request.setAttribute("summary", summary);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
