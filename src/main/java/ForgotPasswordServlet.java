import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final int TOKEN_EXPIRY_MINUTES = 30;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your registered email.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        email = email.trim();

        try (Connection con = DBConnection.getConnection()) {
            ensureTokenTable(con);

            String fullname = null;
            try (PreparedStatement ps = con.prepareStatement("SELECT fullname FROM `user` WHERE email = ?")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        fullname = rs.getString("fullname");
                    }
                }
            }

            request.setAttribute("success", "If the email is registered, a password reset link has been sent.");

            if (fullname == null) {
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            String token = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
            Timestamp expiresAt = Timestamp.valueOf(LocalDateTime.now().plusMinutes(TOKEN_EXPIRY_MINUTES));

            try (PreparedStatement clearOld = con.prepareStatement("DELETE FROM password_reset_tokens WHERE user_email = ?")) {
                clearOld.setString(1, email);
                clearOld.executeUpdate();
            }

            try (PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO password_reset_tokens (user_email, token, expires_at, used) VALUES (?, ?, ?, 0)")) {
                insert.setString(1, email);
                insert.setString(2, token);
                insert.setTimestamp(3, expiresAt);
                insert.executeUpdate();
            }

            String resetLink = buildResetLink(request, token);
            String subject = "Reset Your Password - Hariom Web Application";
            String body = "Hello " + fullname + ",\n\n"
                    + "We received a request to reset your password.\n"
                    + "Click the link below to set a new password:\n"
                    + resetLink + "\n\n"
                    + "This link is valid for " + TOKEN_EXPIRY_MINUTES + " minutes.\n"
                    + "If you did not request this, please ignore this email.\n\n"
                    + "Thanks,\nHariom Team";

            try {
                EmailService.sendSimpleMail(email, subject, body);
            } catch (MessagingException e) {
                e.printStackTrace();
                request.setAttribute("error", "Could not send reset email right now. Please try again.");
            }

            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error while processing forgot password.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }

    private String buildResetLink(HttpServletRequest request, String token) {
        String scheme = request.getScheme();
        String server = request.getServerName();
        int port = request.getServerPort();
        String contextPath = request.getContextPath();
        String encodedToken = URLEncoder.encode(token, StandardCharsets.UTF_8);

        StringBuilder base = new StringBuilder();
        base.append(scheme).append("://").append(server);
        if (!("http".equalsIgnoreCase(scheme) && port == 80) && !("https".equalsIgnoreCase(scheme) && port == 443)) {
            base.append(":").append(port);
        }
        base.append(contextPath);
        base.append("/ResetPasswordServlet?token=").append(encodedToken);
        return base.toString();
    }

    static void ensureTokenTable(Connection con) throws Exception {
        try (PreparedStatement create = con.prepareStatement(
                "CREATE TABLE IF NOT EXISTS password_reset_tokens ("
                        + "id INT AUTO_INCREMENT PRIMARY KEY,"
                        + "user_email VARCHAR(190) NOT NULL,"
                        + "token VARCHAR(140) NOT NULL UNIQUE,"
                        + "expires_at TIMESTAMP NOT NULL,"
                        + "used TINYINT(1) NOT NULL DEFAULT 0,"
                        + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,"
                        + "INDEX idx_reset_email (user_email),"
                        + "INDEX idx_reset_token (token)"
                        + ") ENGINE=InnoDB")) {
            create.execute();
        }
    }
}
