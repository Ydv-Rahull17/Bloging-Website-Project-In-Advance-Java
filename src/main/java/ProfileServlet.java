import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ProfileServlet") 
public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement("SELECT fullname, email, profile_pic FROM user WHERE email = ?");
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String userName = rs.getString("fullname");
                String profilePic = rs.getString("profile_pic");

                if (profilePic == null || profilePic.isEmpty()) {
                    profilePic = request.getContextPath() + "/assets/images/user.png";
                } else {
                    profilePic = request.getContextPath() + "/" + profilePic;
                }

                request.setAttribute("userName", userName);
                request.setAttribute("userEmail", userEmail);
                request.setAttribute("profilePic", profilePic);

                // Fetch User's Blogs
                PreparedStatement blogPs = conn.prepareStatement("SELECT id, title, category, content, image, created_at FROM blog WHERE author_email = ? ORDER BY created_at DESC");
                blogPs.setString(1, userEmail);
                ResultSet blogRs = blogPs.executeQuery();
                
                List<Map<String, String>> userBlogs = new ArrayList<>();
                while (blogRs.next()) {
                    Map<String, String> blog = new HashMap<>();
                    blog.put("id", blogRs.getString("id"));
                    blog.put("title", blogRs.getString("title"));
                    blog.put("category", blogRs.getString("category"));
                    blog.put("content", blogRs.getString("content"));
                    blog.put("image", blogRs.getString("image"));
                    blog.put("created_at", blogRs.getString("created_at"));
                    userBlogs.add(blog);
                }
                blogRs.close();
                blogPs.close();
                
                request.setAttribute("userBlogs", userBlogs);
                request.setAttribute("postCount", userBlogs.size()); // dynamically count posts

                RequestDispatcher dispatcher = request.getRequestDispatcher("/My_Profile.jsp");
                dispatcher.forward(request, response);
                return;
            } else {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server Error");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
