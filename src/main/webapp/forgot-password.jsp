<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
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
            margin-bottom: 12px;
            color: #333;
        }
        p {
            text-align: center;
            color: #555;
            margin-bottom: 20px;
            font-size: 14px;
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
            color: #fff;
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
        .success-message {
            background-color: #e6ffea;
            border: 1px solid #28a745;
            color: #155724;
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
    <h2>Forgot Password</h2>
    <p>Enter your registered email to receive a reset link.</p>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error-message"><%= error %></div>
    <%
        }
        String success = (String) request.getAttribute("success");
        if (success != null) {
    %>
        <div class="success-message"><%= success %></div>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/ForgotPasswordServlet" method="post">
        <div class="input-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
        </div>
        <button type="submit" class="btn">Send Reset Link</button>
    </form>

    <div class="back">
        <a href="<%= request.getContextPath() %>/login.jsp">Back to Login</a>
    </div>
</div>
</body>
</html>
