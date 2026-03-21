<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký bệnh nhân | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="auth-container">
        <div class="auth-card glass" style="max-width: 500px;">
            <h2 style="text-align: center;"><i class="fa-solid fa-user-plus" style="color: var(--primary);"></i> Tạo Tài Khoản Khám Bệnh</h2>
            <p style="text-align: center; color: var(--gray); margin-bottom: 1.5rem;">Điền đầy đủ thông tin để đặt lịch dễ dàng</p>
            
            <c:if test="${not empty error}">
                <div style="background-color: #FEE2E2; color: #DC2626; padding: 10px; border-radius: 8px; margin-bottom: 15px; text-align: center; font-size: 0.9rem;">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label for="fullName">Họ và tên đầy đủ</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required placeholder="Trần Văn A">
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="form-control" required placeholder="090...">
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required placeholder="abc@gmail.com">
                    </div>
                </div>

                <div class="form-group">
                    <label for="username">Tên đăng nhập (Username)</label>
                    <input type="text" id="username" name="username" class="form-control" required placeholder="patient123">
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" required placeholder="Bảo mật mật khẩu">
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="text-align: center; font-size: 1.1rem; padding: 1rem; margin-top: 1rem;">Đăng ký ngay</button>
            </form>

            <p style="text-align: center; margin-top: 1.5rem; color: var(--gray);">
                Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); text-decoration: none; font-weight: 600;">Quay lại Đăng nhập</a>
            </p>
        </div>
    </div>

</body>
</html>
