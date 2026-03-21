-- Database: NhasiSV 2.0 (SQL Server Version)

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'nhasi_sv')
BEGIN
    ALTER DATABASE nhasi_sv SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE nhasi_sv;
END
GO

CREATE DATABASE nhasi_sv;
GO

USE nhasi_sv;
GO

CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('ADMIN', 'STAFF', 'DOCTOR', 'PATIENT')) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Services (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Medicines (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    unit NVARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Doctors (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    specialty NVARCHAR(100) NOT NULL,
    experience_years INT,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);
GO

CREATE TABLE Schedules (
    id INT IDENTITY(1,1) PRIMARY KEY,
    doctor_id INT NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(20) CHECK (status IN ('AVAILABLE', 'BOOKED')) DEFAULT 'AVAILABLE',
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id) ON DELETE CASCADE
);
GO

CREATE TABLE Doctor_Services (
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,
    PRIMARY KEY (doctor_id, service_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id),
    FOREIGN KEY (service_id) REFERENCES Services(id)
);
GO

CREATE TABLE Appointments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,
    schedule_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')) DEFAULT 'PENDING',
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (patient_id) REFERENCES Users(id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id),
    FOREIGN KEY (service_id) REFERENCES Services(id),
    FOREIGN KEY (schedule_id) REFERENCES Schedules(id)
);
GO

CREATE TABLE MedicalRecords (
    id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id INT NOT NULL,
    diagnosis NVARCHAR(MAX) NOT NULL,
    service_payment_status VARCHAR(20) CHECK (service_payment_status IN ('UNPAID', 'PAID')) DEFAULT 'UNPAID',
    total_service_amount DECIMAL(10, 2) DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id)
);
GO

CREATE TABLE Prescription_Details (
    id INT IDENTITY(1,1) PRIMARY KEY,
    medical_record_id INT NOT NULL,
    medicine_id INT NOT NULL,
    prescribed_quantity INT NOT NULL,
    purchased_quantity INT DEFAULT 0,
    total_price DECIMAL(10, 2) DEFAULT 0,
    payment_status VARCHAR(20) CHECK (payment_status IN ('UNPAID', 'PAID')) DEFAULT 'UNPAID',
    FOREIGN KEY (medical_record_id) REFERENCES MedicalRecords(id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES Medicines(id)
);
GO

CREATE TABLE MedicalRecord_Services (
    id INT IDENTITY(1,1) PRIMARY KEY,
    medical_record_id INT NOT NULL,
    service_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('UNPAID', 'PAID')) DEFAULT 'UNPAID',
    FOREIGN KEY (medical_record_id) REFERENCES MedicalRecords(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(id)
);
GO

-- SEED DATA
INSERT INTO Users (username, password, full_name, email, role) VALUES 
('admin', '123456', N'Quản trị viên', 'admin@nhasi.com', 'ADMIN'),
('receptionist1', '123456', N'Lễ Tân 01', 'letan@nhasi.com', 'STAFF'),
('dr_hoang', '123456', N'BS. Nguyễn Văn Hoàng', 'bshoang@nhasi.com', 'DOCTOR'),
('patient1', '123456', N'Bệnh nhân Demo', 'benhnhan@nhasi.com', 'PATIENT'),
('dr_lan', '123456', N'BS. Trần Thị Lan', 'bslan@nhasi.com', 'DOCTOR'),
('dr_minh', '123456', N'BS. Lê Quang Minh', 'bsminh@nhasi.com', 'DOCTOR'),
('dr_hoa', '123456', N'BS. Phạm Thanh Hoa', 'bshoa@nhasi.com', 'DOCTOR'),
('dr_tuan', '123456', N'BS. Bùi Anh Tuấn', 'bstuan@nhasi.com', 'DOCTOR');
GO

INSERT INTO Doctors (user_id, specialty, experience_years) VALUES 
(3, N'Chỉnh nha & Phẫu thuật', 10),
(5, N'Nha khoa tổng quát', 5),
(6, N'Implant & Phẫu thuật', 12),
(7, N'Điều trị tủy', 8),
(8, N'Nha khoa thẩm mỹ', 7);
GO

INSERT INTO Services (name, category, price, description) VALUES 
(N'Khám tổng quát & Tư vấn', N'Khám', 100000, N'Khám tổng quát, chụp X-Quang tư vấn'),
(N'Nhổ răng khôn', N'Phẫu thuật', 1500000, N'Nhổ răng khôn mọc lệch'),
(N'Lấy cao răng', N'Vệ sinh', 300000, N'Làm sạch mảng bám');
GO

INSERT INTO Doctor_Services (doctor_id, service_id) VALUES
-- BS Hoàng: Phẫu thuật, Lấy cao, Khám
(1, 1), (1, 2), (1, 3),
-- BS Lan: Khám, Lấy cao
(2, 1), (2, 3),
-- BS Minh: Phẫu thuật
(3, 1), (3, 2),
-- BS Hoa: Khám, Vệ sinh
(4, 1), (4, 3),
-- BS Tuấn: Tất cả
(5, 1), (5, 2), (5, 3);
GO

INSERT INTO Medicines (name, unit, price, stock_quantity) VALUES 
(N'Panadol Extra', N'Viên', 2000, 1000),
(N'Amoxicillin 500mg', N'Viên', 5000, 500),
(N'Nước súc miệng Kin', N'Chai', 120000, 50),
(N'Ibuprofen 400mg', N'Viên', 3500, 800),
(N'Nước muối sinh lý 500ml', N'Chai', 15000, 200),
(N'Betadine Súc Họng 125ml', N'Chai', 85000, 100),
(N'Vitamin C 500mg', N'Viên', 1500, 2000),
(N'Gel Bôi Nhiệt Miệng Kamistad', N'Tuýp', 35000, 150);
GO

-- SEED DATA (Lịch hẹn khám)
INSERT INTO Schedules (doctor_id, work_date, start_time, end_time) VALUES
-- Hôm nay BS Hoàng
(1, CAST(GETDATE() AS DATE), '08:00:00', '09:00:00'),
(1, CAST(GETDATE() AS DATE), '09:00:00', '10:00:00'),
(1, CAST(GETDATE() AS DATE), '14:00:00', '15:00:00'),

-- Ngày mai BS Hoàng
(1, CAST(GETDATE() + 1 AS DATE), '08:00:00', '09:00:00'),
(1, CAST(GETDATE() + 1 AS DATE), '09:00:00', '10:00:00'),
(1, CAST(GETDATE() + 1 AS DATE), '14:00:00', '15:00:00'),
(1, CAST(GETDATE() + 1 AS DATE), '15:00:00', '16:00:00'),

-- Ngày mốt BS Hoàng
(1, CAST(GETDATE() + 2 AS DATE), '08:00:00', '09:00:00'),
(1, CAST(GETDATE() + 2 AS DATE), '09:00:00', '10:00:00'),
(1, CAST(GETDATE() + 2 AS DATE), '10:00:00', '11:00:00'),

-- 3 ngày nữa BS Hoàng
(1, CAST(GETDATE() + 3 AS DATE), '14:00:00', '15:00:00'),
(1, CAST(GETDATE() + 3 AS DATE), '15:00:00', '16:00:00'),

-- Ngày mai BS Lan
(2, CAST(GETDATE() + 1 AS DATE), '08:00:00', '09:00:00'),
(2, CAST(GETDATE() + 1 AS DATE), '09:00:00', '10:00:00');
GO
