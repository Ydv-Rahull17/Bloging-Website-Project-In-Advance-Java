<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        body {
            display: flex;
            height: 100vh;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
        }
        .card {
            width: 420px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            padding: 30px;
        }
        h2 {
            text-align: center;
            margin-bottom: 15px;
            color: #333;
        }
        .input-group {
            margin-bottom: 15px;
        }
        .input-group label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
            color: #555;
        }
        .input-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        .btn {
            width: 100%;
            padding: 10px;
            background: linear-gradient(90deg, #007bff, #0056b3);
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
        }
        .btn:hover {
            background: linear-gradient(90deg, #0056b3, #003d80);
        }
        .error-message {
            background-color: #ffe6e6;
            border: 1px solid #ff4d4d;
            color: #cc0000;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
            font-size: 14px;
        }
        .back {
            margin-top: 12px;
            text-align: center;
            font-size: 14px;
        }
        .back a {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="card">
    <h2>Reset Password</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error-message"><%= error %></div>
    <%
        }
        String token = (String) request.getAttribute("token");
        if (token == null) {
            token = request.getParameter("token");
        }
        boolean canReset = (token != null && !token.trim().isEmpty());
    %>

    <% if (canReset) { %>
    <form action="<%= request.getContextPath() %>/ResetPasswordServlet" method="post">
        <input type="hidden" name="token" value="<%= token %>">
        <div class="input-group">
            <label for="password">New Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="input-group">
            <label for="confirm_password">Confirm Password</label>
            <input type="password" id="confirm_password" name="confirm_password" required>
        </div>
        <button type="submit" class="btn">Update Password</button>
    </form>
    <% } %>

    <div class="back">
        <a href="<%= request.getContextPath() %>/login.jsp">Back to Login</a>
    </div>
</div>
</body>
</html>
