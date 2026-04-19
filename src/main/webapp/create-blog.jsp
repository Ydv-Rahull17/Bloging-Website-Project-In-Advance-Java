<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page session="true" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Blog - Hariom.</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --bg-gradient: linear-gradient(135deg, #f0f9ff 0%, #e0e7ff 100%);
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --input-border: #cbd5e1;
            --input-bg: #ffffff;
            --card-bg: rgba(255, 255, 255, 0.85);
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: var(--bg-gradient);
            background-attachment: fixed;
            margin: 0;
            padding: 40px 20px;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .back-link {
            position: absolute;
            top: 30px;
            left: 40px;
            color: var(--text-dark);
            text-decoration: none;
            font-size: 1.1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.5);
            padding: 10px 20px;
            border-radius: 30px;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .back-link:hover {
            background: rgba(255, 255, 255, 0.9);
            transform: translateX(-5px);
            color: var(--primary-color);
        }

        .container {
            width: 100%;
            max-width: 650px;
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            padding: 45px;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08), 0 1px 3px rgba(0,0,0,0.05);
            animation: fadeIn 0.5s ease-out;
            position: relative;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header-content {
            text-align: center;
            margin-bottom: 35px;
        }

        h2 {
            font-size: 2.2rem;
            font-weight: 700;
            margin: 0 0 10px 0;
            color: var(--text-dark);
            background: linear-gradient(to right, #4f46e5, #0ea5e9);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-content p {
            color: var(--text-muted);
            margin: 0;
            font-size: 1.05rem;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        input[type="text"],
        select,
        textarea {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid var(--input-border);
            border-radius: 12px;
            background: var(--input-bg);
            color: var(--text-dark);
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 150px;
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2364748b' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 15px;
        }

        .file-upload-wrapper {
            position: relative;
            background: var(--input-bg);
            border: 2px dashed var(--input-border);
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .file-upload-wrapper:hover {
            border-color: var(--primary-color);
            background: rgba(79, 70, 229, 0.02);
        }

        .file-upload-wrapper input[type="file"] {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .file-upload-text {
            color: var(--text-muted);
            pointer-events: none;
        }

        .file-upload-text i {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 10px;
            display: block;
        }

        button.submit-btn {
            width: 100%;
            padding: 16px;
            background: var(--primary-color);
            border: none;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            margin-top: 10px;
        }

        button.submit-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
        }

        @media (max-width: 768px) {
            .container { padding: 30px 20px; }
            h2 { font-size: 1.8rem; }
            .back-link { top: 15px; left: 15px; padding: 8px 15px; }
        }
    </style>
</head>
<body>

<a href="<%= request.getContextPath() %>/index.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Home</a>

<div class="container">
    <div class="header-content">
        <h2>Create a New Blog</h2>
        <p>Share your stories, ideas, and expertise with the world.</p>
    </div>
    
    <form action="<%= request.getContextPath() %>/PublishBlogServlet" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label><i class="fas fa-pen-nib me-2"></i> Blog Title</label>
            <input type="text" name="title" placeholder="Give your blog a catchy title" required>
        </div>

        <div class="form-group">
            <label><i class="fas fa-folder-open me-2"></i> Category</label>
            <select name="category" required>
                <option value="">Select a relevant category</option>
                <option value="Tech">Tech & Innovation</option>
                <option value="Travel">Travel & Adventure</option>
                <option value="Food">Food & Culture</option>
                <option value="Spirituality">Spirituality</option>
                <option value="History">History</option>
                <option value="Sport">Sports & Fitness</option>
                <option value="Politics">Politics</option>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-align-left me-2"></i> Content</label>
            <textarea name="content" placeholder="Start writing your amazing blog post here..." required></textarea>
        </div>

        <div class="form-group">
            <label><i class="fas fa-image me-2"></i> Cover Image <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: normal;">(JPG, PNG, WebP)</span></label>
            <div class="file-upload-wrapper">
                <input type="file" name="image" accept="image/*" required>
                <div class="file-upload-text">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <strong>Click to upload</strong> or drag and drop<br>
                    <span style="font-size: 0.85rem;">High-quality images work best</span>
                </div>
            </div>
        </div>

        <button type="submit" class="submit-btn"><i class="fas fa-paper-plane me-2"></i> Publish Blog</button>
    </form>
</div>

</body>
</html>
