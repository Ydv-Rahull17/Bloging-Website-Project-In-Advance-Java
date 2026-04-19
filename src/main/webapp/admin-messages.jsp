<%@ page import="java.util.*" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0f172a;
            --glass-bg: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.1);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
        }
        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top right, #312e81, var(--bg-dark), #1e1b4b);
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
            background: linear-gradient(to right, #60a5fa, #a855f7);
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
        }
        .message-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .meta {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 10px;
        }
        .label {
            font-weight: 700;
            margin-top: 10px;
            margin-bottom: 6px;
        }
        .text-box {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            padding: 12px;
            white-space: pre-wrap;
        }
        textarea {
            width: 100%;
            margin-top: 10px;
            min-height: 100px;
            border-radius: 8px;
            border: 1px solid var(--glass-border);
            padding: 10px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            resize: vertical;
            font-family: inherit;
        }
        .btn {
            margin-top: 10px;
            border: 1px solid rgba(59, 130, 246, 0.3);
            background: rgba(59, 130, 246, 0.2);
            color: #93c5fd;
            border-radius: 8px;
            padding: 8px 16px;
            cursor: pointer;
            font-weight: 600;
            font-family: inherit;
        }
        .status {
            display: inline-block;
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 999px;
            font-weight: 600;
            margin-left: 8px;
        }
        .pending {
            background: rgba(234, 179, 8, 0.2);
            color: #fde68a;
            border: 1px solid rgba(234, 179, 8, 0.4);
        }
        .done {
            background: rgba(34, 197, 94, 0.2);
            color: #86efac;
            border: 1px solid rgba(34, 197, 94, 0.4);
        }
        .note {
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .ok {
            background: rgba(34, 197, 94, 0.2);
            color: #86efac;
            border: 1px solid rgba(34, 197, 94, 0.3);
        }
        .err {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>User Messages</h2>
        <a href="<%= request.getContextPath() %>/admin-dashboard.jsp" class="back-btn">Back to Dashboard</a>
    </div>

    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if ("replied".equals(success)) {
    %>
    <div class="note ok">Reply sent successfully.</div>
    <% } else if (error != null) { %>
    <div class="note err">Could not process request. Please try again.</div>
    <% } %>

    <%
        List<Map<String, String>> messages = (List<Map<String, String>>) request.getAttribute("messages");
        if (messages == null || messages.isEmpty()) {
    %>
    <div class="message-card">No messages found.</div>
    <% } else {
        for (Map<String, String> msg : messages) {
            boolean replied = "1".equals(msg.get("is_replied"));
    %>
    <div class="message-card">
        <div class="meta">
            <strong>#<%= msg.get("id") %></strong>
            | <%= msg.get("firstname") %> <%= msg.get("lastname") %> (<%= msg.get("user_email") %>)
            | <%= msg.get("country") %>
            | Sent: <%= msg.get("created_at") %>
            <span class="status <%= replied ? "done" : "pending" %>"><%= replied ? "REPLIED" : "PENDING" %></span>
        </div>

        <div class="label">User Message</div>
        <div class="text-box"><%= msg.get("user_message") %></div>

        <% if (replied && msg.get("admin_reply") != null) { %>
        <div class="label">Admin Reply</div>
        <div class="text-box"><%= msg.get("admin_reply") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/AdminReplyMessageServlet" method="post">
            <input type="hidden" name="messageId" value="<%= msg.get("id") %>">
            <textarea name="replyText" required placeholder="Write reply for this user..."><%= replied && msg.get("admin_reply") != null ? msg.get("admin_reply") : "" %></textarea>
            <button type="submit" class="btn"><%= replied ? "Update Reply" : "Send Reply" %></button>
        </form>
    </div>
    <%  }
       } %>
</div>
</body>
</html>
