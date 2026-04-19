import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hardcoded Admin Credentials
        if ("admin@gmail.com".equals(email) && "admin@123".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("adminEmail", email);
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        } else {
            response.getWriter().println("<script>alert('Invalid Admin Credentials');window.location='" + request.getContextPath() + "/admin-login.jsp';</script>");
        }
    }
}
