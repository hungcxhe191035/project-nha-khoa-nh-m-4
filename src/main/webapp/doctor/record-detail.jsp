<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Bệnh Án | SmileCare Doctor</title>
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
        .record-container { background: white; border-radius: 12px; box-shadow: var(--shadow-sm); overflow: hidden; margin-top: 1.5rem; padding: 2rem; }
        
        .section-title { font-size: 1.1rem; color: var(--dark); font-weight: 600; margin-bottom: 1rem; border-bottom: 2px solid var(--light); padding-bottom: 0.5rem; margin-top: 2rem; }
        .data-table { width: 100%; border-collapse: collapse; margin-bottom: 1rem; }
        .data-table th, .data-table td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--light); }
        .data-table th { background: #f8fafc; font-weight: 600; }
        
        .header-info { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; background: #F8FAFC; padding: 1.5rem; border-radius: 8px; border: 1px solid #E2E8F0; }
        .info-group { display: flex; flex-direction: column; gap: 0.3rem; }
        .info-label { font-size: 0.85rem; color: var(--gray); font-weight: 500; text-transform: uppercase; }
        .info-value { font-size: 1rem; color: var(--dark); font-weight: 600; }
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
                <h2>Chi tiết Bệnh Án & Đơn Thuốc người bệnh</h2>
                <p style="color: var(--gray);">Xem lại chẩn đoán và thuốc do khám bệnh.</p>
            </div>
            <a href="${pageContext.request.contextPath}/doctor/history" class="btn btn-primary" style="background: white; color: var(--danger); border: 1px solid var(--danger);">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="record-container">
            <div class="header-info">
                <div class="info-group">
                    <span class="info-label">Bệnh nhân</span>
                    <span class="info-value">${appointment.patientName}</span>
                </div>
                <div class="info-group">
                    <span class="info-label">Mã lịch hẹn / Ngày khám</span>
                    <span class="info-value">#${appointment.id} - ${appointment.scheduleDate}</span>
                </div>
                <div class="info-group" style="grid-column: span 2;">
                    <span class="info-label">Kết Luận Chẩn Đoán Của Bác Sĩ</span>
                    <span class="info-value" style="color: #DC2626;">${record.diagnosis}</span>
                </div>
            </div>

            <div class="section-title">Dịch Vụ Đã Chỉ ĐịnhThêm</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Tên dịch vụ</th>
                        <th>Danh mục</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="srv" items="${recordServices}">
                        <tr>
                            <td>${srv.serviceName}</td>
                            <td><span style="background: #E0E7FF; color: #4338CA; padding: 0.2rem 0.6rem; border-radius: 12px; font-size: 0.8rem;">${srv.serviceCategory}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recordServices}">
                        <tr><td colspan="2" style="text-align: center; color: var(--gray);">Không có dịch vụ phát sinh thêm.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <div class="section-title">Đơn Thuốc Đã Kê</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Tên Thuốc</th>
                        <th style="text-align: center;">Số lượng kê</th>
                        <th style="text-align: center;">Đã báo thanh toán?</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="presc" items="${prescriptions}">
                        <tr>
                            <td><strong>${presc.medicineName}</strong> (${presc.medicineUnit})</td>
                            <td style="text-align: center;">${presc.prescribedQuantity}</td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${presc.paymentStatus == 'PAID'}">
                                        <span style="color: #16A34A; font-weight: 600;"><i class="fa-solid fa-check"></i> Khách đã mua ${presc.purchasedQuantity}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--gray);">Chờ mua thuốc</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty prescriptions}">
                        <tr><td colspan="3" style="text-align: center; color: var(--gray);">Không kê đơn thuốc cho bệnh nhân này.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
