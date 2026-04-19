<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
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
        .container {
            display: flex;
            width:  1000px;
            height: 400px;
            background: white;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            border-radius: 12px;
            overflow: hidden;
        }
        .image-section {
            flex: 1.2;
            background: url('<%= request.getContextPath() %>/assets/images/img1 (2).jpg') no-repeat center center/cover;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            padding: 30px;
        }
        .image-section::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
        .image-text {
            position: relative;
            z-index: 2;
        }
        .image-text h2 {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .image-text p {
            font-size: 14px;
            max-width: 80%;
            text-align: center;
        }
        .login-section {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .login-section h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
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
            transition: 0.3s;
        }
        .btn:hover {
            background: linear-gradient(90deg, #0056b3, #003d80);
        }
        .remember {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #555;
        }
        .remember input {
            margin-right: 5px;
        }
        .register {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
            color: #555;
        }
        .register a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        .register a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                height: auto;
                width: 95%;
            }

            .image-section {
                display: none;
            }

            .login-section {
                padding: 30px;
            }
        }
    </style>
</head>
<body>

    <!-- Main Login Container -->
    <div class="container">
        
        <!-- Image Section -->
        <div class="image-section">
            <div class="image-text">
                <h2>Welcome to Website Hariom Blog</h2>
            </div>
        </div>

        <!-- Login Section -->
        <div class="login-section">
            <h2>USER LOGIN</h2>

            <!-- ✅ Error Message Block -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message"><%= error %></div>
            <%
                }
            %>
			
            <%
                String success = (String) session.getAttribute("success");
                if (success != null) {
            %>
                <div class="success-message"><%= success %></div>
            <%
                    session.removeAttribute("success"); // Remove after showing once
                }
            %>
			
            <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
                <div class="input-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="remember">
                    <label><input type="checkbox" name="remember"> Remember me</label>
                    <a href="<%= request.getContextPath() %>/ForgotPasswordServlet">Forgot password?</a>
                </div>
                <button type="submit" class="btn">Login</button>
            </form>

            <div class="register">
                Don't have an account? <a href="<%= request.getContextPath() %>/signup.jsp">Register here</a>
            </div>
        </div>

    </div>

</body>
</html>
