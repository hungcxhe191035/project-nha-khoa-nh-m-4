package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

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

        request.setAttribute("users_list", userDAO.getAllUsers());
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        int userId = Integer.parseInt(request.getParameter("user_id"));

        if ("update_role".equals(action)) {
            String newRole = request.getParameter("role");
            if (newRole != null && !newRole.isEmpty()) {
                // Ngăn cấm Admin tự giáng cấp chính tài khoản đang đăng nhập
                if (admin.getId() != userId) {
                    userDAO.updateUserRole(userId, newRole);
                    request.getSession().setAttribute("message", "Đã cập nhật quyền thành công!");
                } else {
                    request.getSession().setAttribute("error", "Không được đổi quyền của bản thân!");
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
