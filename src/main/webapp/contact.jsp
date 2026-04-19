<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%
    String adminEmail = request.getParameter("adminEmail");
    if (adminEmail == null || adminEmail.trim().isEmpty()) {
        adminEmail = "vivektiwari@gmail.com";
    }
%>
<%
    List<Map<String, String>> receivedReplies = new ArrayList<>();
    String jdbcUrl = System.getenv("HARIOM_DB_URL");
    if (jdbcUrl == null || jdbcUrl.trim().isEmpty()) {
        jdbcUrl = "jdbc:mysql://localhost:3306/mspblog";
    }
    String dbUser = System.getenv("HARIOM_DB_USER");
    if (dbUser == null || dbUser.trim().isEmpty()) {
        dbUser = "root";
    }
    String dbPassword = System.getenv("HARIOM_DB_PASSWORD");
    if (dbPassword == null) {
        dbPassword = "Roman123@.";
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (Exception ignore) {
    }

    try (Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
        try (PreparedStatement create = con.prepareStatement(
                "CREATE TABLE IF NOT EXISTS contact_messages ("
                        + "id INT AUTO_INCREMENT PRIMARY KEY,"
                        + "user_email VARCHAR(190) NOT NULL,"
                        + "firstname VARCHAR(120) NOT NULL,"
                        + "lastname VARCHAR(120) NOT NULL,"
                        + "country VARCHAR(100) NOT NULL,"
                        + "user_message TEXT NOT NULL,"
                        + "admin_reply TEXT DEFAULT NULL,"
                        + "is_replied TINYINT(1) NOT NULL DEFAULT 0,"
                        + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,"
                        + "replied_at TIMESTAMP NULL DEFAULT NULL,"
                        + "INDEX idx_contact_user_email (user_email),"
                        + "INDEX idx_contact_created_at (created_at)"
                        + ") ENGINE=InnoDB")) {
            create.execute();
        }

        try (PreparedStatement ps = con.prepareStatement(
                "SELECT firstname, lastname, country, user_message, admin_reply, is_replied, created_at, replied_at "
                + "FROM contact_messages WHERE user_email = ? ORDER BY created_at DESC")) {
            ps.setString(1, userEmail);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("firstname", rs.getString("firstname"));
                    row.put("lastname", rs.getString("lastname"));
                    row.put("country", rs.getString("country"));
                    row.put("user_message", rs.getString("user_message"));
                    row.put("admin_reply", rs.getString("admin_reply"));
                    row.put("is_replied", String.valueOf(rs.getInt("is_replied")));
                    row.put("created_at", String.valueOf(rs.getTimestamp("created_at")));
                    row.put("replied_at", String.valueOf(rs.getTimestamp("replied_at")));
                    receivedReplies.add(row);
                }
            }
        }
    } catch (Exception ignore) {
        try (Connection con = DriverManager.getConnection(jdbcUrl, dbUser, "")) {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT firstname, lastname, country, user_message, admin_reply, is_replied, created_at, replied_at "
                    + "FROM contact_messages WHERE user_email = ? ORDER BY created_at DESC")) {
                ps.setString(1, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("firstname", rs.getString("firstname"));
                        row.put("lastname", rs.getString("lastname"));
                        row.put("country", rs.getString("country"));
                        row.put("user_message", rs.getString("user_message"));
                        row.put("admin_reply", rs.getString("admin_reply"));
                        row.put("is_replied", String.valueOf(rs.getInt("is_replied")));
                        row.put("created_at", String.valueOf(rs.getTimestamp("created_at")));
                        row.put("replied_at", String.valueOf(rs.getTimestamp("replied_at")));
                        receivedReplies.add(row);
                    }
                }
            }
        } catch (Exception ignore2) {
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        input[type=text], select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            margin-top: 6px;
            margin-bottom: 16px;
            resize: vertical;
            font-size: 16px;
        }

        input[type=submit] {
            background-color: #04AA6D;
            color: white;
            padding: 12px 20px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        input[type=submit]:hover {
            background-color: #45a049;
        }

        .container {
            border-radius: 5px;
            background-color: #f2f2f2;
            padding: 20px;
            margin: 30px;
        }

        .messages-section {
            border-radius: 5px;
            background-color: #f2f2f2;
            padding: 20px;
            margin: 30px;
            margin-top: 0;
        }

        .message-card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .message-meta {
            color: #555;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .message-label {
            font-weight: bold;
            color: #333;
            margin-top: 10px;
            margin-bottom: 4px;
        }

        .message-text {
            white-space: pre-wrap;
            color: #444;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 6px;
            padding: 10px;
        }

        .status-pill {
            display: inline-block;
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 999px;
            font-weight: bold;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }

        .status-replied {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .column {
            float: left;
            width: 50%;
            margin-top: 6px;
            padding: 20px;
        }

        .row:after {
            content: "";
            display: table;
            clear: both;
        }

        h2 {
            font-size: 28px;
            color: #333;
        }

        p {
            font-size: 16px;
            color: #666;
        }

        @media screen and (max-width: 600px) {
            .column, input[type=submit] {
                width: 100%;
                margin-top: 0;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div style="text-align:center">
        <h2>Contact Us</h2>
        <p>Have a question about our content or want to collaborate? Let’s build something great together—reach out today!</p>
    </div>
    <div class="row">
        <div class="column">
            <img src="<%= request.getContextPath() %>/assets/images/contact-image.jpg" style="width:100%; border-radius: 8px;">
        </div>
        <div class="column">
            <form action="<%= request.getContextPath() %>/ContactServlet" method="post">
                <!-- Admin Email Hidden Field -->
                <input type="hidden" name="adminEmail" value="<%= adminEmail %>">

                <label for="fname">First Name</label>
                <input type="text" id="fname" name="firstname" placeholder="Your name.." required>

                <label for="lname">Last Name</label>
                <input type="text" id="lname" name="lastname" placeholder="Your last name.." required>

                <label for="country">Country</label>
                <select id="country" name="country">
                    <option value="India">India</option>
                    <option value="Canada">Canada</option>
                    <option value="USA">USA</option>
                    <option value="Nepal">Nepal</option>
                </select>

                <label for="subject">Subject</label>
                <textarea id="subject" name="subject" placeholder="Write something.." style="height:170px" required></textarea>

                <input type="submit" value="Submit">
            </form>
        </div>
    </div>
</div>

<div class="messages-section">
    <div style="text-align:center">
        <h2>Your Messages & Replies</h2>
        <p>Track your submitted messages and admin replies here.</p>
    </div>

    <%
        if (receivedReplies.isEmpty()) {
    %>
        <div class="message-card">No messages found yet.</div>
    <%
        } else {
            for (Map<String, String> msg : receivedReplies) {
                boolean replied = "1".equals(msg.get("is_replied"));
    %>
        <div class="message-card">
            <div class="message-meta">
                <strong><%= msg.get("firstname") %> <%= msg.get("lastname") %></strong>
                | <%= msg.get("country") %>
                | Sent: <%= msg.get("created_at") %>
                <span class="status-pill <%= replied ? "status-replied" : "status-pending" %>">
                    <%= replied ? "Replied" : "Pending" %>
                </span>
            </div>

            <div class="message-label">Your Message</div>
            <div class="message-text"><%= msg.get("user_message") %></div>

            <% if (replied && msg.get("admin_reply") != null) { %>
                <div class="message-label">Admin Reply (<%= msg.get("replied_at") %>)</div>
                <div class="message-text"><%= msg.get("admin_reply") %></div>
            <% } %>
        </div>
    <%
            }
        }
    %>
</div>
</body>
</html>
