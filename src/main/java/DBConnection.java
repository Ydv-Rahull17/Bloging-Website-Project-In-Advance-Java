import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String JDBC_URL = firstNonBlank(
            System.getenv("HARIOM_DB_URL"),
            "jdbc:mysql://localhost:3306/mspblog"
    );
    private static final String DB_USER = firstNonBlank(
            System.getenv("HARIOM_DB_USER"),
            "root"
    );
    private static final String DB_PASSWORD = firstNonBlank(
            System.getenv("HARIOM_DB_PASSWORD"),
            ""
    );

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
        } catch (SQLException e) {
            // Fallback for local setups where root password is empty.
            if (!"".equals(DB_PASSWORD)) {
                return DriverManager.getConnection(JDBC_URL, DB_USER, "");
            }
            throw e;
        }
    }

    private static String firstNonBlank(String value, String fallback) {
        return (value == null || value.trim().isEmpty()) ? fallback : value.trim();
    }
}
