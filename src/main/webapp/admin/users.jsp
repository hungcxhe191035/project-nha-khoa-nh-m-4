<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Sự | Admin SmileCare</title>
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
        .system-branding { color: white; text-align: center; margin-bottom: 2rem; }
        .system-branding i { font-size: 2.5rem; color: #38BDF8; margin-bottom: 1rem; }
        
        .table-wrapper { background: white; border-radius: 12px; box-shadow: var(--shadow-sm); overflow: hidden; margin-top: 2rem; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 1.2rem 1.5rem; text-align: left; border-bottom: 1px solid var(--light); }
        .data-table th { background: #f8fafc; font-weight: 600; color: #334155; }
        .data-table tbody tr:hover { background: #f8fafc; }
        
        .badge { padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge-admin { background: #FEF2F2; color: #EF4444; border: 1px solid #FECACA; }
        .badge-doctor { background: #EFF6FF; color: #3B82F6; border: 1px solid #BFDBFE; }
        .badge-staff { background: #FFFBEB; color: #F59E0B; border: 1px solid #FDE68A; }
        .badge-patient { background: #F1F5F9; color: #64748B; border: 1px solid #E2E8F0; }
        .badge-locked { background: #18181B; color: white; }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="system-branding">
            <i class="fa-solid fa-tooth"></i>
            <h3 style="margin:0; font-weight: 700;">SmileCare System</h3>
            <p style="margin-top: 0.2rem; font-size: 0.8rem; color: #94A3B8;">Quản Trị Viên (Admin)</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-pie"></i> Thống kê Doanh Thu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="fa-solid fa-user-shield"></i> Quản lý Nhân Sự</a></li>
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
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2>Hồ Sơ Tài Khoản Hệ Thống</h2>
                <p style="color: var(--gray);">Phân quyền chức vụ và Giám sát bảo mật truy cập của nền tảng.</p>
            </div>
        </div>

        <c:if test="${not empty sessionScope.message}">
            <div style="background: #D1FAE5; color: #059669; padding: 15px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #059669;">
                <i class="fa-solid fa-check"></i> ${sessionScope.message}
                <% session.removeAttribute("message"); %>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div style="background: #FEE2E2; color: #DC2626; padding: 15px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #DC2626;">
                <i class="fa-solid fa-xmark"></i> ${sessionScope.error}
                <% session.removeAttribute("error"); %>
            </div>
        </c:if>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ Tên & Ngành Nghề</th>
                        <th>Thông tin Liên lạc</th>
                        <th>Vai Trò (Role)</th>
                        <th>Thao tác Hành chính (Action)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users_list}">
                        <tr>
                            <td style="color: var(--gray); font-size: 0.9rem;">#${u.id}</td>
                            <td>
                                <strong>${u.fullName}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--gray);"><i class="fa-solid fa-user-tag"></i> Username: ${u.username}</span>
                            </td>
                            <td style="font-size: 0.9rem;">
                                <div><i class="fa-solid fa-envelope" style="color: #94A3B8; width: 20px;"></i> ${not empty u.email ? u.email : 'N/A'}</div>
                                <div style="margin-top: 4px;"><i class="fa-solid fa-phone" style="color: #94A3B8; width: 20px;"></i> ${not empty u.phone ? u.phone : 'N/A'}</div>
                            </td>
                            <td>
                                <span class="badge badge-${u.role.toLowerCase()}">${u.role}</span>
                            </td>
                            <td>
                                <!-- Không cho tự sửa chính mình -->
                                <c:choose>
                                    <c:when test="${u.id == sessionScope.user.id}">
                                        <button class="btn btn-primary" style="background: transparent; color: #94A3B8; cursor: not-allowed; border: 1px dotted #CBD5E1; padding: 0.4rem 0.8rem; font-size: 0.85rem;" disabled>Me</button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="display: flex; gap: 0.5rem; align-items: center;">
                                            <input type="hidden" name="action" value="update_role">
                                            <input type="hidden" name="user_id" value="${u.id}">
                                            
                                            <select name="role" class="form-control" style="margin: 0; padding: 0.4rem; font-size: 0.85rem; width: 140px;">
                                                <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>Quản trị (ADMIN)</option>
                                                <option value="DOCTOR" ${u.role == 'DOCTOR' ? 'selected' : ''}>Bác sĩ (DOCTOR)</option>
                                                <option value="STAFF" ${u.role == 'STAFF' ? 'selected' : ''}>Lễ tân (STAFF)</option>
                                                <option value="PATIENT" ${u.role == 'PATIENT' ? 'selected' : ''}>Khách (PATIENT)</option>
                                                <option value="LOCKED" ${u.role == 'LOCKED' ? 'selected' : ''}>KHÓA (LOCKED)</option>
                                            </select>
                                            
                                            <button type="submit" class="btn btn-primary" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;" onclick="return confirm('Chuyển đổi quyền người dùng này? Thao tác có hiệu lực lập tức!');">
                                                Cấp Phép
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty users_list}">
                        <tr><td colspan="5" style="text-align: center; color: var(--gray); padding: 3rem;">Lập tức kiểm tra Database. Không tìm thấy người dùng!</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
