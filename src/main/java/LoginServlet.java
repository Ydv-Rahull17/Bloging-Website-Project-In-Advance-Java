import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.mail.MessagingException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement("SELECT fullname, email, password, profile_pic FROM user WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");

                // ✅ Compare plain password with hashed password
                if (BCrypt.checkpw(password, dbPassword)) {
                    String fullname = rs.getString("fullname");
                    String profilePic = rs.getString("profile_pic");

                    // ✅ Check and assign default profile image if none exists
                    if (profilePic == null || profilePic.isEmpty()) {
                        profilePic = "assets/images/user.png";
                    }

                    // ✅ Use relative path for HTML rendering
                    HttpSession session = request.getSession();
                    session.setAttribute("user", fullname);
                    session.setAttribute("userEmail", email);
                    session.setAttribute("profile_pic", profilePic); // 🔥 This fixes navbar image after login

                    try {
                        EmailService.sendSimpleMail(
                                email,
                                "Login Alert - Hariom Web Application",
                                "Hello " + fullname + ",\n\nYou have successfully logged in to your account.\nIf this was not you, please change your password immediately.\n\nThanks,\nHariom Team"
                        );
                    } catch (MessagingException ignore) {
                        // Login should not fail if email sending fails.
                    }

                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    return;
                }
            }

            // ❌ If login fails
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server Error");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
