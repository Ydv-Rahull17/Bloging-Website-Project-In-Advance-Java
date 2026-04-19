import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/AdminDeleteUserServlet")
public class AdminDeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.getWriter().println("Invalid user ID.");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdParam.trim());
        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid user ID.");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                String userEmail = null;
                try (PreparedStatement getEmailPs = con.prepareStatement("SELECT email FROM `user` WHERE id = ?")) {
                    getEmailPs.setInt(1, userId);
                    try (ResultSet rs = getEmailPs.executeQuery()) {
                        if (rs.next()) {
                            userEmail = rs.getString("email");
                        }
                    }
                }

                if (userEmail == null) {
                    con.rollback();
                    response.getWriter().println("User not found.");
                    return;
                }

                // Run dependent deletes only when matching table/column exists.
                runDeleteIfPossible(con, "likes", "user_email", "DELETE FROM likes WHERE user_email = ?", userEmail);
                runDeleteIfPossible(con, "comments", "user_email", "DELETE FROM comments WHERE user_email = ?", userEmail);

                if (tableHasColumns(con, "blog", "id", "author_email")) {
                    if (tableHasColumns(con, "likes", "blog_id")) {
                        try (PreparedStatement ps = con.prepareStatement(
                                "DELETE FROM likes WHERE blog_id IN (SELECT id FROM blog WHERE author_email = ?)")) {
                            ps.setString(1, userEmail);
                            ps.executeUpdate();
                        }
                    }
                    if (tableHasColumns(con, "comments", "blog_id")) {
                        try (PreparedStatement ps = con.prepareStatement(
                                "DELETE FROM comments WHERE blog_id IN (SELECT id FROM blog WHERE author_email = ?)")) {
                            ps.setString(1, userEmail);
                            ps.executeUpdate();
                        }
                    }
                    try (PreparedStatement delBlogs = con.prepareStatement("DELETE FROM blog WHERE author_email = ?")) {
                        delBlogs.setString(1, userEmail);
                        delBlogs.executeUpdate();
                    }
                }

                int rowsAffected;
                try (PreparedStatement deleteUser = con.prepareStatement("DELETE FROM `user` WHERE id = ?")) {
                    deleteUser.setInt(1, userId);
                    rowsAffected = deleteUser.executeUpdate();
                }

                con.commit();
                if (rowsAffected > 0) {
                    response.sendRedirect(request.getContextPath() + "/ViewUsersServlet");
                } else {
                    response.getWriter().println("Error deleting user.");
                }
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting user: " + e.getMessage());
        }
    }

    private void runDeleteIfPossible(Connection con, String table, String column, String sql, String value) throws SQLException {
        if (!tableHasColumns(con, table, column)) {
            return;
        }
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.executeUpdate();
        }
    }

    private boolean tableHasColumns(Connection con, String table, String... columns) throws SQLException {
        DatabaseMetaData metaData = con.getMetaData();
        for (String column : columns) {
            boolean found = false;
            try (ResultSet rs = metaData.getColumns(null, null, table, column)) {
                if (rs.next()) {
                    found = true;
                }
            }
            if (!found) {
                try (ResultSet rs = metaData.getColumns(null, null, table.toUpperCase(), column.toUpperCase())) {
                    if (rs.next()) {
                        found = true;
                    }
                }
            }
            if (!found) {
                return false;
            }
        }
        return true;
    }
}
