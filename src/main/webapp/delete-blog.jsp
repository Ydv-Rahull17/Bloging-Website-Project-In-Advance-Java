<%@ page import="java.sql.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String blogId = request.getParameter("id");
    if (blogId == null || blogId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/myblog.jsp");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mspblog", "root", "Roman123@.");
        } catch (SQLException ex) {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mspblog", "root", "");
        }
        String sql = "DELETE FROM blog WHERE id = ? AND author_email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, blogId);
        ps.setString(2, userEmail);
        ps.executeUpdate();

        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    response.sendRedirect(request.getContextPath() + "/myblog.jsp");
%>
