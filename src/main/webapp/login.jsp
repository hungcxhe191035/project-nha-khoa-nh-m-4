<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="auth-container">
        <div class="auth-card glass">
            <h2><i class="fa-solid fa-user-lock" style="color: var(--primary);"></i> Đăng nhập</h2>
            
            <c:if test="${not empty error}">
                <div style="background-color: #FEE2E2; color: #DC2626; padding: 10px; border-radius: 8px; margin-bottom: 15px; text-align: center; font-size: 0.9rem;">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" class="form-control" required placeholder="Gõ: admin / patient1">
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" required placeholder="Mặc định: 123456">
                </div>
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; font-size: 0.9rem;">
                    <label style="display: flex; align-items: center; gap: 0.5rem; font-weight: normal; margin: 0; color: var(--gray);">
                        <input type="checkbox"> Ghi nhớ
                    </label>
                    <a href="#" onclick="alert('Hệ thống đang bảo trì tính năng này. Vui lòng liên hệ Admin để cấp lại mật khẩu.'); return false;" style="color: var(--primary); text-decoration: none;">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="text-align: center;">Đăng nhập hệ thống</button>
            </form>

            <p style="text-align: center; margin-top: 1.5rem; color: var(--gray);">
                Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" style="color: var(--primary); text-decoration: none; font-weight: 600;">Đăng ký bệnh nhân</a>
            </p>
        </div>
    </div>

</body>
</html>
