import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/EditBlogServlet")
@MultipartConfig
public class EditBlogServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                System.out.println("ID is null or empty");
                response.sendRedirect(request.getContextPath() + "/myblog.jsp");
                return;
            }
            int id = Integer.parseInt(idParam);

            String title = request.getParameter("title");
            String category = request.getParameter("category");
            String content = request.getParameter("content");
            String existingImage = request.getParameter("existingImage");

            Part imagePart = request.getPart("image");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            String imagePath;
            if (fileName != null && !fileName.isEmpty()) {
                // Save new image
                String uploadDir = getServletContext().getRealPath("/uploads");
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                Path filePath = uploadPath.resolve(fileName);
                try (InputStream input = imagePart.getInputStream()) {
                    Files.copy(input, filePath);
                }

                imagePath = "uploads/" + fileName;
            } else {
                // Use existing image if no new image uploaded
                imagePath = existingImage;
            }

            // Log values
            System.out.println("Updating Blog:");
            System.out.println("ID: " + id);
            System.out.println("Title: " + title);
            System.out.println("Category: " + category);
            System.out.println("Image: " + imagePath);

            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE blog SET title=?, category=?, content=?, image=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, category);
            ps.setString(3, content);
            ps.setString(4, imagePath);
            ps.setInt(5, id);

            int rowsUpdated = ps.executeUpdate();
            System.out.println("Rows updated: " + rowsUpdated);

            ps.close();
            conn.close();

            response.sendRedirect(request.getContextPath() + "/myblog.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/myblog.jsp");
        }
    }
}
