<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Bệnh Án | SmileCare</title>
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
            <div style="width: 80px; height: 80px; background: #E0E7FF; color: var(--primary); border-radius: 50%; font-size: 2.5rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem auto;">
                <i class="fa-solid fa-user-doctor"></i>
            </div>
            <p style="margin-top: 0.5rem; color: var(--dark); font-weight: 600;">Workspace Bác sĩ</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/doctor/dashboard"><i class="fa-solid fa-list-check"></i> Ca Khám Của Tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/doctor/history" class="active"><i class="fa-solid fa-file-medical"></i> Lịch Sử Bệnh Án</a></li>
        </ul>

        <div style="position: absolute; bottom: 2rem; width: 212px;">
            <div style="padding: 1rem; background: #f8fafc; border-radius: 8px; margin-bottom: 1rem; text-align: center;">
                <p style="font-weight: 600; margin: 0; color: var(--primary);">${sessionScope.user.fullName}</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background: white; color: var(--danger); border: 1px solid var(--danger); width: 100%; text-align: center;">Đăng xuất</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2>Lịch sử Bệnh Án & Đơn Thuốc đã kê</h2>
                <p style="color: var(--gray);">Danh sách các ca khám mà bạn đã hoàn tất.</p>
            </div>
        </div>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Bệnh nhân</th>
                        <th>Dịch vụ khám</th>
                        <th>Thời gian</th>
                        <th>Tác vụ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="apt" items="${appointments}">
                        <tr>
                            <td style="font-weight: 500;">
                                <i class="fa-solid fa-hospital-user" style="color: var(--gray); margin-right: 8px;"></i>
                                ${apt.patientName}
                            </td>
                            <td>${apt.serviceName}</td>
                            <td>
                                <strong>${apt.scheduleTime}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--gray);">${apt.scheduleDate}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/doctor/examination?id=${apt.id}" class="btn btn-primary" style="background: var(--light); color: var(--gray); padding: 0.4rem 0.8rem; font-size: 0.85rem;"><i class="fa-solid fa-eye"></i> Xem Bệnh Án</a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr><td colspan="4" style="text-align: center; color: var(--gray); padding: 3rem;"><i class="fa-solid fa-folder-open" style="font-size: 2rem; margin-bottom: 1rem; color: #cbd5e1;"></i><br>Chưa có bệnh án nào được lưu.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
