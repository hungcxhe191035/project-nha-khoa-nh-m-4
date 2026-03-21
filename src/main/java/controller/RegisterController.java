package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fix UTF-8 để nhận tiếng Việt từ Form Submit
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setPassword(password); // Ở hệ thống thực tế nên băm MD5 hoặc BCrypt
        newUser.setEmail(email);
        newUser.setPhone(phone);

        String result = userDAO.registerPatient(newUser);

        if ("SUCCESS".equals(result)) {
            // Đăng ký xong văng sang login kèm lời báo thành công
            request.setAttribute("error", "Đăng ký thành công! Vui lòng Đăng nhập vào hệ thống.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            // Lỗi do trùng username / email
            request.setAttribute("error", "Lưu thất bại: " + result);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
