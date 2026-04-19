import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.util.*;

@WebServlet("/ViewUsersServlet")
public class ViewUsersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        try {
            try (Connection con = DBConnection.getConnection();
                 Statement stmt = con.createStatement()) {
                ResultSet rs = stmt.executeQuery("SELECT * FROM user");

                List<Map<String, String>> users = new ArrayList<>();
                while (rs.next()) {
                    Map<String, String> user = new HashMap<>();
                    user.put("id", String.valueOf(rs.getInt("id")));
                    user.put("profile_pic", rs.getString("profile_pic"));
                    user.put("fullname", rs.getString("fullname"));
                    user.put("email", rs.getString("email"));
                    user.put("created_at", String.valueOf(rs.getTimestamp("created_at")));
                    users.add(user);
                }

                request.setAttribute("users", users);
                RequestDispatcher rd = request.getRequestDispatcher("admin-users.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
