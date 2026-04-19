import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/AdminDeleteBlogServlet")
public class AdminDeleteBlogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        // Session check - only admin allowed
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int blogId = Integer.parseInt(idStr.trim());

                try (Connection con = DBConnection.getConnection()) {
                    String query = "DELETE FROM blog WHERE id = ?";
                    try (PreparedStatement ps = con.prepareStatement(query)) {
                        ps.setInt(1, blogId);
                        ps.executeUpdate();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Redirect to blog list
        response.sendRedirect(request.getContextPath() + "/ViewBlogsServlet");
    }
}
