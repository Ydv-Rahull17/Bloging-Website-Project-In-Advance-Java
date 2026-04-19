import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailService {
    private EmailService() {
    }

    public static void sendSimpleMail(String to, String subject, String body) throws MessagingException {
        if (to == null || to.trim().isEmpty()) {
            return;
        }
        if (EmailConfig.SENDER_EMAIL == null || EmailConfig.SENDER_EMAIL.trim().isEmpty()) {
            return;
        }
        if (EmailConfig.APP_PASSWORD == null || EmailConfig.APP_PASSWORD.trim().isEmpty()) {
            return;
        }

        final String normalizedAppPassword = EmailConfig.APP_PASSWORD.replaceAll("\\s+", "");
        if (normalizedAppPassword.isEmpty()) {
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EmailConfig.SENDER_EMAIL, normalizedAppPassword);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EmailConfig.SENDER_EMAIL));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        message.setText(body);

        Transport.send(message);
    }
}
