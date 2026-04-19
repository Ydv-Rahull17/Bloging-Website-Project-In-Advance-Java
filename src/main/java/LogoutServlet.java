import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/LogoutServlet") // ✅ Path consistent with LoginServlet & ProfileServlet
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate(); // ✅ Safely invalidate session
        }

        // ✅ Redirect to home page after logout
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
