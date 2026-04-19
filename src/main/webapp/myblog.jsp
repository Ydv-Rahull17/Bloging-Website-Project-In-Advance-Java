<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page session="true" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> blogs = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mspblog", "root", "Roman123@.");
        } catch (SQLException ex) {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mspblog", "root", "");
        }
        String sql = "SELECT * FROM blog WHERE author_email = ? ORDER BY created_at DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> blog = new HashMap<>();
            blog.put("id", rs.getString("id"));
            blog.put("title", rs.getString("title"));
            blog.put("category", rs.getString("category"));
            blog.put("content", rs.getString("content"));
            blog.put("image", rs.getString("image"));
            blogs.add(blog);
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Blogs</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            font-family: Arial, sans-serif;
        }

        .myblog-container {
            max-width: 1100px;
            margin: auto;
            padding: 20px;
        }

        .myblog-heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .myblog-blog-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .myblog-blog-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 300px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .myblog-blog-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .myblog-blog-content {
            padding: 15px;
        }

        .myblog-blog-content h3 {
            margin: 0 0 10px;
            font-size: 20px;
            color: #333;
        }

        .myblog-blog-content h3 a {
            color: #333;
            text-decoration: none;
        }

        .myblog-blog-content h3 a:hover {
            text-decoration: underline;
        }

        .myblog-blog-content p {
            margin: 5px 0;
            font-size: 14px;
            color: #555;
        }

        .myblog-actions {
            display: flex;
            justify-content: space-between;
            padding: 10px 15px 15px;
        }

        .myblog-actions form {
            display: inline;
        }

        .myblog-actions button {
            padding: 6px 12px;
            font-size: 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .edit-btn {
            background-color: #007BFF;
            color: white;
        }

        .delete-btn {
            background-color: #DC3545;
            color: white;
        }

        .myblog-no-blogs {
            text-align: center;
            color: #777;
        }
    </style>
</head>
<body>

<%@ include file="Navbar.jsp" %>

<div class="myblog-container">
    <h2 class="myblog-heading">Your Blogs</h2>

    <%
        if (blogs.size() == 0) {
    %>
    <p class="myblog-no-blogs">No blogs found. <a href="<%= request.getContextPath() %>/create-blog.jsp">Create one now</a>.</p>
    <%
        } else {
    %>
    <div class="myblog-blog-container">
        <%
            for (Map<String, String> blog : blogs) {
        %>
        <div class="myblog-blog-card">
            <a href="<%= request.getContextPath() %>/ReadBlogServlet?id=<%= blog.get("id") %>">
                <img src="<%= blog.get("image") %>" alt="Blog Image">
            </a>
            <div class="myblog-blog-content">
                <h3>
                    <a href="<%= request.getContextPath() %>/ReadBlogServlet?id=<%= blog.get("id") %>"><%= blog.get("title") %></a>
                </h3>
                <p><strong>Category:</strong> <%= blog.get("category") %></p>
                <p><%= blog.get("content").length() > 150 ? blog.get("content").substring(0, 150) + "..." : blog.get("content") %></p>
            </div>
            <div class="myblog-actions">
                <form action="<%= request.getContextPath() %>/edit-blog.jsp" method="get">
                    <input type="hidden" name="id" value="<%= blog.get("id") %>">
                    <button type="submit" class="edit-btn">Edit</button>
                </form>
                <form action="<%= request.getContextPath() %>/delete-blog.jsp" method="post" onsubmit="return confirm('Are you sure you want to delete this blog?');">
                    <input type="hidden" name="id" value="<%= blog.get("id") %>">
                    <button type="submit" class="delete-btn">Delete</button>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
