<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String blogId = request.getParameter("id");
    Map<String, String> blog = new HashMap<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mspblog", "root", "Roman123@.");
        } catch (SQLException ex) {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mspblog", "root", "");
        }
        String sql = "SELECT * FROM blog WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, blogId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            blog.put("id", rs.getString("id"));
            blog.put("title", rs.getString("title"));
            blog.put("category", rs.getString("category"));
            blog.put("content", rs.getString("content"));
            blog.put("image", rs.getString("image"));
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Blog</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            padding: 40px;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        input[type="text"],
        select,
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #007BFF;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        .note {
            font-size: 13px;
            color: #666;
            margin-top: -15px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Blog</h2>
    <form action="<%= request.getContextPath() %>/EditBlogServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= blog.get("id") %>">
        <input type="hidden" name="existingImage" value="<%= blog.get("image") %>">

        <label>Blog Title</label>
        <input type="text" name="title" value="<%= blog.get("title") %>" required>

        <label>Category</label>
        <select name="category" required>
            <option value="">Select Category</option>
            <option value="Tech" <%= "Tech".equals(blog.get("category")) ? "selected" : "" %>>Tech</option>
            <option value="Travel" <%= "Travel".equals(blog.get("category")) ? "selected" : "" %>>Travel</option>
            <option value="Food" <%= "Food".equals(blog.get("category")) ? "selected" : "" %>>Food</option>
            <option value="Spirituality" <%= "Spirituality".equals(blog.get("category")) ? "selected" : "" %>>Spirituality</option>
            <option value="History" <%= "History".equals(blog.get("category")) ? "selected" : "" %>>History</option>
            <option value="Sport" <%= "Sport".equals(blog.get("category")) ? "selected" : "" %>>Sport</option>
            <option value="Politics" <%= "Politics".equals(blog.get("category")) ? "selected" : "" %>>Politics</option>
        </select>

        <label>Content</label>
        <textarea name="content" rows="8" required><%= blog.get("content") %></textarea>

        <label>Current Image</label><br>
        <img src="<%= blog.get("image") %>" style="max-width:100%; height:150px;"><br><br>

        <label>Upload New Image <span class="note">(optional - leave blank to keep existing)</span></label>
        <input type="file" name="image" accept="image/*">

        <button type="submit">Update Blog</button>
    </form>
</div>

</body>
</html>
