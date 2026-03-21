<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Hóa Đơn | SmileCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .billing-container { max-width: 900px; margin: 3rem auto; background: white; border-radius: 12px; box-shadow: var(--shadow-md); overflow: hidden; }
        .billing-header { background: #0F172A; color: white; padding: 2rem; display: flex; justify-content: space-between; align-items: center;}
        .billing-body { padding: 2rem; }
        
        .section-title { font-size: 1.1rem; color: var(--dark); font-weight: 600; margin-bottom: 1rem; border-bottom: 2px solid var(--light); padding-bottom: 0.5rem; }
        
        .data-table { width: 100%; border-collapse: collapse; margin-bottom: 2rem; }
        .data-table th, .data-table td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--light); }
        .data-table th { background: #f8fafc; font-weight: 600; }
        
        .summary-box { background: #F8FAFC; padding: 1.5rem; border-radius: 8px; text-align: right; margin-top: 2rem; border: 1px solid #E2E8F0; }
        .total-amount { font-size: 1.5rem; font-weight: 700; color: #DC2626; margin-top: 0.5rem; }
    </style>
</head>
<body style="background: #f1f5f9;">

<div class="billing-container">
    <div class="billing-header">
        <div>
            <h2 style="margin:0 0 0.5rem 0;"><i class="fa-solid fa-file-invoice-dollar"></i> Chi Tiết Hóa Đơn Khám Bệnh</h2>
            <p style="margin:0; opacity: 0.8;">Mã bệnh án: #${record.id} | Chẩn đoán: ${record.diagnosis}</p>
        </div>
        <div>
            <span style="background: #FEF3C7; color: #D97706; padding: 0.5rem 1rem; border-radius: 20px; font-weight: 600; font-size: 0.9rem;">CHƯA THANH TOÁN</span>
        </div>
    </div>

    <div class="billing-body">
        <form action="${pageContext.request.contextPath}/staff/billing" method="POST" id="billingForm">
            <input type="hidden" name="record_id" value="${record.id}">
            
            <div style="background: #F0FDF4; border-left: 4px solid #16A34A; padding: 1rem; margin-bottom: 2rem; border-radius: 4px;">
                <i class="fa-solid fa-check"></i> <strong>Hoàn tất khám bệnh:</strong> Phiếu ghi nhận từ Hệ thống Bác Sĩ.
            </div>

            <!-- PHẦN 1: DỊCH VỤ -->
            <div class="section-title">1. Phí Dịch Vụ Khám & Điều trị</div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Tên Dịch vụ</th>
                        <th>Danh mục</th>
                        <th style="text-align: right;">Thành tiền</th>
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
                        <tr><td colspan="3" style="text-align: center; color: var(--gray);">Bác sĩ không kê thêm dịch vụ phụ phí.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <!-- PHẦN 2: ĐƠN THUỐC -->
            <div class="section-title">2. Đơn Thuốc (Khách được quyền mua 1 phần)</div>
            <p style="font-size: 0.9rem; color: var(--gray); margin-bottom: 1rem;">Thuốc được bán theo yêu cầu bệnh nhân. Lễ tân điều chỉnh lại cột <strong>"Thực Mua"</strong> để Cổng tính tiền tự động khấu trừ.</p>
            
            <table class="data-table" id="medTable">
                <thead>
                    <tr>
                        <th>Tên Thuốc</th>
                        <th>Đơn giá</th>
                        <th style="text-align: center;">SL Kê toa</th>
                        <th style="width: 120px;">Thực Mua</th>
                        <th style="text-align: right;">Tổng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="presc" items="${prescriptions}">
                        <tr>
                            <td>
                                <strong>${presc.medicineName}</strong> (${presc.medicineUnit})
                                <input type="hidden" name="prescription_ids" value="${presc.id}">
                                <input type="hidden" name="medicine_ids" value="${presc.medicineId}">
                            </td>
                            <td><fmt:formatNumber value="${presc.medicinePrice}" pattern="#,###"/> đ</td>
                            <td style="text-align: center; color: var(--gray);">${presc.prescribedQuantity}</td>
                            <td>
                                <input type="number" name="purchased_qtys" class="form-control" style="margin: 0; padding: 0.4rem;" value="${presc.prescribedQuantity}" min="0" max="${presc.prescribedQuantity}" data-price="${presc.medicinePrice}" onkeyup="calcTotal()" onchange="calcTotal()">
                            </td>
                            <td style="text-align: right; font-weight: 600; color: var(--dark);" class="row-total">
                                <fmt:formatNumber value="${presc.totalPrice}" pattern="#,###"/> đ
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty prescriptions}">
                        <tr><td colspan="5" style="text-align: center; color: var(--gray);">Bệnh nhân không có đơn thuốc.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <div class="summary-box">
                <div style="color: var(--gray); margin-bottom: 0.5rem;">Cộng tiền Dịch vụ: <strong style="color: var(--dark);"><fmt:formatNumber value="${totalServicePrice}" pattern="#,###"/> đ</strong></div>
                <div style="color: var(--gray); margin-bottom: 0.5rem;">Cộng tiền Thuốc: <strong style="color: var(--dark);" id="medTotalDisplay"><fmt:formatNumber value="${maxPrescriptionPrice}" pattern="#,###"/> đ</strong></div>
                <hr style="border: none; border-top: 1px dashed #CBD5E1; margin: 1rem 0;">
                <div style="font-size: 1.1rem; text-transform: uppercase; font-weight: 600;">Tổng Thanh Toán</div>
                <div class="total-amount" id="finalTotalDisplay">
                    <fmt:formatNumber value="${totalServicePrice + maxPrescriptionPrice}" pattern="#,###"/> VNĐ
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-primary" style="background: white; color: var(--gray); border: 1px solid var(--light); text-align: center;"><i class="fa-solid fa-arrow-left"></i> Trở Lại</a>
                <button type="submit" class="btn btn-primary" style="flex: 1; font-size: 1.05rem;" onclick="return confirm('Xác nhận Thu Tiền và IN HÓA ĐƠN? Quá trình này sẽ trừ Kho Thuốc của Phòng Khám.');"><i class="fa-solid fa-print"></i> Xác nhận Thanh toán & Trừ Kho</button>
            </div>
        </form>
    </div>
</div>

<script>
    const fixedServicePrice = ${totalServicePrice != null ? totalServicePrice : 0};

    function calcTotal() {
        let medTotal = 0;
        const qtys = document.getElementsByName('purchased_qtys');
        const rowTotals = document.getElementsByClassName('row-total');
        
        for (let i = 0; i < qtys.length; i++) {
            let qty = parseInt(qtys[i].value) || 0;
            let price = parseFloat(qtys[i].getAttribute('data-price')) || 0;
            let rowSum = qty * price;
            medTotal += rowSum;
            
            // Cập nhật từng hàng
            rowTotals[i].innerText = new Intl.NumberFormat('vi-VN').format(rowSum) + ' đ';
        }

        // Cập nhật bảng tổng
        document.getElementById('medTotalDisplay').innerText = new Intl.NumberFormat('vi-VN').format(medTotal) + ' đ';
        document.getElementById('finalTotalDisplay').innerText = new Intl.NumberFormat('vi-VN').format(fixedServicePrice + medTotal) + ' VNĐ';
    }
</script>

</body>
</html>
