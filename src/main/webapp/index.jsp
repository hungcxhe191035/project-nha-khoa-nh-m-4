<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nha Khoa Premium | Chăm sóc nụ cười của bạn</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <nav class="glass">
        <a href="${pageContext.request.contextPath}/" class="logo">
            <i class="fa-solid fa-tooth"></i>
            SmileCare
        </a>
        <ul>
            <li><a href="#services">Dịch vụ</a></li>
            <li><a href="#about">Về chúng tôi</a></li>
            <li><a href="#doctors">Bác sĩ</a></li>
        </ul>
        <div class="actions">
            <!-- Kiểm tra session User -->
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span style="font-weight: 500; margin-right: 15px;">Xin chào, ${sessionScope.user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="background-color: var(--danger);">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Đăng nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <header class="hero">
        <div class="hero-content">
            <h1>Chăm sóc nụ cười <span>toàn diện</span> và chuyên nghiệp</h1>
            <p>SmileCare cung cấp các dịch vụ nha khoa chất lượng cao với đội ngũ bác sĩ giàu kinh nghiệm và trang thiết bị hiện đại.</p>
            
            <c:choose>
                <c:when test="${not empty sessionScope.user && sessionScope.user.role == 'PATIENT'}">
                    <a href="${pageContext.request.contextPath}/patient/booking" class="btn btn-primary" style="font-size: 1.2rem; padding: 1rem 2.5rem;">Đặt lịch ngay</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="font-size: 1.2rem; padding: 1rem 2.5rem;">Đăng nhập để Đặt lịch</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <section id="services" class="services">
        <h2 class="section-title">Dịch vụ của chúng tôi</h2>
        <div class="services-grid">
            
            <!-- Loop qua danh sách dịch vụ động lấy từ DB -->
            <c:forEach var="s" items="${services}">
                <div class="service-card">
                    <c:choose>
                        <c:when test="${s.category == 'Khám'}">
                            <i class="fa-solid fa-notes-medical" style="font-size: 2rem; color: var(--primary); margin-bottom: 1rem;"></i>
                        </c:when>
                        <c:when test="${s.category == 'Phẫu thuật'}">
                            <i class="fa-solid fa-tooth" style="font-size: 2rem; color: var(--primary); margin-bottom: 1rem;"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-wand-magic-sparkles" style="font-size: 2rem; color: var(--primary); margin-bottom: 1rem;"></i>
                        </c:otherwise>
                    </c:choose>
                    
                    <h3>${s.name}</h3>
                    <div class="price">
                        <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="VNĐ" groupingUsed="true"/>
                    </div>
                    <p>${s.description}</p>
                    <span style="font-size: 0.8rem; background: var(--light); padding: 2px 8px; border-radius: 4px; color: var(--gray);">${s.category}</span>
                </div>
            </c:forEach>
            
            <!-- Nếu DB trống (fallback an toàn) -->
            <c:if test="${empty services}">
                <p style="text-align: center; color: var(--gray); grid-column: 1/-1;">Đang cập nhật danh sách dịch vụ...</p>
            </c:if>

        </div>
    </section>

    <section id="about" class="about" style="padding: 5rem 10%; background: white; text-align: center; border-top: 1px solid var(--light);">
        <h2 class="section-title">Về chúng tôi</h2>
        <div style="max-width: 800px; margin: 0 auto; color: var(--gray); line-height: 1.8; font-size: 1.1rem;">
            <p style="margin-bottom: 1rem;">Phòng khám Nha Khoa <strong>SmileCare</strong> tự hào là một trong những trung tâm chăm sóc sức khỏe răng miệng hàng đầu. Chúng tôi ra đời với sứ mệnh mang đến cho khách hàng một nụ cười rạng rỡ và tự tin nhất.</p>
            <p>Trang bị hệ thống máy móc nhập khẩu nguyên chiếc từ Châu Âu, kết hợp cùng quy trình vô trùng tuyệt đối, SmileCare cam kết mang lại trải nghiệm điều trị an toàn, êm ái và đạt tính thẩm mỹ tối đa.</p>
        </div>
    </section>

    <section id="doctors" class="doctors" style="padding: 5rem 10%; background: #f8fafc; text-align: center;">
        <h2 class="section-title">Đội ngũ Bác sĩ Chuyên gia</h2>
        <p style="max-width: 600px; margin: 0 auto 3rem auto; color: var(--gray);">Hội tụ những chuyên gia nha khoa tận tâm và giàu kinh nghiệm nhất.</p>
        
        <div style="display: flex; justify-content: center; gap: 2rem; flex-wrap: wrap;">
            <div class="service-card" style="width: 300px; padding: 2.5rem 1.5rem; text-align: center; display: inline-block;">
                <div style="width: 120px; height: 120px; background: #E0E7FF; color: var(--primary); border-radius: 50%; font-size: 3.5rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto;">
                    <i class="fa-solid fa-user-doctor"></i>
                </div>
                <h3>BS. Nguyễn Văn Hoàng</h3>
                <p style="color: var(--primary); font-weight: 500; margin: 0.5rem 0;">Chỉnh nha & Phẫu thuật</p>
                <p style="font-size: 0.9rem; color: var(--gray);">Hơn 10 năm kinh nghiệm lâm sàng. Chuyên gia trồng răng Implant và Niềng răng trong suốt.</p>
            </div>
            
            <div class="service-card" style="width: 300px; padding: 2.5rem 1.5rem; text-align: center; display: inline-block;">
                <div style="width: 120px; height: 120px; background: #FEF3C7; color: #D97706; border-radius: 50%; font-size: 3.5rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto;">
                    <i class="fa-solid fa-user-nurse"></i>
                </div>
                <h3>BS. Trần Thu Hà</h3>
                <p style="color: #D97706; font-weight: 500; margin: 0.5rem 0;">Nha khoa Tổng quát</p>
                <p style="font-size: 0.9rem; color: var(--gray);">Bàn tay vàng trong làng điều trị tủy và phục hình sứ thẩm mỹ. Nhẹ nhàng, không đau.</p>
            </div>
            
            <div class="service-card" style="width: 300px; padding: 2.5rem 1.5rem; text-align: center; display: inline-block;">
                <div style="width: 120px; height: 120px; background: #FCE7F3; color: #DB2777; border-radius: 50%; font-size: 3.5rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto;">
                    <i class="fa-solid fa-baby"></i>
                </div>
                <h3>BS. Lê Thùy Linh</h3>
                <p style="color: #DB2777; font-weight: 500; margin: 0.5rem 0;">Nha khoa Trẻ em</p>
                <p style="font-size: 0.9rem; color: var(--gray);">Chuyên gia tâm lý nhí. Biến việc khám răng của các bé thành một chuyến phiêu lưu kỳ thú.</p>
            </div>
            
            <div class="service-card" style="width: 300px; padding: 2.5rem 1.5rem; text-align: center; display: inline-block;">
                <div style="width: 120px; height: 120px; background: #DCFCE7; color: #15803D; border-radius: 50%; font-size: 3.5rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto;">
                    <i class="fa-solid fa-tooth"></i>
                </div>
                <h3>BS. Phạm Minh Tuấn</h3>
                <p style="color: #15803D; font-weight: 500; margin: 0.5rem 0;">Phục hình Răng sứ</p>
                <p style="font-size: 0.9rem; color: var(--gray);">Hơn 12 năm kinh nghiệm thiết kế nụ cười, bọc sứ thẩm mỹ an toàn không mài nhỏ.</p>
            </div>
            
            <div class="service-card" style="width: 300px; padding: 2.5rem 1.5rem; text-align: center; display: inline-block;">
                <div style="width: 120px; height: 120px; background: #F3E8FF; color: #7E22CE; border-radius: 50%; font-size: 3.5rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto;">
                    <i class="fa-solid fa-syringe"></i>
                </div>
                <h3>BS. Lê Ngọc Mai</h3>
                <p style="color: #7E22CE; font-weight: 500; margin: 0.5rem 0;">Nha chu & Tiểu phẫu</p>
                <p style="font-size: 0.9rem; color: var(--gray);">Khắc tinh của viêm nha chu và các ca nhổ răng khôn ngầm mọc lệch siêu khó.</p>
            </div>
        </div>
    </section>

</body>
</html>
