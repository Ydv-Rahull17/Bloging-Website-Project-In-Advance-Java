<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Travel Blog</title>
<style>
  /* Blog Card Styles */
    .blog-card {
        border-radius: 15px;
        overflow: hidden;
        transition: 0.4s ease-in-out;
        background: #fff;
        border: none;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        position: relative;
    }

    .blog-card img {
        width: 100%;
        height: 230px;
        object-fit: cover;
        border-top-left-radius: 15px;
        border-top-right-radius: 15px;
        transition: transform 0.3s ease-in-out;
    }

    .blog-card:hover img {
        transform: scale(1.05);
    }

    .blog-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    }

    .blog-card .card-body {
        padding: 25px;
        text-align: center;
        position: relative;
    }

    .blog-card .badge {
        font-size: 0.85rem;
        padding: 6px 12px;
        border-radius: 15px;
        font-weight: 600;
    }

    .card-title {
        font-size: 1.5rem;
        font-weight: bold;
        margin-top: 10px;
        color: #222;
        transition: color 0.3s;
    }

    .blog-card:hover .card-title {
        color: #0066e0;
    }

    .card-text {
        font-size: 1rem;
        color: #666;
        margin-bottom: 15px;
    }

    /* Read More Button */
    .read-more-btn {
        display: inline-block;
        padding: 10px 18px;
        background: linear-gradient(45deg, #0066e0, #0099ff);
        color: white;
        border-radius: 25px;
        text-decoration: none;
        font-size: 1rem;
        font-weight: bold;
        transition: all 0.3s ease-in-out;
        box-shadow: 0 4px 10px rgba(0, 102, 224, 0.3);
        position: relative;
        overflow: hidden;
    }

    .read-more-btn:hover {
        background: linear-gradient(45deg, #004bb7, #0077cc);
        text-decoration: none;
        box-shadow: 0 6px 15px rgba(0, 102, 224, 0.5);
        transform: translateY(-1px);
    }

    /* Glow Effect on Hover */
    .blog-card:hover .read-more-btn {
        animation: glow 1s infinite alternate;
    }

    @keyframes glow {
        0% { box-shadow: 0 4px 10px rgba(0, 102, 224, 0.3); }
        100% { box-shadow: 0 6px 20px rgba(0, 102, 224, 0.6); }
    }
</style>
<!-- FontAwesome for Icons -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>

<!-- Blog Section -->
<div class="container mt-5">
    <h2 class="text-center">🌍 Blog Categories</h2>
    <p class="text-center">Read inspiring stories.</p>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card blog-card">
                <img src="<%= request.getContextPath() %>/assets/images/img2.jpg" class="card-img-top" alt="Blog 1">
                <div class="card-body">
                    <span class="badge bg-info">#Technology</span>
                    <h5 class="card-title">Cyber Security</h5>
                   <p class="card-text"> Adding extra security helps protect your system. </p>
                    <small><i class="fas fa-user"></i> YUGMI </small>
                    <br><br>
                    <a href="<%= request.getContextPath() %>/AllBlogServlet" class="read-more-btn">Read More →</a>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card blog-card">
                <img src="<%= request.getContextPath() %>/assets/images/virat.webp" class="card-img-top" alt="Blog 2">
                <div class="card-body">
                    <span class="badge bg-success">#Sports</span>
                    <h5 class="card-title">Virat Kohli</h5>
                    <p class="card-text">The Journey of Virat Kohli: From Young Talent to Cricket Legend</p>
                    <small><i class="fas fa-user"></i> RAHUL</small>
                    <br><br>
                    <a href="<%= request.getContextPath() %>/AllBlogServlet" class="read-more-btn">Read More →</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card blog-card">
                <img src="<%= request.getContextPath() %>/assets/images/Collagen-Naturally.webp" class="card-img-top" alt="Blog 3">
                <div class="card-body">
                    <span class="badge bg-warning">#Health</span>
                    <h5 class="card-title">Plant-Based Food</h5>
                    <p class="card-text">The Best Plant-Based Foods To Build Collagen Naturally</p>
                    <small><i class="fas fa-user"></i> VIVEK</small>
                    <br><br>
                    <a href="<%= request.getContextPath() %>/AllBlogServlet" class="read-more-btn">Read More →</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
