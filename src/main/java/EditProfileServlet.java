import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/EditProfileServlet")
@MultipartConfig
public class EditProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String currentEmail = (String) session.getAttribute("userEmail");
        String newFullName = request.getParameter("fullname");
        String newPassword = request.getParameter("password");

        Part filePart = request.getPart("profilePic");
        String fileName = extractFileName(filePart);
        String profilePicPath = null;

        if (fileName != null && !fileName.isEmpty()) {
            profilePicPath = "assets/uploads/" + fileName;
            String uploadPath = getServletContext().getRealPath("/") + profilePicPath;
            File uploadDir = new File(uploadPath).getParentFile();
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath);
        }

        String hashedPassword = null;
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        }

        try (Connection conn = DBConnection.getConnection()) {

            StringBuilder query = new StringBuilder("UPDATE user SET fullname = ?");
            if (hashedPassword != null) query.append(", password = ?");
            if (profilePicPath != null) query.append(", profile_pic = ?");
            query.append(" WHERE email = ?");

            PreparedStatement ps = conn.prepareStatement(query.toString());

            ps.setString(1, newFullName);

            int index = 2;
            if (hashedPassword != null) ps.setString(index++, hashedPassword);
            if (profilePicPath != null) ps.setString(index++, profilePicPath);
            ps.setString(index, currentEmail);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                session.setAttribute("user", newFullName);
                if (profilePicPath != null) {
                    session.setAttribute("profile_pic", profilePicPath);
                }

                response.sendRedirect(request.getContextPath() + "/ProfileServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/Edit_Profile.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Edit_Profile.jsp");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return fileName.isEmpty() ? null : fileName;
            }
        }
        return null;
    }
}
