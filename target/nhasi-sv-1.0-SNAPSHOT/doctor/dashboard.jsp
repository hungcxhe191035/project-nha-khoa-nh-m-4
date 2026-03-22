<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Workspace | SmileCare</title>
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
        .badge-confirmed { background: #D1FAE5; color: #059669; }
        .badge-completed { background: #E0E7FF; color: #4338CA; }
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
            <li><a href="${pageContext.request.contextPath}/doctor/dashboard" class="active"><i class="fa-solid fa-list-check"></i> Ca Khám Của Tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/doctor/history"><i class="fa-solid fa-file-medical"></i> Lịch Sử Bệnh Án</a></li>
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
                <h2>Danh sách ca khám trong ngày</h2>
                <p style="color: var(--gray);">Chỉ hiển thị các lịch Lễ Tân đã xác nhận và xếp ca.</p>
            </div>
        </div>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Bệnh nhân</th>
                        <th>Dịch vụ yêu cầu</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
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
                                <strong style="color: var(--primary);">${apt.scheduleTime}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--gray);">${apt.scheduleDate}</span>
                            </td>
                            <td>
                                <span class="badge badge-${apt.status.toLowerCase()}">${apt.status == 'CONFIRMED' ? 'Chờ Khám' : 'Đã Khám Xong'}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${apt.status == 'CONFIRMED'}">
                                        <c:choose>
                                            <c:when test="${apt.examineReady}">
                                                <a href="${pageContext.request.contextPath}/doctor/examination?id=${apt.id}" class="btn btn-primary" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;"><i class="fa-solid fa-stethoscope"></i> Viết Bệnh Án</a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn" style="background: var(--light); color: var(--gray); padding: 0.4rem 0.8rem; font-size: 0.85rem; border: none; cursor: not-allowed; border-radius: 8px;" title="Chưa tới giờ hẹn"><i class="fa-solid fa-clock"></i> Chưa Đến Giờ</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/doctor/examination?id=${apt.id}" class="btn btn-primary" style="background: var(--light); color: var(--gray); padding: 0.4rem 0.8rem; font-size: 0.85rem;">Xem Bệnh Án</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty appointments}">
                        <tr><td colspan="5" style="text-align: center; color: var(--gray); padding: 3rem;"><i class="fa-solid fa-mug-hot" style="font-size: 2rem; margin-bottom: 1rem; color: #cbd5e1;"></i><br>Bác sĩ đang rảnh. Chưa có ca xếp!</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
