<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Navbar</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body { font-family: 'Poppins', sans-serif; background-color: #f5f5f5; }
.navbar { background: linear-gradient(135deg, #007bff, #0056b3); padding: 10px 0; }
.navbar-brand { color: white !important; font-size: 1.5rem; font-weight: bold; text-decoration: none; }
.nav-link { color: white !important; font-size: 1.1rem; }
.nav-link:hover { color: #f8f9fa !important; text-decoration: underline; }

.navbar-signup-btn {
    background: #ff6f61 !important;  
    color: white !important;
    border: none !important;
}
.navbar-signup-btn:hover {
    background: #e64c3c !important;
}

.profile-btn {
    background-color: white; 
    border: none; 
    padding: 6px 14px;  
    border-radius: 8px; 
    display: flex; 
    align-items: center; 
    gap: 8px;
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2); 
    cursor: pointer;
}
.profile-icon {
    width: 35px; 
    height: 35px; 
    border-radius: 50%;  
    object-fit: cover;
    border: 2px solid #007bff;
}
.caret-down {
    font-size: 16px;
    color: #555;
}
.dropdown-menu {
    min-width: 150px;
}
.search-box {
    width: 200px;
    border-radius: 20px;
    padding: 5px 10px;
    border: 1px solid white;
}
.search-box:focus {
    outline: none;
    border: 1px solid #f8f9fa;
}
</style>
</head>
<body>
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">Hariom</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/AllBlogServlet">Blog</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/About.jsp">About</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/create-blog.jsp">Create Blog</a></li>
            </ul>

            <form class="d-flex me-3" action="<%= request.getContextPath() %>/AllBlogServlet" method="get">
                <input class="search-box me-2" type="search" name="search" placeholder="Search blogs...">
                <button class="btn btn-light" type="submit"><i class="fas fa-search"></i></button>
            </form>

            <%
                String user = (String) session.getAttribute("user");
                String profilePic = (String) session.getAttribute("profile_pic");

                if (profilePic == null || profilePic.isEmpty()) {
                    profilePic = request.getContextPath() + "/assets/images/user.png";
                } else {
                    profilePic = request.getContextPath() + "/" + profilePic;
                }

                if (user == null) {
            %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-light">Log In</a>
                <a href="<%= request.getContextPath() %>/signup.jsp" class="btn navbar-signup-btn ms-2">Sign Up</a>
            <% } else { %>
                <div class="dropdown">
                    <button class="profile-btn" id="profileDropdown" data-bs-toggle="dropdown">
                        <img src="<%= profilePic %>" alt="Profile" class="profile-icon">
                        <i class="fas fa-caret-down caret-down"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/ProfileServlet">My Profile</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/myblog.jsp">My Blog</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/LogoutServlet">Logout</a></li>
                    </ul>
                </div>
            <% } %>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
