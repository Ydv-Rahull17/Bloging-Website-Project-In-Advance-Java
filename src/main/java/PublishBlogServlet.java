import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.sql.*;
import java.util.UUID;

@WebServlet("/PublishBlogServlet")
@MultipartConfig
public class PublishBlogServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String content = request.getParameter("content");

        HttpSession session = request.getSession(false);
        String authorEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (authorEmail == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Part filePart = request.getPart("image");
        String fileName = UUID.randomUUID() + "_" + filePart.getSubmittedFileName();

        // Corrected path setup
        String uploadPath = getServletContext().getRealPath("/assets/images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String fullPath = uploadPath + File.separator + fileName;

        // Debugging output to console
        System.out.println("Upload Path: " + uploadPath);
        System.out.println("Full Path: " + fullPath);
        System.out.println("Image File Name: " + fileName);
        System.out.println("Author Email: " + authorEmail);

        // Save image file
        try {
            filePart.write(fullPath);
        } catch (IOException e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Image upload failed: " + e.getMessage() + "'); window.location='" + request.getContextPath() + "/create-blog.jsp';</script>");
            return;
        }

        // Save blog to database
        String imagePath = "assets/images/" + fileName;
        try (Connection conn = DBConnection.getConnection()) {

            String sql = "INSERT INTO blog (title, category, content, image, author_email, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, category);
            ps.setString(3, content);
            ps.setString(4, imagePath);
            ps.setString(5, authorEmail);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect(request.getContextPath() + "/myblog.jsp");
            } else {
                response.getWriter().println("<script>alert('Failed to publish blog.'); window.location='" + request.getContextPath() + "/create-blog.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('Database error occurred.'); window.location='" + request.getContextPath() + "/create-blog.jsp';</script>");
        }
    }
}
