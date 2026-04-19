import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/LikeServlet")
public class LikeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String blogId = request.getParameter("blogId");
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (userEmail == null || blogId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement check = conn.prepareStatement("SELECT * FROM likes WHERE blog_id = ? AND user_email = ?");
            check.setInt(1, Integer.parseInt(blogId));
            check.setString(2, userEmail);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                PreparedStatement delete = conn.prepareStatement("DELETE FROM likes WHERE blog_id = ? AND user_email = ?");
                delete.setInt(1, Integer.parseInt(blogId));
                delete.setString(2, userEmail);
                delete.executeUpdate();
            } else {
                PreparedStatement insert = conn.prepareStatement("INSERT INTO likes (blog_id, user_email) VALUES (?, ?)");
                insert.setInt(1, Integer.parseInt(blogId));
                insert.setString(2, userEmail);
                insert.executeUpdate();
            }

            response.setStatus(200); // Respond for AJAX

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Something went wrong.");
        }
    }
}
