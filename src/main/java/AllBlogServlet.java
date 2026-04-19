import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/AllBlogServlet")
public class AllBlogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String selectedCategory = request.getParameter("category");
        String search = request.getParameter("search");

        List<Map<String, String>> blogs = new ArrayList<>();
        List<String> categories = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // Fetch categories
            PreparedStatement catStmt = conn.prepareStatement("SELECT DISTINCT category FROM blog");
            ResultSet catRs = catStmt.executeQuery();
            while (catRs.next()) {
                categories.add(catRs.getString("category"));
            }
            catRs.close();
            catStmt.close();

            // Build dynamic SQL
            StringBuilder sql = new StringBuilder("SELECT b.*, u.fullname FROM blog b JOIN user u ON b.author_email = u.email WHERE 1=1");
            List<String> params = new ArrayList<>();

         // Already working fine:
            if (selectedCategory != null && !selectedCategory.trim().isEmpty()) {
                sql.append(" AND b.category = ?");
                params.add(selectedCategory);
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND (b.title LIKE ? OR b.content LIKE ?)");
                String keyword = "%" + search.trim() + "%";
                params.add(keyword);
                params.add(keyword);
            }

            sql.append(" ORDER BY b.created_at DESC");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> blog = new HashMap<>();
                blog.put("id", rs.getString("id"));
                blog.put("title", rs.getString("title"));
                blog.put("category", rs.getString("category"));
                blog.put("content", rs.getString("content"));
                blog.put("image", rs.getString("image"));
                blog.put("author", rs.getString("fullname"));
                blogs.add(blog);
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("blogs", blogs);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", selectedCategory);
        request.setAttribute("searchQuery", search);

        request.getRequestDispatcher("allblogs.jsp").forward(request, response);
    }
}

