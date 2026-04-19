import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.mail.MessagingException;

@WebServlet("/RegisterServlet")
@MultipartConfig
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            request.getSession().setAttribute("error", "Passwords do not match!");
            response.sendRedirect(request.getContextPath() + "/signup.jsp");
            return;
        }

        // Handle profile picture
        Part filePart = request.getPart("profile_pic");
        String fileName = extractFileName(filePart);
        String profilePicPath = "assets/uploads/" + fileName;

        String uploadPath = getServletContext().getRealPath("/") + profilePicPath;
        File uploadDir = new File(uploadPath).getParentFile();
        if (!uploadDir.exists()) uploadDir.mkdirs();
        filePart.write(uploadPath);

        // Hash password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // JDBC connection
        try (Connection conn = DBConnection.getConnection()) {

            // Check if email already exists
            PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM user WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.getSession().setAttribute("error", "Email already registered!");
                response.sendRedirect(request.getContextPath() + "/signup.jsp");
                return;
            }

            // Insert new user
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO user (fullname, email, password, profile_pic) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, profilePicPath);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                boolean emailSent = true;
                try {
                    EmailService.sendSimpleMail(
                            email,
                            "Welcome to Hariom Web Application",
                            "Hello " + fullname + ",\n\nYour registration is successful. You can now log in and publish blogs.\n\nThanks,\nHariom Team"
                    );
                } catch (MessagingException ignore) {
                    emailSent = false;
                    ignore.printStackTrace();
                }
                request.getSession().setAttribute(
                        "success",
                        emailSent ? "Registration Successful!" : "Registration Successful, but email could not be sent."
                );
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            } else {
                request.getSession().setAttribute("error", "Registration Failed!");
                response.sendRedirect(request.getContextPath() + "/signup.jsp");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage().replace("'", "\\'");
            request.getSession().setAttribute("error", "Error: " + errorMsg);
            response.sendRedirect(request.getContextPath() + "/signup.jsp");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "default.jpg";
    }
}
