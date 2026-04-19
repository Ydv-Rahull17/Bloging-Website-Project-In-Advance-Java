import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String commentText = request.getParameter("comment");
        int blogId = Integer.parseInt(request.getParameter("blogId"));
        String email = (String) session.getAttribute("userEmail");

        try (Connection conn = DBConnection.getConnection()) {

            // Insert comment
            PreparedStatement pst = conn.prepareStatement(
                "INSERT INTO comments (blog_id, user_email, comment) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
            pst.setInt(1, blogId);
            pst.setString(2, email);
            pst.setString(3, commentText);
            pst.executeUpdate();

            ResultSet generatedKeys = pst.getGeneratedKeys();
            int newCommentId = -1;
            if (generatedKeys.next()) {
                newCommentId = generatedKeys.getInt(1);
            }

            // Fetch the newly inserted comment with user details
            PreparedStatement fetchStmt = conn.prepareStatement(
                "SELECT c.id, c.comment, c.created_at, u.fullname, u.profile_pic " +
                "FROM comments c JOIN user u ON c.user_email = u.email WHERE c.id = ?");
            fetchStmt.setInt(1, newCommentId);
            ResultSet rs = fetchStmt.executeQuery();

            if (rs.next()) {
                String fullname = rs.getString("fullname");
                String profilePic = rs.getString("profile_pic");
                String comment = rs.getString("comment");
                String createdAt = rs.getString("created_at");

                out.println("<div class=\"comment\" id=\"comment-" + newCommentId + "\">");
                out.println("<img src=\"" + ((profilePic != null && !profilePic.isEmpty()) ? profilePic : "default.png") + "\" alt=\"Profile\">");
                out.println("<div class=\"comment-content\">");
                out.println("<strong>" + fullname + "</strong><br>");
                out.println(comment + "<br>");
                out.println("<small>" + createdAt + "</small>");
                out.println("</div>");
                out.println("<button class=\"delete-btn\" onclick=\"deleteComment(" + newCommentId + ")\">Delete</button>");
                out.println("</div>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("Error occurred");
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String commentIdParam = request.getParameter("commentId");

        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (userEmail == null || commentIdParam == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int commentId = Integer.parseInt(commentIdParam);

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement pst = conn.prepareStatement("DELETE FROM comments WHERE id = ? AND user_email = ?");
            pst.setInt(1, commentId);
            pst.setString(2, userEmail);
            int rows = pst.executeUpdate();

            if (rows > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
