import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/AdminDeleteBlogByUserServlet")
public class AdminDeleteBlogByUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String blogIdParam = request.getParameter("blogId");
        String email = request.getParameter("userEmail");
        if (blogIdParam == null || blogIdParam.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ViewUsersServlet");
            return;
        }
        int blogId = Integer.parseInt(blogIdParam);

        try {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("DELETE FROM blog WHERE id=?")) {
                ps.setInt(1, blogId);
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect(request.getContextPath() + "/AdminViewUserBlogServlet?email=" + email);
                } else {
                    response.getWriter().println("Failed to delete blog.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting blog.");
        }
    }
}
