import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.util.*;

@WebServlet("/AdminViewUserBlogServlet")
public class AdminViewUserBlogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String userEmail = request.getParameter("email");
        try {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM blog WHERE author_email=? ORDER BY created_at DESC")) {
                ps.setString(1, userEmail);
                ResultSet rs = ps.executeQuery();

                List<Map<String, String>> blogs = new ArrayList<>();
                while (rs.next()) {
                    Map<String, String> blog = new HashMap<>();
                    blog.put("id", String.valueOf(rs.getInt("id")));
                    blog.put("title", rs.getString("title"));
                    blog.put("category", rs.getString("category"));
                    blog.put("created_at", String.valueOf(rs.getTimestamp("created_at")));
                    blogs.add(blog);
                }

                request.setAttribute("blogs", blogs);
                request.setAttribute("userEmail", userEmail);
                RequestDispatcher rd = request.getRequestDispatcher("admin-user-blogs.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
