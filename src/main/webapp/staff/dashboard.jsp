<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lễ Tân Dashboard | SmileCare</title>
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
        
        .badge { padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .badge-pending { background: #FEF3C7; color: #D97706; }
        .badge-confirmed { background: #D1FAE5; color: #059669; }
        .badge-cancelled { background: #FEE2E2; color: #DC2626; }
        .badge-completed { background: #E0E7FF; color: #4338CA; }
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
            <li><a href="#" class="active"><i class="fa-solid fa-calendar-check"></i> Quản lý Lịch hẹn</a></li>
            <li><a href="#"><i class="fa-solid fa-users"></i> Đăng ký Khách mới</a></li>
            <li><a href="#"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn & Thuốc</a></li>
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
            <h2>Quản lý Lịch hẹn trong ngày</h2>
            <a href="${pageContext.request.contextPath}/staff/booking" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Tạo lịch hẹn Mới</a>
        </div>

        <c:if test="${not empty sessionScope.message}">
            <div style="background: #D1FAE5; color: #059669; padding: 15px; border-radius: 8px; margin-top: 15px;">
                <i class="fa-solid fa-circle-check"></i> ${sessionScope.message}
                <% session.removeAttribute("message"); %>
            </div>
        </c:if>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Khách hàng</th>
                        <th>Dịch vụ yêu cầu</th>
                        <th>Bác sĩ Đảm nhận</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
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
                                <span class="badge badge-${apt.status.toLowerCase()}">${apt.status}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${apt.status == 'PENDING'}">
                                        <!-- Form Duyệt Lịch -->
                                        <form action="${pageContext.request.contextPath}/staff/dashboard" method="POST" style="display: inline-block; margin-right: 5px;">
                                            <input type="hidden" name="action" value="confirm">
                                            <input type="hidden" name="id" value="${apt.id}">
                                            <button type="submit" class="btn btn-primary" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">Duyệt</button>
                                        </form>
                                        
                                        <!-- Form Huỷ Lịch -->
                                        <form action="${pageContext.request.contextPath}/staff/dashboard" method="POST" style="display: inline-block;">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="id" value="${apt.id}">
                                            <button type="submit" class="btn btn-primary" style="background: transparent; color: var(--danger); border: 1px solid var(--danger); padding: 0.4rem 0.8rem; font-size: 0.85rem;" onclick="return confirm('Bạn chắc chắn muốn hủy lịch này?');">Hủy</button>
                                        </form>
                                    </c:when>
                                    <c:when test="${apt.status == 'CONFIRMED'}">
                                        <button class="btn btn-primary" style="background: var(--light); color: var(--gray); cursor: not-allowed; padding: 0.4rem 0.8rem; font-size: 0.85rem;">Đã Check-in</button>
                                    </c:when>
                                    <c:when test="${apt.status == 'COMPLETED'}">
                                        <a href="${pageContext.request.contextPath}/staff/billing?apt_id=${apt.id}" class="btn btn-primary" style="background: #10B981; border: 1px solid #10B981; padding: 0.4rem 0.8rem; font-size: 0.85rem;"><i class="fa-solid fa-file-invoice-dollar"></i> Thanh Toán</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--gray); font-size: 0.9rem;">Không khả dụng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr><td colspan="6" style="text-align: center; color: var(--gray); padding: 2rem;">Chưa có lịch hẹn nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
