<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Tại Quầy | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .booking-card { max-width: 600px; margin: 4rem auto; background: white; padding: 2.5rem; border-radius: 12px; box-shadow: var(--shadow-md); }
        .form-title { font-size: 1.5rem; font-weight: 700; color: var(--primary); margin-bottom: 2rem; border-bottom: 2px solid var(--light); padding-bottom: 1rem; }
    </style>
</head>
<body style="background: #f1f5f9;">

<div class="booking-card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
        <h2 class="form-title" style="margin-bottom: 0; border: none; padding: 0;"><i class="fa-solid fa-calendar-plus"></i> Đặt Lịch Khách Vãng Lai</h2>
        <a href="${pageContext.request.contextPath}/staff/dashboard" style="color: var(--gray); text-decoration: none;"><i class="fa-solid fa-xmark fa-xl"></i></a>
    </div>
    
    <c:if test="${not empty message}">
        <div style="padding: 1rem; margin-bottom: 1.5rem; border-radius: 6px; background: ${msgType == 'success' ? '#D1FAE5' : '#FEE2E2'}; color: ${msgType == 'success' ? '#059669' : '#DC2626'};">
            ${message}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/staff/booking" method="POST">
        <input type="hidden" name="action" value="book">
        
        <div style="margin-bottom: 1.5rem;">
            <label style="display: block; font-weight: 500; margin-bottom: 0.5rem; color: var(--dark);">1. Chọn Bệnh Nhân <span style="color:red">*</span></label>
            <select name="patient_id" required class="form-control" style="width: 100%;">
                <option value="">-- Tìm Khách Hàng (Tên - SĐT) --</option>
                <c:forEach var="p" items="${patients}">
                    <option value="${p.id}">${p.fullName} - ${p.phone}</option>
                </c:forEach>
            </select>
            <div style="font-size: 0.85rem; margin-top: 0.5rem; color: var(--gray);"><i class="fa-solid fa-circle-info"></i> Lễ tân cần đăng ký User trước nếu là khách mới hoàn toàn.</div>
        </div>

        <div style="margin-bottom: 1.5rem;">
            <label style="display: block; font-weight: 500; margin-bottom: 0.5rem; color: var(--dark);">2. Chọn Bác Sĩ Cấp Cứu/Khám</label>
            <select name="doctor_id" id="doctor_id" required class="form-control" style="width: 100%;">
                <option value="">-- Chọn Bác sĩ --</option>
                <c:forEach var="d" items="${doctors}">
                    <option value="${d.id}">${d.fullName}</option>
                </c:forEach>
            </select>
        </div>

        <div style="margin-bottom: 2rem;">
            <label style="display: block; font-weight: 500; margin-bottom: 0.5rem; color: var(--dark);">3. Ngày Khám</label>
            <input type="date" id="booking_date" class="form-control" required style="width: 100%; box-sizing: border-box;">
        </div>

        <button type="button" class="btn btn-primary" onclick="loadSchedules()" style="width: 100%; margin-bottom: 1.5rem; padding: 0.8rem; background: #0F172A; border-color: #0F172A;">
            <i class="fa-solid fa-magnifying-glass-chart"></i> Tra Cứu Khung Giờ Trống
        </button>

        <!-- Trạng thái ẩn, sẽ bung ra khi tìm thấy lịch -->
        <div id="schedule_section" style="display:none; padding: 1.5rem; background: #F8FAFC; border-radius: 8px; border: 1px dashed #CBD5E1;">
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-weight: 500; margin-bottom: 0.5rem; color: var(--dark);">4. Khung Giờ Khám</label>
                <select name="schedule_id" id="schedule_id" class="form-control" required style="width: 100%;"></select>
            </div>

            <div style="margin-bottom: 2rem;">
                <label style="display: block; font-weight: 500; margin-bottom: 0.5rem; color: var(--dark);">5. Dịch Vụ Sơ Bộ</label>
                <select name="service_id" id="service_id" class="form-control" required style="width: 100%;"></select>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; background: #10B981; border: none; padding: 0.8rem; font-size: 1.1rem; box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.4);">
                <i class="fa-solid fa-check"></i> Chốt Lịch Hẹn Ngay
            </button>
        </div>
    </form>
</div>

<script>
    function loadSchedules() {
        const docId = document.getElementById('doctor_id').value;
        const date = document.getElementById('booking_date').value;
        if (!docId || !date) {
            alert('Vui lòng chọn Bác sĩ và Ngày khám!'); return;
        }

        const formData = new URLSearchParams();
        formData.append('action', 'get_schedule');
        formData.append('doctor_id', docId);
        formData.append('date', date);

        fetch('${pageContext.request.contextPath}/staff/booking', {
            method: 'POST',
            body: formData,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => res.json())
        .then(data => {
            const schSelect = document.getElementById('schedule_id');
            const srvSelect = document.getElementById('service_id');
            schSelect.innerHTML = '<option value="">-- Chọn khung giờ --</option>';
            srvSelect.innerHTML = '<option value="">-- Chọn dịch vụ --</option>';

            if (data.schedules.length === 0) {
                alert('Rất tiếc! Bác sĩ không có lịch làm việc hoặc đã kín lịch vào ngày này.');
                document.getElementById('schedule_section').style.display = 'none';
                return;
            }

            data.schedules.forEach(s => {
                schSelect.innerHTML += '<option value="' + s.id + '">' + s.text + '</option>';
            });
            data.services.forEach(s => {
                srvSelect.innerHTML += '<option value="' + s.id + '">' + s.text + '</option>';
            });

            document.getElementById('schedule_section').style.display = 'block';
        })
        .catch(err => alert('Lỗi tải dữ liệu nội bộ! Xem Console.'));
    }
</script>

</body>
</html>
