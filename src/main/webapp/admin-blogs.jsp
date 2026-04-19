<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Blogs - Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0f172a;
            --glass-bg: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.1);
            --primary-accent: #6366f1;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top left, #312e81, var(--bg-dark), #1e1b4b);
            background-attachment: fixed;
            color: var(--text-main);
            margin: 0;
            padding: 40px 20px;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h2 {
            margin: 0;
            font-size: 2.2rem;
            font-weight: 800;
            background: linear-gradient(to right, #f472b6, #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .back-btn {
            background: var(--glass-bg);
            color: var(--text-main);
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            border: 1px solid var(--glass-border);
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .table-container {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.5);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid var(--glass-border);
        }

        th {
            background: rgba(255, 255, 255, 0.05);
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: rgba(255, 255, 255, 0.02);
        }

        .category-badge {
            background: rgba(99, 102, 241, 0.2);
            color: #a5b4fc;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            border: 1px solid rgba(99, 102, 241, 0.3);
            display: inline-block;
        }

        .btn-delete {
            padding: 8px 16px;
            border: none;
            color: #fca5a5;
            background: rgba(239, 68, 68, 0.2);
            border: 1px solid rgba(239, 68, 68, 0.3);
            cursor: pointer;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-block;
        }

        .btn-delete:hover {
            background: rgba(239, 68, 68, 0.4);
        }

        @media (max-width: 768px) {
            table { display: block; overflow-x: auto; white-space: nowrap; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>All Published Blogs</h2>
            <a href="<%= request.getContextPath() %>/admin-dashboard.jsp" class="back-btn">Dashboard</a>
        </div>

        <div class="table-container">
            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Author Name</th>
                    <th>Publish Date</th>
                    <th>Action</th>
                </tr>
                <%
                    List<Map<String, String>> blogs = (List<Map<String, String>>) request.getAttribute("blogs");
                    if (blogs != null) {
                        for (Map<String, String> blog : blogs) {
                %>
                <tr>
                    <td>#<%= blog.get("id") %></td>
                    <td style="font-weight: 600;"><%= blog.get("title") %></td>
                    <td><span class="category-badge"><%= blog.get("category") %></span></td>
                    <td><%= blog.get("fullname") %></td>
                    <td><%= blog.get("created_at") %></td>
                    <td>
                        <a class="btn-delete" href="<%= request.getContextPath() %>/AdminDeleteBlogServlet?id=<%= blog.get("id") %>" onclick="return confirm('Are you sure you want to delete this blog?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else { 
                %>
                <tr><td colspan="6" style="text-align: center; color: var(--text-muted);">No blogs found.</td></tr>
                <% } %>
            </table>
        </div>
    </div>
</body>
</html>
