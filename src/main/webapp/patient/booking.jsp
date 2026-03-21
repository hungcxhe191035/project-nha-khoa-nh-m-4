<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lịch khám | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .booking-container { max-width: 800px; margin: 6rem auto 3rem auto; padding: 0 20px; }
        .booking-card { background: white; padding: 2.5rem; border-radius: 12px; box-shadow: var(--shadow-md); }
        .step-title { margin-bottom: 1.5rem; color: var(--primary); border-bottom: 2px solid var(--light); padding-bottom: 0.5rem; }
    </style>
</head>
<body>

    <nav class="glass" style="background: var(--primary);">
        <a href="${pageContext.request.contextPath}/" class="logo" style="color: white;">
            <i class="fa-solid fa-tooth"></i> SmileCare
        </a>
        <div class="actions">
            <span style="color: white; margin-right: 1.5rem; font-weight: 500;">Xin chào, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/patient/profile" class="btn btn-primary" style="background: white; color: var(--primary);">Hồ sơ của tôi</a>
        </div>
    </nav>

    <div class="booking-container">
        <div class="booking-card">
            <h1 style="text-align: center; margin-bottom: 2rem;">Đăng ký lịch hẹn khám</h1>
            
            <c:if test="${not empty message}">
                <div style="background-color: ${msgType == 'success' ? '#D1FAE5' : '#FEE2E2'}; 
                            color: ${msgType == 'success' ? '#059669' : '#DC2626'}; 
                            padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center;">
                    ${message}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/patient/booking" method="POST" id="bookingForm">
                <input type="hidden" name="action" value="book">

                <h3 class="step-title"><i class="fa-solid fa-1"></i> Chọn Bác sĩ & Thời gian</h3>
                <div class="form-group">
                    <label>Bác sĩ yêu cầu</label>
                    <select name="doctor_id" id="doctorSelect" class="form-control" required onchange="fetchSchedules()">
                        <option value="">-- Chọn Bác sĩ --</option>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.id}">${doctor.fullName} (${doctor.role})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label>Ngày khám</label>
                    <input type="date" name="date" id="dateSelect" class="form-control" required onchange="fetchSchedules()">
                </div>
                
                <div class="form-group">
                    <label>Khung giờ (Chỉ hiển thị giờ còn trống)</label>
                    <select name="schedule_id" id="scheduleSelect" class="form-control" required disabled>
                        <option value="">-- Vui lòng chọn Bác sĩ và Ngày khám trước --</option>
                    </select>
                </div>
                <div id="loadingMsg" style="color: var(--primary); font-size: 0.9rem; display: none;">Đang tìm lịch trống...</div>

                <h3 class="step-title" style="margin-top: 2rem;"><i class="fa-solid fa-2"></i> Dịch vụ phát sinh (Tùy chọn)</h3>
                <div class="form-group">
                    <label>Bạn muốn làm dịch vụ gì? (Phụ thuộc chuyên môn Bác Sĩ Của Bạn)</label>
                    <select name="service_id" id="serviceSelect" class="form-control" required disabled>
                        <option value="">-- Vui lòng chọn Bác sĩ trước --</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 2rem; font-size: 1.2rem; padding: 1rem;">Hoàn tất Đặt lịch</button>
            </form>
        </div>
    </div>

    <script>
        // Set min date = today
        document.getElementById('dateSelect').min = new Date().toISOString().split("T")[0];

        function fetchSchedules() {
            const doctorId = document.getElementById('doctorSelect').value;
            const date = document.getElementById('dateSelect').value;
            const scheduleSelect = document.getElementById('scheduleSelect');
            const loadingMsg = document.getElementById('loadingMsg');

            if (doctorId && date) {
                scheduleSelect.disabled = true;
                loadingMsg.style.display = 'block';

                // Gửi Request POST tĩnh về BookingController (Không load lại trang)
                const formData = new URLSearchParams();
                formData.append('action', 'get_schedule');
                formData.append('doctor_id', doctorId);
                formData.append('date', date);

                fetch('${pageContext.request.contextPath}/patient/booking', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData.toString()
                })
                .then(response => response.json())
                .then(data => {
                    // --- 1. ĐỔ DATA LỊCH (SCHEDULES) ---
                    let schedHtml = "<option value=''>-- Chọn khung giờ trống --</option>";
                    let hasSchedule = false;
                    
                    if (data.schedules && data.schedules.length > 0) {
                        data.schedules.forEach(s => {
                            schedHtml += "<option value='" + s.id + "'>" + s.text + "</option>";
                            hasSchedule = true;
                        });
                    }
                    
                    if (!hasSchedule) {
                        scheduleSelect.innerHTML = "<option value=''>Rất tiếc! Bác sĩ đã kín lịch vào ngày này.</option>";
                        scheduleSelect.disabled = true;
                    } else {
                        scheduleSelect.innerHTML = schedHtml;
                        scheduleSelect.disabled = false;
                    }
                    
                    // --- 2. ĐỔ DATA DỊCH VỤ (SERVICES TƯƠNG ỨNG BÁC SĨ) ---
                    const serviceSelect = document.getElementById('serviceSelect');
                    let servHtml = "<option value=''>-- Chọn dịch vụ --</option>";
                    
                    if (data.services && data.services.length > 0) {
                        data.services.forEach(s => {
                            servHtml += "<option value='" + s.id + "'>" + s.text + "</option>";
                        });
                    }
                    serviceSelect.innerHTML = servHtml;
                    serviceSelect.disabled = false;

                    loadingMsg.style.display = 'none';
                })
                .catch(error => {
                    console.error('Error fetching schedules:', error);
                    loadingMsg.style.display = 'none';
                    alert("Lỗi kết nối khi tải lịch!");
                });
            } else {
                scheduleSelect.innerHTML = "<option value=''>-- Vui lòng chọn Bác sĩ và Ngày khám trước --</option>";
                scheduleSelect.disabled = true;
            }
        }
    </script>
</body>
</html>
