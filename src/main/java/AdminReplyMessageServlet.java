import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AdminReplyMessageServlet")
public class AdminReplyMessageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String messageIdParam = request.getParameter("messageId");
        String replyText = request.getParameter("replyText");
        if (messageIdParam == null || messageIdParam.trim().isEmpty() || replyText == null || replyText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminViewMessagesServlet?error=invalid");
            return;
        }

        int messageId;
        try {
            messageId = Integer.parseInt(messageIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/AdminViewMessagesServlet?error=invalid");
            return;
        }

        String userEmail = null;
        String fullname = null;
        String userMessage = null;

        try (Connection con = DBConnection.getConnection()) {
            ContactServlet.ensureContactMessageTable(con);

            try (PreparedStatement find = con.prepareStatement(
                    "SELECT user_email, firstname, lastname, user_message FROM contact_messages WHERE id = ?")) {
                find.setInt(1, messageId);
                try (ResultSet rs = find.executeQuery()) {
                    if (rs.next()) {
                        userEmail = rs.getString("user_email");
                        String first = rs.getString("firstname");
                        String last = rs.getString("lastname");
                        fullname = ((first == null ? "" : first) + " " + (last == null ? "" : last)).trim();
                        userMessage = rs.getString("user_message");
                    }
                }
            }

            if (userEmail == null || userEmail.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/AdminViewMessagesServlet?error=notfound");
                return;
            }

            try (PreparedStatement update = con.prepareStatement(
                    "UPDATE contact_messages SET admin_reply = ?, is_replied = 1, replied_at = NOW() WHERE id = ?")) {
                update.setString(1, replyText.trim());
                update.setInt(2, messageId);
                update.executeUpdate();
            }

            String subject = "Reply from Admin - Hariom Web Application";
            String body = "Hello " + (fullname == null || fullname.isEmpty() ? "User" : fullname) + ",\n\n"
                    + "You received a reply from admin.\n\n"
                    + "Your message:\n" + (userMessage == null ? "" : userMessage) + "\n\n"
                    + "Admin reply:\n" + replyText.trim() + "\n\n"
                    + "You can also view this reply in your Contact page.\n\n"
                    + "Thanks,\nHariom Team";

            try {
                EmailService.sendSimpleMail(userEmail, subject, body);
            } catch (MessagingException e) {
                e.printStackTrace();
            }

            response.sendRedirect(request.getContextPath() + "/AdminViewMessagesServlet?success=replied");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AdminViewMessagesServlet?error=server");
        }
    }
}
