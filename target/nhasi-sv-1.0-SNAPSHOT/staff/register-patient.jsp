<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký Khách Mới | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-container { display: flex; min-height: 100vh; background: #f8fafc; }
        .sidebar { width: 260px; background: white; padding: 2rem 1.5rem; box-shadow: 2px 0 10px rgba(0,0,0,0.05); }
        .sidebar-menu { list-style: none; padding: 0; margin-top: 2rem; }
        .sidebar-menu li a { display: flex; align-items: center; gap: 1rem; padding: 1rem; color: var(--gray); text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.3s; }
        .sidebar-menu li a:hover, .sidebar-menu li a.active { background: var(--light); color: var(--primary); }
        
        .main-content { flex: 1; padding: 2rem 3rem; }
        
        .form-card {
            background: white;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            max-width: 600px;
            margin-top: 2rem;
        }
        
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: var(--dark); font-size: 0.95rem; }
        .form-control { width: 100%; padding: 0.8rem 1rem; border: 1px solid var(--light); border-radius: 8px; font-size: 1rem; transition: border-color 0.3s; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); }
        
        .alert-success { background: #D1FAE5; color: #065F46; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem; }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div style="text-align: center; margin-bottom: 2rem;">
            <a href="${pageContext.request.contextPath}/" class="logo" style="text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 0.5rem; font-size: 1.5rem; font-weight: 700; color: var(--primary);">
                <i class="fa-solid fa-tooth"></i> SmileCare
            </a>
            <p style="margin-top: 0.5rem; color: var(--gray); font-size: 0.9rem;">Workspace Lễ Tân</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="fa-solid fa-calendar-check"></i> Quản lý Lịch hẹn</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/register-patient" class="active"><i class="fa-solid fa-users"></i> Đăng ký Khách mới</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/billing-list"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn & Thuốc</a></li>
        </ul>

        <div style="position: absolute; bottom: 2rem; width: 212px;">
            <div style="padding: 1rem; background: #f8fafc; border-radius: 8px; margin-bottom: 1rem; text-align: center;">
                <p style="font-weight: 600; margin: 0; color: var(--primary); font-size: 0.9rem;">${sessionScope.user.fullName}</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background: white; color: var(--danger); border: 1px solid var(--danger); width: 100%; text-align: center;">Đăng xuất</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <h2>Tạo tài khoản Bệnh nhân mới</h2>
        <p style="color: var(--gray);">Nhập thông tin bệnh nhân tới phòng khám chưa có tài khoản.</p>

        <div class="form-card">
            <c:if test="${not empty successMessage}">
                <div class="alert-success">
                    <i class="fa-solid fa-circle-check"></i> ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="error-msg" style="margin-bottom: 1.5rem;">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/staff/register-patient" method="POST">
                
                <div class="form-group">
                    <label>Họ và Tên <span style="color: red;">*</span></label>
                    <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
                </div>

                <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div>
                        <label>Tên đăng nhập (Username) <span style="color: red;">*</span></label>
                        <input type="text" name="username" class="form-control" placeholder="Viết liền không dấu" required>
                    </div>
                    <div>
                        <label>Số điện thoại <span style="color: red;">*</span></label>
                        <input type="text" name="phone" class="form-control" placeholder="09xxxx" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Email (Tùy chọn)</label>
                    <input type="email" name="email" class="form-control" placeholder="example@gmail.com">
                </div>

                <div class="form-group">
                    <label>Mật khẩu khởi tạo <span style="color: red;">*</span></label>
                    <input type="text" name="password" class="form-control" value="123456" required>
                    <small style="color: var(--gray); display: block; margin-top: 0.5rem;">* Mật khẩu mặc định là 123456. Khách hàng có thể đổi lại sau khi đăng nhập.</small>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;"><i class="fa-solid fa-user-plus"></i> Tạo Tài Khoản</button>
            </form>
        </div>
    </main>
</div>

</body>
</html>
