<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Existing Styles */
        body { font-family: 'Poppins', sans-serif; background-color: #f5f5f5; }

        .carousel-item img {
            width: 100%;
            height: 450px;
            object-fit: cover;
            filter: brightness(70%);
        }

        .hero-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: white;
            max-width: 80%;
        }

        .hero-content h1 {
            font-size: 2.8rem;
            font-weight: bold;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5);
        }

        .hero-content p {
            font-size: 1.2rem;
            text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
        }

        .blog-container { max-width: 1200px; margin: auto; padding: 10px; }
        .blog-header { padding: 10px; font-size: 40px; text-align: center; background: white; }
        .blog-row { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px; }
        .blog-leftcolumn { flex: 3; padding-right: 15px; }
        .blog-rightcolumn { flex: 1; padding-left: 15px; }
        .blog-card { background-color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .blog-img { width: 100%; height: 200px; object-fit: cover; border-radius: 8px; }

        @media screen and (max-width: 800px) {
            .blog-row { flex-direction: column; }
            .blog-leftcolumn, .blog-rightcolumn { padding: 0; }
        }

        /* Toast */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
    </style>
</head>
<body>

<!-- Hero Section -->
<div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="./assets/images/img1 (2).jpg" class="d-block w-100" alt="Hero Image">
        </div>
        <div class="carousel-item">
            <img src="./assets/images/img1 (3).jpg" class="d-block w-100" alt="Hero Image">
        </div>
        <div class="carousel-item">
            <img src="./assets/images/img1 (5).jpg" class="d-block w-100" alt="Hero Image">
        </div>
    </div>
    <div class="hero-content">
        <h1>Ideas, Stories & Insights That Inspire</h1>
        <p class="lead">Dive into a world of creativity, knowledge, and thought-provoking discussions.</p>
        <p><i class="fas fa-user"></i> By Rahul Yadav | </p>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>

<!-- Blog Section -->
<div class="blog-container">
    <div class="blog-header">
        <h2>Travel Blog</h2>
    </div>

    <div class="blog-row">
        <div class="blog-leftcolumn">
            <div class="blog-card">
                <h2>Beautiful Beach</h2>
                <h5>Title description, Dec 7, 2025</h5>
                <img src="./assets/images/shivrajpure01.avif" alt="Beach Image" class="blog-img">
                <p>Experience the serene beauty of the ocean.</p>
            </div>
            <div class="blog-card">
                <h2>Mountain Adventure</h2>
                <h5>Title description, Sep 2, 2025</h5>
                <img src="./assets/images/img1 (5).jpg" alt="Mountain Image" class="blog-img">
                <p>Explore the breathtaking mountain landscapes.</p>
            </div>
        </div>

        <div class="blog-rightcolumn">
            <div class="blog-card">
                <h2>About Me</h2>
                <a href="<%= request.getContextPath() %>/About.jsp">
                    <img src="./assets/images/aboutme.webp" alt="Profile Image" style="height:100px;" class="blog-img">
                    <p>Traveler and blogger sharing the best destinations.</p>
                </a>
            </div>
            <div class="blog-card">
                <h3>Popular Posts</h3>
                <img src="./assets/images/img1 (1).jpg" alt="Popular Post 1" class="blog-img">
            </div>
            <div class="blog-card">
                <h3>Follow Me</h3>
                <p>Stay updated with my latest travels.</p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="blogcard.jsp"/>



<!-- Bootstrap Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
