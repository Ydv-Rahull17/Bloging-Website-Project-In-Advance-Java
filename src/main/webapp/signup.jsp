<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign Up</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
      }
      body {
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
        padding: 20px;
      }
      .container {
        display: flex;
        width: 1000px;
        max-width: 100%;
        min-height: 560px;
        background: white;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        border-radius: 12px;
        overflow: hidden;
      }
      .image-section {
        flex: 1.1;
        background: url("<%= request.getContextPath() %>/assets/images/img1 (3).jpg")
          no-repeat center center/cover;
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 30px;
        color: white;
      }
      .image-section::before {
        content: "";
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.45);
      }
      .image-text {
        position: relative;
        z-index: 2;
        text-align: center;
      }
      .image-text h2 {
        font-size: 30px;
        margin-bottom: 10px;
      }
      .image-text p {
        font-size: 14px;
        line-height: 1.6;
      }
      .form-section {
        flex: 1;
        padding: 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
      }
      .form-section h2 {
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
      .input-group {
        margin-bottom: 14px;
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
        font-size: 15px;
      }
      .btn {
        width: 100%;
        padding: 11px;
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
      .login-link {
        text-align: center;
        margin-top: 15px;
        font-size: 14px;
        color: #555;
      }
      .login-link a {
        color: #007bff;
        text-decoration: none;
        font-weight: bold;
      }
      .login-link a:hover {
        text-decoration: underline;
      }
      @media (max-width: 768px) {
        .container {
          flex-direction: column;
        }
        .image-section {
          min-height: 220px;
        }
        .form-section {
          padding: 30px;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="image-section">
        <div class="image-text">
          <h2>Create Your Account</h2>
          <p>
            Join the Hariom Blog community and start sharing your stories,
            ideas, and experiences.
          </p>
        </div>
      </div>

      <div class="form-section">
        <h2>USER SIGN UP</h2>
        <%
          String error = (String) session.getAttribute("error");
          if (error != null) {
        %>
          <div class="error-message"><%= error %></div>
        <%
            session.removeAttribute("error");
          }
        %>
        <form
          action="<%= request.getContextPath() %>/RegisterServlet"
          method="post"
          enctype="multipart/form-data"
        >
          <div class="input-group">
            <label for="fullname">Full Name</label>
            <input type="text" id="fullname" name="fullname" required />
          </div>
          <div class="input-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required />
          </div>
          <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required />
          </div>
          <div class="input-group">
            <label for="confirm_password">Confirm Password</label>
            <input
              type="password"
              id="confirm_password"
              name="confirm_password"
              required
            />
          </div>
          <div class="input-group">
            <label for="profile_pic">Profile Picture</label>
            <input
              type="file"
              id="profile_pic"
              name="profile_pic"
              accept="image/*"
              required
            />
          </div>
          <button type="submit" class="btn">Sign Up</button>
        </form>

        <div class="login-link">
          Already have an account?
          <a href="<%= request.getContextPath() %>/login.jsp">Login here</a>
        </div>
      </div>
    </div>
  </body>
</html>
