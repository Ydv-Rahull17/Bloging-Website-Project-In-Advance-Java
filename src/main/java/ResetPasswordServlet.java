import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid reset link.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            ForgotPasswordServlet.ensureTokenTable(con);
            if (!isTokenValid(con, token.trim())) {
                request.setAttribute("error", "Reset link is invalid or expired.");
            } else {
                request.setAttribute("token", token.trim());
            }
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error while validating reset link.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid reset token.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        token = token.trim();

        if (password == null || confirmPassword == null || password.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Please enter password and confirm password.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password and confirm password do not match.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            ForgotPasswordServlet.ensureTokenTable(con);
            con.setAutoCommit(false);
            try {
                String userEmail = null;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT user_email FROM password_reset_tokens WHERE token = ? AND used = 0 AND expires_at >= NOW()")) {
                    ps.setString(1, token);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            userEmail = rs.getString("user_email");
                        }
                    }
                }

                if (userEmail == null) {
                    con.rollback();
                    request.setAttribute("error", "Reset link is invalid or expired.");
                    request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                    return;
                }

                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

                try (PreparedStatement updateUser = con.prepareStatement("UPDATE `user` SET password = ? WHERE email = ?")) {
                    updateUser.setString(1, hashedPassword);
                    updateUser.setString(2, userEmail);
                    updateUser.executeUpdate();
                }

                try (PreparedStatement markUsed = con.prepareStatement("UPDATE password_reset_tokens SET used = 1 WHERE token = ?")) {
                    markUsed.setString(1, token);
                    markUsed.executeUpdate();
                }

                con.commit();
                request.getSession().setAttribute("success", "Password reset successful. Please login.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error while resetting password.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }

    private boolean isTokenValid(Connection con, String token) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT 1 FROM password_reset_tokens WHERE token = ? AND used = 0 AND expires_at >= NOW()")) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
