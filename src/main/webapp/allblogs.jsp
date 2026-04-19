<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>

<%
    if (request.getAttribute("blogs") == null) {
        response.sendRedirect(request.getContextPath() + "/AllBlogServlet");
        return;
    }

    List<Map<String, String>> blogs = (List<Map<String, String>>) request.getAttribute("blogs");
    List<String> categories = (List<String>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String searchQuery = (String) request.getAttribute("searchQuery");

    if (categories == null) categories = new ArrayList<>();
    if (blogs == null) blogs = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Blogs</title>
    <style>
        .allblog-body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
        }
        .allblog-container {
            max-width: 1200px;
            margin: auto;
            padding: 30px 20px;
        }
        .allblog-heading {
            text-align: center;
            margin-bottom: 30px;
        }
        .allblog-filters {
            text-align: center;
            margin-bottom: 30px;
        }
        .allblog-filters select,
        .allblog-filters input[type="text"] {
            padding: 8px 12px;
            margin: 0 5px;
            font-size: 14px;
        }
        .allblog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            min-height: 400px; /* consistent layout height */
        }
        .allblog-card-link {
            text-decoration: none;
            color: inherit;
        }
        .allblog-card {
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            height: 100%; /* make all cards same height */
        }
        .allblog-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        .allblog-content {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .allblog-content h3 {
            margin: 0 0 10px;
            font-size: 20px;
        }
        .allblog-content p {
            font-size: 14px;
            color: #555;
        }
        .allblog-no-blogs {
            text-align: center;
            color: #777;
            grid-column: 1 / -1;
        }
    </style>
    <script>
        let debounceTimer;
        function debounceSearch(input) {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                input.form.submit();
            }, 500); // 500ms delay
        }
    </script>
</head>
<body class="allblog-body">

<%@ include file="Navbar.jsp" %>

<div class="allblog-container">
    <h2 class="allblog-heading">All Blogs</h2>

    <div class="allblog-filters">
        <form method="get" action="<%= request.getContextPath() %>/AllBlogServlet">
            <select name="category" onchange="this.form.submit()">
                <option value="">All Categories</option>
                <% for (String cat : categories) { %>
                    <option value="<%= cat %>" <%= cat.equals(selectedCategory) ? "selected" : "" %>><%= cat %></option>
                <% } %>
            </select>

            <input type="text" name="search" placeholder="Search blogs..." value="<%= searchQuery != null ? searchQuery : "" %>" oninput="debounceSearch(this)" />
        </form>
    </div>

    <div class="allblog-grid">
        <% if (blogs.size() == 0) { %>
            <p class="allblog-no-blogs">No blogs available at the moment.</p>
        <% } else { %>
            <% for (Map<String, String> blog : blogs) { %>
                <a href="<%= request.getContextPath() %>/ReadBlogServlet?id=<%= blog.get("id") %>" class="allblog-card-link">
                    <div class="allblog-card">
                        <img src="<%= blog.get("image") %>" alt="Blog Image">
                        <div class="allblog-content">
                            <h3><%= blog.get("title") %></h3>
                            <p><strong>Category:</strong> <%= blog.get("category") %></p>
                            <p><%= blog.get("content").length() > 120 ? blog.get("content").substring(0, 120) + "..." : blog.get("content") %></p>
                            <p style="font-size: 12px; color: #999;"><strong>Author:</strong> <%= blog.get("author") %></p>
                        </div>
                    </div>
                </a>
            <% } %>
        <% } %>
    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>
