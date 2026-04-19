import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.util.*;

@WebServlet("/ViewBlogsServlet")
public class ViewBlogsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        try {
            String query = "SELECT b.*, u.fullname FROM blog b JOIN user u ON b.author_email = u.email ORDER BY b.created_at DESC";
            try (Connection con = DBConnection.getConnection();
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                List<Map<String, String>> blogs = new ArrayList<>();
                while (rs.next()) {
                    Map<String, String> blog = new HashMap<>();
                    blog.put("id", String.valueOf(rs.getInt("id")));
                    blog.put("title", rs.getString("title"));
                    blog.put("category", rs.getString("category"));
                    blog.put("fullname", rs.getString("fullname"));
                    blog.put("created_at", String.valueOf(rs.getTimestamp("created_at")));
                    blogs.add(blog);
                }

                request.setAttribute("blogs", blogs);
                RequestDispatcher rd = request.getRequestDispatcher("admin-blogs.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
