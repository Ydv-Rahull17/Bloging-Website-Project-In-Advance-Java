<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>About Us - Hariom.</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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
            margin: 0;
            background: radial-gradient(circle at top center, #312e81, var(--bg-dark), #1e1b4b);
            background-attachment: fixed;
            color: var(--text-main);
            min-height: 100vh;
        }

        .back-button {
            position: absolute;
            top: 30px;
            left: 40px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid var(--glass-border);
            color: white;
            font-size: 1.2rem;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            cursor: pointer;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .back-button:hover {
            background: rgba(99, 102, 241, 0.3);
            border-color: #6366f1;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(99, 102, 241, 0.3);
        }

        .about-section {
            padding: 100px 20px 60px;
            text-align: center;
            position: relative;
        }

        .about-section h1 {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 25px;
            background: linear-gradient(to right, #60a5fa, #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .about-section p {
            font-size: 1.2rem;
            color: var(--text-muted);
            max-width: 800px;
            margin: 0 auto 15px;
            line-height: 1.8;
        }

        .team-heading {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 800;
            margin: 40px 0 20px;
            color: white;
            position: relative;
        }

        .about-row {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
            padding: 20px 40px 80px;
        }

        .about-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            overflow: hidden;
            text-align: center;
            width: 350px;
            transition: all 0.4s ease;
            position: relative;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
        }
        
        .about-card::before {
            content: '';
            position: absolute;
            top: -50px; left: 50%;
            transform: translateX(-50%);
            width: 150px; height: 150px;
            background: rgba(168, 85, 247, 0.3);
            filter: blur(60px);
            border-radius: 50%;
            z-index: -1;
        }

        .about-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.6);
            border-color: rgba(99, 102, 241, 0.4);
        }

        .about-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-bottom: 2px solid rgba(255, 255, 255, 0.05);
        }

        .about-container {
            padding: 30px 20px;
        }
        
        .about-container h2 {
            font-weight: 800;
            font-size: 1.6rem;
            margin-bottom: 5px;
            color: white;
        }

        .about-title {
            color: #a855f7;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 20px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .about-container p {
            color: #cbd5e1;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        /* Contact Button */
        .about-button {
            display: inline-block;
            text-decoration: none;
            padding: 12px 30px;
            color: white;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            text-align: center;
            border-radius: 25px;
            font-weight: 600;
            margin-top: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
            letter-spacing: 1px;
        }

        .about-button:hover {
            background: linear-gradient(135deg, #a855f7, #6366f1);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.6);
            color: white;
        }
        
        @media screen and (max-width: 768px) {
            .about-section h1 { font-size: 2.5rem; }
            .back-button { top: 15px; left: 15px; width: 40px; height: 40px; }
        }
    </style>
</head>
<body>

    <button class="back-button" onclick="goHome()" title="Go Back">
        <i class="fa fa-arrow-left"></i>
    </button>

    <div class="about-section">
        <h1>About Us</h1>
        <p>Welcome to our blogging platform, where revolutionary ideas come to life!</p>
        <p>We are passionate about sharing knowledge, experiences, and stories through engaging and informative content.</p>
        <p>Our platform is designed to be fully responsive, ensuring a seamless and beautiful reading experience on any device.</p>
    </div>

    <h2 class="team-heading">Meet The Team</h2>
    <div class="about-row">
        <div class="about-card">
            <img src="assets/images/future_team_member.png" alt="Prince Chaudhari Avatar">
            <div class="about-container">
                <h2>VIVEK TIWARI</h2>
                <p class="about-title">Backend Developer</p>
                <p>Focused on building secure, scalable, and futuristic web architectures.</p>
                <p style="font-size: 0.85rem; color: #94a3b8;"><i class="fas fa-envelope"></i> vivektiwari@gmail.com</p>
                <a href="<%= request.getContextPath() %>/contact.jsp?adminEmail=vivektiwari@gmail.com" class="about-button"><i class="fas fa-paper-plane me-2"></i> Contact</a>
            </div>
        </div>
    </div>

    <script>
        function goHome() {
            window.location.href = "<%= request.getContextPath() %>/index.jsp"; 
        }
    </script>

</body>
</html>
