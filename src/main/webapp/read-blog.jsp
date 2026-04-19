<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String blogId = request.getParameter("id");
    if (blogId == null || blogId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/AllBlogServlet");
        return;
    }

    String jdbcURL = "jdbc:mysql://localhost:3306/mspblog";
    String dbUser = "root";
    String dbPass = "Roman123@.";

    String title = "", content = "", image = "", category = "", author = "", createdAt = "";
    boolean likedByUser = false;
    int likeCount = 0;

    String userEmail = (String) session.getAttribute("userEmail");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn;
    try {
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
    } catch (SQLException ex) {
        conn = DriverManager.getConnection(jdbcURL, dbUser, "");
    }

    PreparedStatement blogStmt = conn.prepareStatement("SELECT b.*, u.fullname FROM blog b JOIN user u ON b.author_email = u.email WHERE b.id = ?");
    blogStmt.setInt(1, Integer.parseInt(blogId));
    ResultSet blogRs = blogStmt.executeQuery();

    if (blogRs.next()) {
        title = blogRs.getString("title");
        content = blogRs.getString("content");
        image = blogRs.getString("image");
        category = blogRs.getString("category");
        author = blogRs.getString("fullname");
        createdAt = blogRs.getString("created_at");
    }

    PreparedStatement likeCountStmt = conn.prepareStatement("SELECT COUNT(*) FROM likes WHERE blog_id = ?");
    likeCountStmt.setInt(1, Integer.parseInt(blogId));
    ResultSet countRs = likeCountStmt.executeQuery();
    if (countRs.next()) {
        likeCount = countRs.getInt(1);
    }

    if (userEmail != null) {
        PreparedStatement likedStmt = conn.prepareStatement("SELECT * FROM likes WHERE blog_id = ? AND user_email = ?");
        likedStmt.setInt(1, Integer.parseInt(blogId));
        likedStmt.setString(2, userEmail);
        ResultSet likedRs = likedStmt.executeQuery();
        likedByUser = likedRs.next();
    }

    PreparedStatement commentStmt = conn.prepareStatement(
        "SELECT c.*, u.fullname, u.profile_pic FROM comments c JOIN user u ON c.user_email = u.email WHERE blog_id = ? ORDER BY c.created_at DESC"
    );
    commentStmt.setInt(1, Integer.parseInt(blogId));
    ResultSet commentRs = commentStmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background-color: #f1f1f1;
            color: #222;
            transition: background-color 0.3s, color 0.3s;
        }
        .dark-mode {
            background-color: #121212;
            color: #eee;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: background-color 0.3s;
        }
        .dark-mode .container {
            background-color: #1e1e1e;
        }
        h1 {
            margin-bottom: 10px;
            font-size: 2rem;
        }
        img.blog-img {
            width: 100%;
            border-radius: 12px;
            margin: 20px 0;
        }
        .meta {
            font-size: 0.9rem;
            color: gray;
        }
        .heart-btn {
            font-size: 28px;
            border: none;
            background: none;
            cursor: pointer;
            color: <%= likedByUser ? "red" : "#bbb" %>;
            transition: color 0.3s transform 0.2s;
        }
        .heart-btn:hover {
            transform: scale(1.2);
        }
        #likeCount {
            font-weight: bold;
            margin-left: 10px;
        }
        .comment-box {
            margin-top: 40px;
        }
        textarea {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            resize: vertical;
            font-size: 1rem;
        }
        button[type="submit"], .delete-btn {
            margin-top: 10px;
            background-color: #007BFF;
            border: none;
            padding: 10px 16px;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
        }
        .delete-btn {
            background-color: #dc3545;
        }
        .comments-section {
            margin-top: 30px;
        }
        .comment {
            display: flex;
            gap: 12px;
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 12px;
            margin-bottom: 12px;
            align-items: flex-start;
            justify-content: space-between;
        }
        .dark-mode .comment {
            background-color: #2c2c2c;
        }
        .comment img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
        }
        .comment-content {
            flex-grow: 1;
        }
        .comment small {
            color: #888;
            font-size: 0.75rem;
        }
        .dark-mode .comment small {
            color: #ccc;
        }
        .toggle-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 8px 12px;
            background: #555;
            color: #fff;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-size: 0.9rem;
        }
        .dark-mode .toggle-btn {
            background: #ccc;
            color: #222;
        }
    </style>
</head>
<body>
    <button class="toggle-btn" onclick="toggleMode()"> Theme</button>

    <div class="container">
        <h1><%= title %></h1>
        <p class="meta">Category: <%= category %> | Author: <%= author %> | Published: <%= createdAt %></p>
        <img src="<%= image %>" alt="Blog Image" class="blog-img">
        <p><%= content.replaceAll("\n", "<br>") %></p>

        <!-- Like -->
        <button id="likeBtn" class="heart-btn" onclick="likeBlog()">&#10084;</button>
        <span id="likeCount"><%= likeCount %> like<%= likeCount == 1 ? "" : "s" %></span>

        <!-- Comment -->
        <div class="comment-box">
            <h3>Leave a Comment</h3>
            <form id="commentForm">
                <textarea id="commentInput" rows="4" placeholder="Write your thoughts here..." required></textarea><br>
                <button type="submit">Post Comment</button>
            </form>
        </div>

        <!-- All Comments -->
        <div class="comments-section" id="commentsSection">
            <h3>Comments</h3>
            <%
                while (commentRs.next()) {
                    int commentId = commentRs.getInt("id");
                    String fullname = commentRs.getString("fullname");
                    String profilePic = commentRs.getString("profile_pic");
                    String commentText = commentRs.getString("comment");
                    String commentTime = commentRs.getString("created_at");
                    String commentUser = commentRs.getString("user_email");
            %>
                <div class="comment" id="comment-<%= commentId %>">
                    <img src="<%= (profilePic != null && !profilePic.isEmpty()) ? (request.getContextPath() + "/" + profilePic) : (request.getContextPath() + "/assets/images/user.png") %>" alt="Profile">
                    <div class="comment-content">
                        <strong><%= fullname %></strong><br>
                        <%= commentText %><br>
                        <small><%= commentTime %></small>
                    </div>
                    <% if (userEmail != null && userEmail.equals(commentUser)) { %>
                        <button class="delete-btn" onclick="deleteComment(<%= commentId %>)">Delete</button>
                    <% } %>
                </div>
            <%
                }
            %>
        </div>
    </div>

    <script>
        let liked = <%= likedByUser %>;

        function likeBlog() {
            fetch("<%= request.getContextPath() %>/LikeServlet", {
                method: "POST",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: "blogId=" + <%= blogId %>
            }).then((response) => {
                if (response.status === 401) {
                    window.location.href = "<%= request.getContextPath() %>/login.jsp";
                    return;
                }
                liked = !liked;
                const btn = document.getElementById("likeBtn");
                const countSpan = document.getElementById("likeCount");
                let count = parseInt(countSpan.innerText);
                if (liked) {
                    btn.style.color = "red";
                    countSpan.innerText = (count + 1) + " like" + (count + 1 === 1 ? "" : "s");
                } else {
                    btn.style.color = "#bbb";
                    countSpan.innerText = (count - 1) + " like" + (count - 1 === 1 ? "" : "s");
                }
            });
        }

        function toggleMode() {
            document.body.classList.toggle("dark-mode");
        }

        document.getElementById("commentForm").addEventListener("submit", function (e) {
            e.preventDefault();
            const commentText = document.getElementById("commentInput").value.trim();
            if (!commentText) return;

            fetch("<%= request.getContextPath() %>/CommentServlet", {
                method: "POST",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: "blogId=" + <%= blogId %> + "&comment=" + encodeURIComponent(commentText)
            })
            .then(response => {
                if (response.status === 401) {
                    window.location.href = "<%= request.getContextPath() %>/login.jsp";
                    return;
                }
                return response.text();
            })
            .then(html => {
                if (!html) return;
                const commentsSection = document.getElementById("commentsSection");
                const tempDiv = document.createElement("div");
                tempDiv.innerHTML = html;
                commentsSection.insertBefore(tempDiv.firstElementChild, commentsSection.children[1]);
                document.getElementById("commentInput").value = "";
            });
        });

        function deleteComment(commentId) {
            if (!confirm("Delete this comment?")) return;
            fetch("<%= request.getContextPath() %>/CommentServlet?commentId=" + commentId, {
                method: "DELETE"
            }).then(response => {
                if (response.ok) {
                    const commentDiv = document.getElementById("comment-" + commentId);
                    if (commentDiv) commentDiv.remove();
                } else {
                    alert("Failed to delete comment.");
                }
            });
        }
    </script>
</body>
</html>
