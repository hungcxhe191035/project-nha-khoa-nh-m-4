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

@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout"})
public class LoginController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        if (action.equals("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        User loggedInUser = userDAO.login(user, pass);
        
        if (loggedInUser != null) {
            if ("LOCKED".equals(loggedInUser.getRole())) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa bởi Quản Trị Viên!");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", loggedInUser);
            
            // Phân quyền chuyển hướng (RBAC)
            switch (loggedInUser.getRole()) {
                case "ADMIN":
                    response.sendRedirect("admin/dashboard");
                    break;
                case "STAFF":
                    response.sendRedirect("staff/dashboard");
                    break;
                case "DOCTOR":
                    response.sendRedirect("doctor/dashboard");
                    break;
                case "PATIENT":
                    response.sendRedirect("patient/profile");
                    break;
                default:
                    response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
