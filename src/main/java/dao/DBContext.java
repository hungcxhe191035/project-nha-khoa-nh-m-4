package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    // Sửa localhost:1433 tuỳ vào cổng mặc định của máy anh
    // databaseName là nhasi_sv
    // Chú ý: SQL Server đôi khi cần thêm encrypt=false tuỳ phiên bản
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=nhasi_sv;encrypt=false;trustServerCertificate=true;";
    private static final String USER = "sa"; // User mặc định của SQL Server thường là "sa"
    private static final String PASSWORD = "123"; // Đổi thành pass sa của anh

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
