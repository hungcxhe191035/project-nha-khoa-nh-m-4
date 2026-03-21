<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Viết Bệnh Án | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .record-container { max-width: 900px; margin: 3rem auto; background: white; border-radius: 12px; box-shadow: var(--shadow-md); overflow: hidden; }
        .record-header { background: var(--primary); color: white; padding: 2rem; }
        .record-body { padding: 2rem; }
        
        .form-section { margin-bottom: 2.5rem; border: 1px solid var(--light); border-radius: 8px; padding: 1.5rem; }
        .form-section-title { font-size: 1.1rem; color: var(--dark); font-weight: 600; margin-bottom: 1rem; border-bottom: 2px solid var(--light); padding-bottom: 0.5rem; display: flex; align-items: center; justify-content: space-between; }
        
        .dynamic-row { display: flex; gap: 1rem; align-items: center; margin-bottom: 1rem; background: #f8fafc; padding: 1rem; border-radius: 6px; }
        .dynamic-row input, .dynamic-row select { margin-bottom: 0; }
        
        .btn-add { background: #E0E7FF; color: var(--primary); padding: 0.5rem 1rem; border-radius: 6px; font-weight: 500; cursor: pointer; border: none; font-size: 0.9rem; }
        .btn-add:hover { background: var(--primary); color: white; }
        .btn-remove { background: #FEE2E2; color: var(--danger); border: none; padding: 0.5rem; border-radius: 6px; cursor: pointer; }
    </style>
</head>
<body style="background: #f1f5f9;">

<div class="record-container">
    <div class="record-header">
        <h2 style="margin:0 0 0.5rem 0;"><i class="fa-solid fa-stethoscope"></i> Lập Hồ Sơ Bệnh Án</h2>
        <p style="margin:0; opacity: 0.9;">Mã Lịch Hẹn: #${apt_id}</p>
    </div>

    <div class="record-body">
        <form action="${pageContext.request.contextPath}/doctor/record" method="POST" id="recordForm">
            <input type="hidden" name="apt_id" value="${apt_id}">
            
            <c:if test="${not empty error}">
                <div class="error-msg" style="margin-bottom: 1.5rem;">${error}</div>
            </c:if>

            <!-- PHẦN 1: CHẨN ĐOÁN -->
            <div class="form-section">
                <div class="form-section-title">1. Kết Luận Chẩn Đoán <span style="color:red">*</span></div>
                <textarea name="diagnosis" class="form-control" rows="4" placeholder="Nhập triệu chứng và kết luận bệnh lý..." required></textarea>
            </div>

            <!-- PHẦN 2: DỊCH VỤ PHÁT SINH -->
            <div class="form-section" id="services-section">
                <div class="form-section-title">
                    <span>2. Chỉ định Dịch Vụ Mới</span>
                    <button type="button" class="btn-add" onclick="addServiceRow()"><i class="fa-solid fa-plus"></i> Thêm DV</button>
                </div>
                <p style="font-size: 0.9rem; color: var(--gray);">Chọn các dịch vụ bác sĩ làm thêm trong ca khám này để lễ tân cập nhật Hóa Đơn.</p>
                <div id="service-list">
                    <!-- Dòng chọn Dịch vụ Render bằng JS -->
                </div>
            </div>

            <!-- PHẦN 3: KÊ ĐƠN THUỐC -->
            <div class="form-section" id="medicines-section">
                <div class="form-section-title">
                    <span>3. Đơn Thuốc</span>
                    <button type="button" class="btn-add" onclick="addMedicineRow()"><i class="fa-solid fa-plus"></i> Thêm Thuốc</button>
                </div>
                <div id="medicine-list">
                    <!-- Dòng chọn Thuốc Render bằng JS -->
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-primary" style="background: white; color: var(--gray); border: 1px solid var(--light); text-align: center;">Hủy & Quay Về</a>
                <button type="submit" class="btn btn-primary" style="flex: 1;"><i class="fa-solid fa-check"></i> Hoàn Tất Ca Khám & Chuyển Lễ Tân</button>
            </div>
        </form>
    </div>
</div>

<!-- DỮ LIỆU JSON ĐỂ JAVASCRIPT ĐỌC -->
<script>
    // Nhúng data từ Java sang JS Variable dưới dạng mảng JSON
    const servicesData = [
        <c:forEach var="s" items="${servicesList}">
            { id: ${s.id}, name: "${s.name} - ${s.price}đ" },
        </c:forEach>
    ];

    const medicinesData = [
        <c:forEach var="m" items="${medicinesList}">
            { id: ${m.id}, name: "${m.name} (${m.unit}) - Tồn kho: ${m.stockQuantity}" },
        </c:forEach>
    ];

    // --- LOGIC THÊM DỊCH VỤ ---
    function addServiceRow() {
        const container = document.getElementById('service-list');
        const row = document.createElement('div');
        row.className = 'dynamic-row';
        
        let selectHTML = `<select name="service_ids" class="form-control" style="flex: 1;" required>
                            <option value="">-- Chọn Dịch vụ --</option>`;
        servicesData.forEach(s => { selectHTML += `<option value="` + s.id + `">` + s.name + `</option>`; });
        selectHTML += `</select>`;

        row.innerHTML = selectHTML + `<button type="button" class="btn-remove" onclick="this.parentElement.remove()"><i class="fa-solid fa-trash"></i></button>`;
        container.appendChild(row);
    }

    // --- LOGIC THÊM THUỐC ---
    function addMedicineRow() {
        const container = document.getElementById('medicine-list');
        const row = document.createElement('div');
        row.className = 'dynamic-row';
        
        let selectHTML = `<select name="medicine_ids" class="form-control" style="flex: 2;" required>
                            <option value="">-- Chọn Thuốc điều trị --</option>`;
        medicinesData.forEach(m => { selectHTML += `<option value="` + m.id + `">` + m.name + `</option>`; });
        selectHTML += `</select>`;

        row.innerHTML = selectHTML + 
            `<input type="number" name="quantities" class="form-control" style="flex: 1;" placeholder="Số lượng" min="1" required>` +
            `<button type="button" class="btn-remove" onclick="this.parentElement.remove()"><i class="fa-solid fa-trash"></i></button>`;
        container.appendChild(row);
    }
</script>

</body>
</html>
