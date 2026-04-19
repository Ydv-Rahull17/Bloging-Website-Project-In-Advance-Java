import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin Email from hidden field
        String to = request.getParameter("adminEmail");
        if (to == null || to.trim().isEmpty()) {
            to = "vivektiwari@gmail.com";
        }

        // User Input from form
        String fname = request.getParameter("firstname");
        String lname = request.getParameter("lastname");
        String country = request.getParameter("country");
        String subject = request.getParameter("subject");

        // Get logged-in user's email from session
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        if (userEmail == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            try (Connection con = DBConnection.getConnection()) {
                ensureContactMessageTable(con);
                try (PreparedStatement insert = con.prepareStatement(
                        "INSERT INTO contact_messages (user_email, firstname, lastname, country, user_message) VALUES (?, ?, ?, ?, ?)")) {
                    insert.setString(1, userEmail);
                    insert.setString(2, safe(fname));
                    insert.setString(3, safe(lname));
                    insert.setString(4, safe(country));
                    insert.setString(5, safe(subject));
                    insert.executeUpdate();
                }
            }

            if (EmailConfig.SENDER_EMAIL == null || EmailConfig.SENDER_EMAIL.trim().isEmpty()
                    || EmailConfig.APP_PASSWORD == null || EmailConfig.APP_PASSWORD.trim().isEmpty()) {
                response.getWriter().println("Email is not configured. Update EmailConfig.java first.");
                return;
            }

            // SMTP Configuration
            java.util.Properties props = new java.util.Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            // Create mail session
            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EmailConfig.SENDER_EMAIL, EmailConfig.APP_PASSWORD);
                }
            });

            // Create message
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(EmailConfig.SENDER_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setReplyTo(new Address[]{ new InternetAddress(userEmail) }); // So admin can reply to user

            message.setSubject("Contact Form Message from " + fname + " " + lname);
            message.setText("Sender Email: " + userEmail +
                            "\nName: " + fname + " " + lname +
                            "\nCountry: " + country +
                            "\n\nMessage:\n" + subject);

            Transport.send(message);
            response.sendRedirect(request.getContextPath() + "/thankyou.jsp");
        } catch (MessagingException e) {
            e.printStackTrace();
            response.getWriter().println("Error sending email. Details: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving message. Details: " + e.getMessage());
        }
    }

    static void ensureContactMessageTable(Connection con) throws Exception {
        try (PreparedStatement create = con.prepareStatement(
                "CREATE TABLE IF NOT EXISTS contact_messages ("
                        + "id INT AUTO_INCREMENT PRIMARY KEY,"
                        + "user_email VARCHAR(190) NOT NULL,"
                        + "firstname VARCHAR(120) NOT NULL,"
                        + "lastname VARCHAR(120) NOT NULL,"
                        + "country VARCHAR(100) NOT NULL,"
                        + "user_message TEXT NOT NULL,"
                        + "admin_reply TEXT DEFAULT NULL,"
                        + "is_replied TINYINT(1) NOT NULL DEFAULT 0,"
                        + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,"
                        + "replied_at TIMESTAMP NULL DEFAULT NULL,"
                        + "INDEX idx_contact_user_email (user_email),"
                        + "INDEX idx_contact_created_at (created_at)"
                        + ") ENGINE=InnoDB")) {
            create.execute();
        }
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
