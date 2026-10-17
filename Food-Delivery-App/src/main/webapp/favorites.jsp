<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Favourites | Foodies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .btn-primary-custom { background-color: #ff4757; border-color: #ff4757; color: white; font-weight: 600; }
        .btn-primary-custom:hover { background-color: #e84057; border-color: #e84057; }
    </style>
</head>
<body class="bg-light">
<jsp:include page="includes/header.jsp" />

<div class="container py-5" style="min-height: 70vh;">
    <h3 class="fw-bold mb-4"><i class="fa-solid fa-heart text-danger me-2"></i>My Favourites</h3>
    
    <div class="card border-0 shadow-sm p-5 text-center">
        <i class="fa-regular fa-heart fa-4x text-muted mb-3 opacity-25"></i>
        <h5 class="text-muted">Favourites feature is active!</h5>
        <p class="text-muted small">You can now heart restaurants on the home page and food items on the menu page.<br>Your saved items will appear here soon.</p>
        <div>
            <a href="home" class="btn btn-primary-custom rounded-pill px-4 mt-2">Explore Restaurants</a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>