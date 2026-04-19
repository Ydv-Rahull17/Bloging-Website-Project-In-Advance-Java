<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile - Hariom.</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 40px 20px;
        }

        .glass-container {
            width: 100%;
            max-width: 550px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: slideUp 0.5s ease-out;
            position: relative;
            overflow: hidden;
        }

        .glass-container::before {
            content: '';
            position: absolute;
            top: -50px; left: -50px;
            width: 150px; height: 150px;
            background: rgba(99, 102, 241, 0.4);
            filter: blur(50px);
            border-radius: 50%;
            z-index: -1;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header-title {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(to right, #60a5fa, #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }

        .form-group label {
            font-weight: 600;
            color: #cbd5e1;
            font-size: 0.9rem;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .form-control {
            background: rgba(15, 23, 42, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 1rem;
            padding: 12px 15px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background: rgba(15, 23, 42, 0.6);
            border-color: #60a5fa;
            box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.2);
            color: white;
        }

        /* Override Readonly Input */
        .form-control[readonly] {
            background: rgba(255, 255, 255, 0.02);
            color: #94a3b8;
            cursor: not-allowed;
            border-color: rgba(255, 255, 255, 0.05);
        }

        .file-input-wrapper {
            position: relative;
            background: rgba(15, 23, 42, 0.4);
            border: 1px dashed rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .file-input-wrapper:hover {
            border-color: #a855f7;
            background: rgba(168, 85, 247, 0.05);
        }

        .file-input-wrapper input[type="file"] {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            opacity: 0;
            cursor: pointer;
            width: 100%; height: 100%;
        }

        .file-input-text {
            color: #94a3b8;
            font-size: 0.95rem;
            pointer-events: none;
        }
        
        .file-input-text i {
            font-size: 1.5rem;
            display: block;
            margin-bottom: 5px;
            color: #a855f7;
        }

        .btn-container {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 35px;
        }

        .btn {
            padding: 10px 25px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            background: rgba(239, 68, 68, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
            color: white;
            border-color: #ef4444;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            border: none;
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.5);
            background: linear-gradient(135deg, #34d399, #10b981);
        }

        .back-link {
            position: absolute;
            top: 20px;
            left: 20px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 1rem;
            transition: color 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .back-link:hover {
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="glass-container">
        <a href="<%= request.getContextPath() %>/ProfileServlet" class="back-link"><i class="fas fa-arrow-left"></i> Back</a>
        
        <h4 class="header-title">Edit Your Profile</h4> 
        
        <form method="post" action="<%=request.getContextPath()%>/EditProfileServlet" enctype="multipart/form-data">
            <div class="form-group mb-4">
                <label><i class="fas fa-user-edit me-2"></i> Full Name</label>
                <input type="text" class="form-control" name="fullname" placeholder="Enter your full name" required>
            </div>
            
            <%
                String userEmail = (String) session.getAttribute("userEmail");
            %>
            <div class="form-group mb-4">
                <label><i class="fas fa-envelope me-2"></i> Email Address</label>
                <input type="email" class="form-control" name="email" value="<%= userEmail != null ? userEmail : "" %>" readonly title="Email cannot be changed">
            </div>

            <div class="form-group mb-4">
                <label><i class="fas fa-lock me-2"></i> New Password <span style="font-size: 0.8rem; color: #64748b; font-weight: normal;">(Leave blank to keep current)</span></label>
                <input type="password" class="form-control" name="password" placeholder="Enter new password">
            </div>
            
            <div class="form-group mb-4">
                <label><i class="fas fa-camera-retro me-2"></i> Profile Picture</label>
                <div class="file-input-wrapper">
                    <input type="file" name="profilePic" accept="image/*">
                    <div class="file-input-text">
                        <i class="fas fa-cloud-upload-alt"></i>
                        Click or drag to upload new image
                    </div>
                </div>
            </div>

            <div class="btn-container">
                <button type="reset" class="btn btn-danger">Discard</button>
                <button type="submit" class="btn btn-success"><i class="fas fa-save me-2"></i> Save Changes</button>
            </div>
        </form>
    </div>
</body>
</html>
