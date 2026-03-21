<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-container { display: flex; min-height: 100vh; background: #f8fafc; }
        .sidebar { width: 260px; background: #0F172A; color: white; padding: 2rem 1.5rem; box-shadow: 2px 0 10px rgba(0,0,0,0.1); }
        .sidebar-menu { list-style: none; padding: 0; margin-top: 2rem; }
        .sidebar-menu li a { display: flex; align-items: center; gap: 1rem; padding: 1rem; color: #94A3B8; text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.3s; }
        .sidebar-menu li a:hover, .sidebar-menu li a.active { background: #1E293B; color: white; }
        
        .main-content { flex: 1; padding: 2rem 3rem; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-top: 1.5rem; }
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: var(--shadow-sm); border-left: 4px solid var(--primary); }
        .stat-card.revenue { border-left-color: #10B981; }
        .stat-card.today { border-left-color: #F59E0B; }
        
        .stat-icon { width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; margin-bottom: 1rem; }
        .stat-title { color: var(--gray); font-size: 0.9rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem; }
        .stat-value { color: var(--dark); font-size: 1.8rem; font-weight: 700; line-height: 1; }
        
        .system-branding { color: white; text-align: center; margin-bottom: 2rem; }
        .system-branding i { font-size: 2.5rem; color: #38BDF8; margin-bottom: 1rem; }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar Dark Mode for Admin -->
    <aside class="sidebar">
        <div class="system-branding">
            <i class="fa-solid fa-tooth"></i>
            <h3 style="margin:0; font-weight: 700;">SmileCare System</h3>
            <p style="margin-top: 0.2rem; font-size: 0.8rem; color: #94A3B8;">Quản Trị Viên (Admin)</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active"><i class="fa-solid fa-chart-pie"></i> Thống kê Doanh Thu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-user-shield"></i> Quản lý Nhân Sự</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/medicines"><i class="fa-solid fa-pills"></i> Kho Thuốc</a></li>
        </ul>

        <div style="position: absolute; bottom: 2rem; width: 212px;">
            <div style="padding: 1rem; background: #1E293B; border-radius: 8px; margin-bottom: 1rem;">
                <p style="font-weight: 600; margin: 0; color: white;">${sessionScope.user.fullName}</p>
                <span style="font-size: 0.8rem; color: #38BDF8;">Super Admin</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background: transparent; color: #F87171; border: 1px solid #F87171; width: 100%; text-align: center;">Đăng xuất Cổng quản trị</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <h2>Báo Cáo Tóm Tắt Hoạt Động Doanh Nghiệp</h2>
        <p style="color: var(--gray);">Dữ liệu được cập nhật theo thời gian thực từ CSDL.</p>

        <div class="stats-grid">
            <!-- Box 1 -->
            <div class="stat-card">
                <div class="stat-icon" style="background: #E0E7FF; color: #4338CA;"><i class="fa-solid fa-hospital-user"></i></div>
                <div class="stat-title">Thành viên ĐK</div>
                <div class="stat-value"><fmt:formatNumber value="${summary.total_patients}" pattern="#,###"/> <span style="font-size: 1rem; font-weight: 500; color: var(--gray);">người</span></div>
            </div>
            
            <!-- Box 2 -->
            <div class="stat-card">
                <div class="stat-icon" style="background: #F3E8FF; color: #7E22CE;"><i class="fa-solid fa-clipboard-check"></i></div>
                <div class="stat-title">Ca Khám T.Công</div>
                <div class="stat-value"><fmt:formatNumber value="${summary.total_completed_appointments}" pattern="#,###"/> <span style="font-size: 1rem; font-weight: 500; color: var(--gray);">ca</span></div>
            </div>

            <!-- Box 3 -->
            <div class="stat-card revenue">
                <div class="stat-icon" style="background: #D1FAE5; color: #059669;"><i class="fa-solid fa-sack-dollar"></i></div>
                <div class="stat-title">Tổng Doanh Thu (All Time)</div>
                <div class="stat-value" style="color: #059669;"><fmt:formatNumber value="${summary.total_revenue}" pattern="#,###"/> <span style="font-size: 1rem; font-weight: 500;">đ</span></div>
            </div>

            <!-- Box 4 -->
            <div class="stat-card today">
                <div class="stat-icon" style="background: #FEF3C7; color: #D97706;"><i class="fa-solid fa-hand-holding-dollar"></i></div>
                <div class="stat-title">Dòng tiền Hôm Nay</div>
                <div class="stat-value" style="color: #D97706;"><fmt:formatNumber value="${summary.today_revenue}" pattern="#,###"/> <span style="font-size: 1rem; font-weight: 500;">đ</span></div>
            </div>
        </div>
        
        <div style="margin-top: 3rem; background: white; padding: 2rem; border-radius: 12px; box-shadow: var(--shadow-sm); text-align: center; border: 1px dashed var(--light);">
            <i class="fa-solid fa-chart-line" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 1rem;"></i>
            <h3 style="color: var(--gray);">Biểu đồ Doanh Thu chi tiết</h3>
            <p style="color: #94a3b8; font-size: 0.9rem;">Sẽ được nâng cấp tính năng vẽ biểu đồ D3.js/Chart.js trong phiên bản Ver 2.0</p>
        </div>
    </main>
</div>

</body>
</html>
