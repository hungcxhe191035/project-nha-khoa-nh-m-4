<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Profile | Nha Khoa</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body style="background: #f8fafc;">

    <nav class="glass" style="position: relative; background: var(--primary);">
        <a href="${pageContext.request.contextPath}/" class="logo" style="color: white;">
            <i class="fa-solid fa-tooth"></i>
            SmileCare Patient
        </a>
        <div class="actions">
            <span style="color: white; margin-right: 1.5rem; font-weight: 500;">Xin chào, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background: white; color: var(--primary);">Đăng xuất</a>
        </div>
    </nav>

    <div style="max-width: 1000px; margin: 3rem auto; padding: 0 1.5rem;">
        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem;">
            
            <!-- Thông tin cá nhân -->
            <div style="background: white; padding: 2rem; border-radius: 12px; box-shadow: var(--shadow-sm); height: fit-content;">
                <div style="text-align: center; margin-bottom: 2rem;">
                    <div style="width: 100px; height: 100px; background: #E0E7FF; color: var(--primary); border-radius: 50%; font-size: 3rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem auto;">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <h2 style="color: var(--dark);">${sessionScope.user.fullName}</h2>
                    <p style="color: var(--gray);">Thành viên Bạc</p>
                </div>

                <div style="margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--light);">
                    <p style="color: var(--gray); font-size: 0.9rem;">Số điện thoại</p>
                    <p style="font-weight: 500;">${sessionScope.user.phone}</p>
                </div>
                <div style="margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--light);">
                    <p style="color: var(--gray); font-size: 0.9rem;">Email</p>
                    <p style="font-weight: 500;">${sessionScope.user.email}</p>
                </div>
                
                <a href="${pageContext.request.contextPath}/patient/booking" class="btn btn-primary" style="width: 100%; text-align: center; margin-top: 1rem;">Đặt lịch khám mới</a>
            </div>

            <!-- Lịch sử khám -->
            <div>
                <h2 style="color: var(--dark); margin-bottom: 1.5rem;">Lịch sử khám bệnh & Khóa hẹn</h2>

                <c:if test="${empty appointments}">
                     <div style="background: white; padding: 2rem; border-radius: 12px; text-align: center; color: var(--gray);">
                        <i class="fa-solid fa-calendar-xmark" style="font-size: 3rem; margin-bottom: 1rem; color: #cbd5e1;"></i>
                        <p>Bạn chưa có lịch hẹn nào lưu trong hệ thống.</p>
                     </div>
                </c:if>

                <c:forEach var="apt" items="${appointments}">
                    <c:choose>
                        <%-- Block Lịch Sắp Tới --%>
                        <c:when test="${apt.status == 'PENDING' || apt.status == 'CONFIRMED'}">
                            <div style="background: white; padding: 1.5rem; border-radius: 12px; box-shadow: var(--shadow-sm); margin-bottom: 1.5rem; border-left: 4px solid var(--primary);">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                    <h3 style="color: var(--primary); font-size: 1.1rem;"><i class="fa-solid fa-clock"></i> Lịch sắp tới</h3>
                                    
                                    <c:choose>
                                        <c:when test="${apt.status == 'PENDING'}">
                                            <span style="background: #FEF3C7; color: #D97706; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; font-weight: 600;">Chờ xác nhận</span>
                                        </c:when>
                                        <c:when test="${apt.status == 'CONFIRMED'}">
                                            <span style="background: #D1FAE5; color: #059669; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; font-weight: 600;">Đã xếp lịch (Đến khám)</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 0.5rem;">
                                    <p><strong>Dịch vụ yêu cầu:</strong> ${apt.serviceName}</p>
                                    <p><strong>Thời gian:</strong> ${apt.scheduleTime} - Ngày ${apt.scheduleDate}</p>
                                    <p><strong>Bác sĩ phụ trách:</strong> ${apt.doctorName}</p>
                                </div>
                            </div>
                        </c:when>

                        <%-- Block Lịch Đã Khám --%>
                        <c:when test="${apt.status == 'COMPLETED'}">
                            <div style="background: white; padding: 1.5rem; border-radius: 12px; box-shadow: var(--shadow-sm); border: 1px solid var(--light); margin-bottom: 1rem;">
                                <h3 style="color: var(--dark); font-size: 1.1rem; margin-bottom: 1rem; border-bottom: 1px solid var(--light); padding-bottom: 0.5rem;">
                                    <i class="fa-solid fa-clock-rotate-left"></i> Đã hoàn thành (Ngày ${apt.scheduleDate})
                                </h3>
                                
                                <div style="display: flex; flex-direction: column; gap: 0.5rem;">
                                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                        <p><strong>Dịch vụ:</strong> ${apt.serviceName}</p>
                                        <span style="color: var(--secondary); font-weight: 600;">Đã thanh toán</span>
                                    </div>
                                    <p><strong>Bác sĩ:</strong> ${apt.doctorName}</p>
                                    <!-- Xem chi tiết kết quả khám (Giai đoạn sau) -->
                                    <a href="#" style="color: var(--primary); font-size: 0.9rem; text-decoration: underline;">Xem Toa thuốc & Khám</a>
                                </div>
                            </div>
                        </c:when>
                        
                        <%-- Block Huỷ Lịch --%>
                        <c:when test="${apt.status == 'CANCELLED'}">
                            <div style="background: #f8fafc; padding: 1rem 1.5rem; border-radius: 12px; border: 1px dashed #cbd5e1; margin-bottom: 1rem; opacity: 0.7;">
                                <p style="margin: 0;">Lịch khám <strong>${apt.serviceName}</strong> ngày <strong>${apt.scheduleDate}</strong> đã bị Hủy.</p>
                            </div>
                        </c:when>
                    </c:choose>
                </c:forEach>

            </div>
        </div>
    </div>

</body>
</html>
