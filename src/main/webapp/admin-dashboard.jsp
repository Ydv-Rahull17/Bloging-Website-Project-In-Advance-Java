<%@ page session="true" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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
            background: radial-gradient(circle at top right, #312e81, var(--bg-dark), #1e1b4b);
            background-attachment: fixed;
            color: var(--text-main);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--glass-border);
        }

        .header h1 {
            margin: 0;
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(to right, #a855f7, #6366f1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logout-btn {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            border: 1px solid rgba(239, 68, 68, 0.3);
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.4);
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(239, 68, 68, 0.3);
        }

        .toast {
            background: rgba(34, 197, 94, 0.2);
            color: #86efac;
            border: 1px solid rgba(34, 197, 94, 0.3);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 600;
        }

        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            text-decoration: none;
            color: var(--text-main);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
            min-height: 180px;
        }

        .glass-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .glass-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.5);
            border-color: rgba(255, 255, 255, 0.3);
        }

        .glass-card:hover::before {
            opacity: 1;
        }

        .glass-card h3 {
            font-size: 1.5rem;
            margin: 0 0 10px 0;
            font-weight: 600;
            z-index: 1;
        }

        .glass-card p {
            color: var(--text-muted);
            margin: 0;
            font-size: 0.95rem;
            z-index: 1;
        }

        .icon-wrapper {
            background: rgba(255,255,255,0.1);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 1.5rem;
            z-index: 1;
        }

        .card-users .icon-wrapper { color: #60a5fa; background: rgba(96, 165, 250, 0.2); }
        .card-blogs .icon-wrapper { color: #f472b6; background: rgba(244, 114, 182, 0.2); }
        .card-messages .icon-wrapper { color: #22d3ee; background: rgba(34, 211, 238, 0.2); }
        .card-home .icon-wrapper { color: #34d399; background: rgba(52, 211, 153, 0.2); }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>Admin Control Panel</h1>
            <a href="<%= request.getContextPath() %>/admin-logout.jsp" class="logout-btn">Sign Out</a>
        </div>

        <% String msg = request.getParameter("success"); %>
        <% if (msg != null) { %>
            <div class="toast">
                Blog successfully <%= msg %>!
            </div>
        <% } %>

        <div class="grid-container">
            <a href="<%= request.getContextPath() %>/ViewUsersServlet" class="glass-card card-users">
                <div class="icon-wrapper">&#128101;</div>
                <h3>Manage Users</h3>
                <p>View, manage, or delete registered accounts.</p>
            </a>

            <a href="<%= request.getContextPath() %>/ViewBlogsServlet" class="glass-card card-blogs">
                <div class="icon-wrapper">&#128221;</div>
                <h3>Manage Blogs</h3>
                <p>Monitor and oversee all published blogs.</p>
            </a>

            <a href="<%= request.getContextPath() %>/AdminViewMessagesServlet" class="glass-card card-messages">
                <div class="icon-wrapper">&#128172;</div>
                <h3>Messages</h3>
                <p>Read user contact messages and reply to users.</p>
            </a>

            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank" class="glass-card card-home">
                <div class="icon-wrapper">&#127968;</div>
                <h3>Public Homepage</h3>
                <p>View the live website as a user.</p>
            </a>
        </div>
    </div>
</body>
</html>
