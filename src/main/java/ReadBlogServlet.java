import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ReadBlogServlet")
public class ReadBlogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String blogId = request.getParameter("id");
        if (blogId == null || blogId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AllBlogServlet");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/read-blog.jsp?id=" + blogId.trim());
    }
}
