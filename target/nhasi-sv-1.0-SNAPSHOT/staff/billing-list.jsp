<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Hóa Đơn & Đơn Thuốc | SmileCare</title>
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
        .table-wrapper { background: white; border-radius: 12px; box-shadow: var(--shadow-sm); overflow: hidden; margin-top: 1.5rem; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 1rem 1.5rem; text-align: left; border-bottom: 1px solid var(--light); }
        .data-table th { background: #f8fafc; font-weight: 600; color: var(--dark); }
        .data-table tbody tr:hover { background: #f8fafc; }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div style="text-align: center; margin-bottom: 2rem;">
            <a href="${pageContext.request.contextPath}/" class="logo" style="color: var(--primary); text-decoration: none;">
                <i class="fa-solid fa-tooth"></i> SmileCare
            </a>
            <p style="margin-top: 0.5rem; color: var(--gray); font-size: 0.9rem;">Workspace Lễ Tân</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="fa-solid fa-calendar-check"></i> Quản lý Lịch hẹn</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/register-patient"><i class="fa-solid fa-users"></i> Đăng ký Khách mới</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/billing-list" class="active"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn & Thuốc</a></li>
        </ul>

        <div style="position: absolute; bottom: 2rem; width: 212px;">
            <div style="padding: 1rem; background: #f8fafc; border-radius: 8px; margin-bottom: 1rem;">
                <p style="font-weight: 600; margin: 0;">${sessionScope.user.fullName}</p>
                <span style="font-size: 0.8rem; color: var(--gray);">Lễ Tân Bàn 1</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background: white; color: var(--danger); border: 1px solid var(--danger); width: 100%; text-align: center;">Đăng xuất</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h2>Quản lý Hóa Đơn & Đơn Thuốc chờ thanh toán</h2>
        </div>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Khách hàng</th>
                        <th>Dịch vụ đã khám</th>
                        <th>Bác sĩ Đảm nhận</th>
                        <th>Thời gian</th>
                        <th>Tác vụ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="apt" items="${appointments}">
                        <tr>
                            <td style="font-weight: 500;">${apt.patientName}</td>
                            <td>${apt.serviceName}</td>
                            <td>${apt.doctorName}</td>
                            <td>
                                <strong>${apt.scheduleTime}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--gray);">${apt.scheduleDate}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/staff/billing?apt_id=${apt.id}" class="btn btn-primary" style="background: #10B981; border: 1px solid #10B981; padding: 0.4rem 0.8rem; font-size: 0.85rem;">
                                    <i class="fa-solid fa-file-invoice-dollar"></i> Xem Đơn Thuốc / Thanh Toán
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr><td colspan="5" style="text-align: center; color: var(--gray); padding: 2rem;">Chưa có đơn thuốc / hóa đơn nào cần xử lý.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
