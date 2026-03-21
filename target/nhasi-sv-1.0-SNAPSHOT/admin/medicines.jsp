<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Kho Thuốc | Admin SmileCare</title>
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
        
        .table-wrapper { background: white; border-radius: 12px; box-shadow: var(--shadow-sm); overflow: hidden; margin-top: 1.5rem; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 1rem 1.5rem; text-align: left; border-bottom: 1px solid var(--light); }
        .data-table th { background: #f8fafc; font-weight: 600; color: #334155; }
        .data-table tbody tr:hover { background: #f8fafc; }
        
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: white; margin: 10% auto; padding: 2rem; border-radius: 12px; width: 500px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; border-bottom: 1px solid var(--light); padding-bottom: 1rem; }
        .close { color: #aaa; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: black; }
    </style>
</head>
<body>

<div class="dashboard-container">
    <aside class="sidebar">
        <div class="system-branding">
            <i class="fa-solid fa-tooth"></i>
            <h3 style="margin:0; font-weight: 700;">SmileCare System</h3>
            <p style="margin-top: 0.2rem; font-size: 0.8rem; color: #94A3B8;">Quản Trị Viên (Admin)</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-pie"></i> Thống kê Doanh Thu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-user-shield"></i> Quản lý Nhân Sự</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/medicines" class="active"><i class="fa-solid fa-pills"></i> Kho Thuốc</a></li>
        </ul>

        <div style="position: absolute; bottom: 2rem; width: 212px;">
            <div style="padding: 1rem; background: #1E293B; border-radius: 8px; margin-bottom: 1rem;">
                <p style="font-weight: 600; margin: 0; color: white;">${sessionScope.user.fullName}</p>
                <span style="font-size: 0.8rem; color: #38BDF8;">Super Admin</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background: transparent; color: #F87171; border: 1px solid #F87171; width: 100%; text-align: center;">Đăng xuất</a>
        </div>
    </aside>

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2>Quản Lý Kho Thuốc & Vật Tư Y Tế</h2>
                <p style="color: var(--gray);">Cập nhật danh mục thuốc và số lượng tồn kho.</p>
            </div>
            <button class="btn btn-primary" onclick="openAddModal()"><i class="fa-solid fa-plus"></i> Thêm Thuốc Mới</button>
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
                        <th>Tên Thuốc</th>
                        <th>Đơn Vị</th>
                        <th>Đơn Giá Bán</th>
                        <th>Tồn Kho</th>
                        <th style="text-align: right;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${medicines}">
                        <tr>
                            <td style="color: var(--gray);">#${m.id}</td>
                            <td style="font-weight: 600; color: var(--dark);">${m.name}</td>
                            <td><span style="background: #E2E8F0; padding: 0.2rem 0.6rem; border-radius: 12px; font-size: 0.85rem;">${m.unit}</span></td>
                            <td><fmt:formatNumber value="${m.price}" pattern="#,###"/> đ</td>
                            <td>
                                <span style="font-weight: 600; color: ${m.stockQuantity < 50 ? '#DC2626' : '#059669'};">
                                    ${m.stockQuantity}
                                </span>
                            </td>
                            <td style="text-align: right;">
                                <button class="btn btn-primary" style="background: white; color: var(--primary); border: 1px solid var(--primary); padding: 0.4rem 0.8rem; font-size: 0.85rem; margin-right: 5px;" 
                                        onclick="openEditModal(${m.id}, '${m.name.replace('\'', '\\\'')}', '${m.unit}', ${m.price}, ${m.stockQuantity})">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </button>
                                
                                <form action="${pageContext.request.contextPath}/admin/medicines" method="POST" style="display: inline-block;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${m.id}">
                                    <button type="submit" class="btn btn-primary" style="background: #FEE2E2; color: #DC2626; border: 1px solid #FECACA; padding: 0.4rem 0.8rem; font-size: 0.85rem;" 
                                            onclick="return confirm('Bạn có chắc chắn muốn xóa thuốc này khỏi hệ thống?');">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty medicines}">
                        <tr><td colspan="6" style="text-align: center; color: var(--gray); padding: 2rem;">Chưa có dữ liệu thuốc nào trong kho.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<!-- Modal Form (Sử dụng chung cho Thêm Mới và Sửa) -->
<div id="medicineModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalTitle" style="margin: 0;">Thêm Thuốc Mới</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/medicines" method="POST">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="id" id="medId" value="">
            
            <div class="form-group" style="margin-bottom: 1rem;">
                <label style="display: block; font-weight: 500; margin-bottom: 0.5rem;">Tên Thuốc *</label>
                <input type="text" name="name" id="medName" class="form-control" required style="width: 100%; box-sizing: border-box;">
            </div>
            
            <div class="form-group" style="margin-bottom: 1rem;">
                <label style="display: block; font-weight: 500; margin-bottom: 0.5rem;">Đơn Vị Tính (VD: Viên, Vỉ, Hộp, Chai) *</label>
                <input type="text" name="unit" id="medUnit" class="form-control" required style="width: 100%; box-sizing: border-box;">
            </div>
            
            <div class="form-group" style="margin-bottom: 1rem;">
                <label style="display: block; font-weight: 500; margin-bottom: 0.5rem;">Đơn Giá Bán (VNĐ) *</label>
                <input type="number" name="price" id="medPrice" class="form-control" required min="0" style="width: 100%; box-sizing: border-box;">
            </div>
            
            <div class="form-group" style="margin-bottom: 1.5rem;">
                <label style="display: block; font-weight: 500; margin-bottom: 0.5rem;">Số Lượng Nhập Kho *</label>
                <input type="number" name="stock_quantity" id="medStock" class="form-control" required min="0" style="width: 100%; box-sizing: border-box;">
            </div>
            
            <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                <button type="button" class="btn btn-primary" style="background: white; color: var(--gray); border: 1px solid var(--light);" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn btn-primary" id="btnSubmit">Lưu Thông Tin</button>
            </div>
        </form>
    </div>
</div>

<script>
    const modal = document.getElementById("medicineModal");
    
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Thêm Thuốc Mới';
        document.getElementById('formAction').value = 'add';
        document.getElementById('medId').value = '';
        document.getElementById('medName').value = '';
        document.getElementById('medUnit').value = '';
        document.getElementById('medPrice').value = '';
        document.getElementById('medStock').value = '';
        document.getElementById('btnSubmit').innerText = 'Lưu Kho';
        
        modal.style.display = "block";
    }
    
    function openEditModal(id, name, unit, price, stock) {
        document.getElementById('modalTitle').innerText = 'Chỉnh Sửa Thuốc #' + id;
        document.getElementById('formAction').value = 'update';
        document.getElementById('medId').value = id;
        document.getElementById('medName').value = name;
        document.getElementById('medUnit').value = unit;
        document.getElementById('medPrice').value = price;
        document.getElementById('medStock').value = stock;
        document.getElementById('btnSubmit').innerText = 'Cập Nhật';
        
        modal.style.display = "block";
    }
    
    function closeModal() {
        modal.style.display = "none";
    }
    
    // Đóng khi click ra ngoài modal
    window.onclick = function(event) {
        if (event.target == modal) {
            closeModal();
        }
    }
</script>

</body>
</html>
