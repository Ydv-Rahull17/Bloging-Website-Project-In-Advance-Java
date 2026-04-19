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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/AdminViewMessagesServlet")
public class AdminViewMessagesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        List<Map<String, String>> messages = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            ContactServlet.ensureContactMessageTable(con);
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id, user_email, firstname, lastname, country, user_message, admin_reply, is_replied, created_at, replied_at "
                            + "FROM contact_messages ORDER BY created_at DESC")) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("id", String.valueOf(rs.getInt("id")));
                        row.put("user_email", rs.getString("user_email"));
                        row.put("firstname", rs.getString("firstname"));
                        row.put("lastname", rs.getString("lastname"));
                        row.put("country", rs.getString("country"));
                        row.put("user_message", rs.getString("user_message"));
                        row.put("admin_reply", rs.getString("admin_reply"));
                        row.put("is_replied", String.valueOf(rs.getInt("is_replied")));
                        row.put("created_at", String.valueOf(rs.getTimestamp("created_at")));
                        row.put("replied_at", String.valueOf(rs.getTimestamp("replied_at")));
                        messages.add(row);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load messages right now.");
        }

        request.setAttribute("messages", messages);
        request.getRequestDispatcher("/admin-messages.jsp").forward(request, response);
    }
}
