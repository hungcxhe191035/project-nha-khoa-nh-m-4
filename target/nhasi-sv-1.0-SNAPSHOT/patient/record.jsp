<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Bệnh Án & Toa Thuốc | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .record-container { max-width: 900px; margin: 3rem auto; background: white; border-radius: 12px; box-shadow: var(--shadow-sm); overflow: hidden; padding: 2rem; }
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
<body style="background: #f8fafc;">

    <nav class="glass" style="position: relative; background: var(--primary);">
        <a href="${pageContext.request.contextPath}/" class="logo" style="color: white;">
            <i class="fa-solid fa-tooth"></i>
            SmileCare Patient
        </a>
        <div class="actions">
            <span style="color: white; margin-right: 1.5rem; font-weight: 500;">Xin chào, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/patient/profile" class="btn btn-primary" style="background: white; color: var(--primary);"><i class="fa-solid fa-arrow-left"></i> Trở về Hồ sơ</a>
        </div>
    </nav>

    <div class="record-container">
        <div style="text-align: center; margin-bottom: 2rem;">
            <h2 style="color: var(--dark); margin-bottom: 0.5rem;"><i class="fa-solid fa-file-medical"></i> Chi Tiết Bệnh Án & Toa Thuốc</h2>
            <p style="color: var(--gray);">Ngày khám: ${appointment.scheduleDate} | Thời gian: ${appointment.scheduleTime}</p>
        </div>

        <div class="header-info">
            <div class="info-group">
                <span class="info-label">Bệnh nhân</span>
                <span class="info-value">${appointment.patientName}</span>
            </div>
            <div class="info-group">
                <span class="info-label">Bác sĩ phụ trách</span>
                <span class="info-value">${appointment.doctorName}</span>
            </div>
            <div class="info-group">
                <span class="info-label">Dịch vụ đăng ký</span>
                <span class="info-value">${appointment.serviceName}</span>
            </div>
            <div class="info-group">
                <span class="info-label">Chẩn đoán của Bác sĩ</span>
                <span class="info-value" style="color: #DC2626;">${record.diagnosis}</span>
            </div>
        </div>

        <div class="section-title">1. Dịch Vụ Khám & Điều Trị</div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Tên dịch vụ</th>
                    <th>Danh mục</th>
                    <th style="text-align: right;">Chi phí</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="srv" items="${services}">
                    <tr>
                        <td>${srv.serviceName}</td>
                        <td><span style="background: #E0E7FF; color: #4338CA; padding: 0.2rem 0.6rem; border-radius: 12px; font-size: 0.8rem;">${srv.serviceCategory}</span></td>
                        <td style="text-align: right; font-weight: 500;"><fmt:formatNumber value="${srv.price}" pattern="#,###"/> đ</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty services}">
                    <tr><td colspan="3" style="text-align: center; color: var(--gray);">Không có dịch vụ phát sinh.</td></tr>
                </c:if>
            </tbody>
        </table>

        <div class="section-title">2. Toa Thuốc</div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Tên Thuốc</th>
                    <th style="text-align: center;">Số lượng kê</th>
                    <th style="text-align: center;">Đã mua</th>
                    <th style="text-align: right;">Đơn giá</th>
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
                                    <span style="color: #16A34A; font-weight: 600;">${presc.purchasedQuantity}</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--gray);">0 (Chưa thanh toán)</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: right; font-weight: 500;"><fmt:formatNumber value="${presc.medicinePrice}" pattern="#,###"/> đ</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty prescriptions}">
                    <tr><td colspan="4" style="text-align: center; color: var(--gray);">Bác sĩ không kê đơn thuốc.</td></tr>
                </c:if>
            </tbody>
        </table>

        <div style="margin-top: 3rem; text-align: center;">
            <a href="${pageContext.request.contextPath}/patient/profile" class="btn btn-primary" style="background: white; color: var(--gray); border: 1px solid var(--light); width: 200px;">Đóng</a>
        </div>
    </div>

</body>
</html>
