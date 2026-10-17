<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodies - Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            display: flex; flex-direction: column; min-height: 100vh;
        }
        .navbar { padding: 0.6rem 0; }
        .navbar-brand { font-weight: 800; font-size: 1.5rem; color: #ff4757 !important; }
        .nav-link { font-weight: 500; color: #2f3542 !important; transition: color 0.2s; }
        .nav-link:hover { color: #ff4757 !important; }
        .btn-primary-custom { background-color: #ff4757; border-color: #ff4757; color: white; font-weight: 600; }
        .btn-primary-custom:hover, .btn-primary-custom:focus { background-color: #e84057; border-color: #e84057; color: white; }
        .main-content { flex: 1; }
        /* Address badge */
        .delivery-badge { border-left: 2px solid #eee; padding-left: 1rem; }
        .delivery-badge:hover .delivery-location { color: #ff4757; }
        .delivery-location { font-weight: 700; font-size: 0.85rem; line-height: 1.1; }
        .delivery-address { font-size: 0.75rem; color: #888; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        /* Cart badge */
        #cartBadge { font-size: 0.7rem; min-width: 18px; height: 18px; line-height: 18px; padding: 0 4px; border-radius: 9px; vertical-align: super; }
        /* User dropdown */
        .dropdown-menu { 
            border: 0; box-shadow: 0 12px 40px rgba(0,0,0,0.12); 
            border-radius: 12px; padding: 12px; 
            animation: slideDown 0.2s ease-out forwards;
        }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        .dropdown-item { border-radius: 8px; font-weight: 500; font-size: 0.9rem; padding: 10px 14px; transition: all 0.2s; }
        .dropdown-item:hover { background: #fff5f6; color: #ff4757; transform: translateX(4px); }
        /* Login btn */
        .btn-login { background: #ff4757; color: white; border-radius: 50px; font-weight: 600; padding: 8px 24px; border: none; transition: all 0.2s; }
        .btn-login:hover { background: #e84057; color: white; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(255,71,87,0.3); }
        /* Glassmorphism Navbar */
        .navbar { 
            background: rgba(255, 255, 255, 0.85) !important; 
            backdrop-filter: blur(12px); 
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        /* Universal Hover Effects */
        .btn { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .btn:not(.nav-link):not(.btn-close):not(.navbar-toggler):hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .card { transition: transform 0.25s ease, box-shadow 0.25s ease; border-radius: 16px !important; }
        .card:hover { transform: translateY(-4px); box-shadow: 0 12px 30px rgba(0,0,0,0.08) !important; }
        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb { background: #d1d1d1; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #ff4757; }
        html { scroll-behavior: smooth; }
    </style>
</head>
<body>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container">
        <div class="d-flex align-items-center gap-3">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="fa-solid fa-burger me-1"></i>Foodies
            </a>

            <!-- Delivery Address Badge -->
            <c:if test="${not empty sessionScope.loggedUser}">
            <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none text-dark d-none d-md-block delivery-badge">
                <div class="d-flex align-items-center gap-1">
                    <i class="fa-solid fa-location-dot text-danger fs-5"></i>
                    <div>
                        <div class="delivery-location">Deliver to</div>
                        <div class="delivery-address">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedUser.address}">${sessionScope.loggedUser.address}</c:when>
                                <c:otherwise>Select Location <i class="fa-solid fa-chevron-down ms-1" style="font-size:9px;"></i></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </a>
            </c:if>
        </div>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto ms-4">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/menu">All Menu</a>
                </li>
            </ul>
            <ul class="navbar-nav align-items-center gap-2">
                <!-- Cart -->
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="fa-solid fa-bag-shopping fs-5"></i>
                        <c:set var="totalItems" value="0"/>
                        <c:if test="${not empty sessionScope.multiCart}">
                            <c:forEach var="entry" items="${sessionScope.multiCart}">
                                <c:forEach var="item" items="${entry.value.items}">
                                    <c:set var="totalItems" value="${totalItems + item.quantity}"/>
                                </c:forEach>
                            </c:forEach>
                        </c:if>
                        <c:if test="${totalItems > 0}">
                            <span id="cartBadge" class="badge bg-danger position-absolute" style="top:-4px;right:-8px;">${totalItems}</span>
                        </c:if>
                        <c:if test="${totalItems == 0}">
                            <span id="cartBadge" class="badge bg-danger position-absolute" style="top:-4px;right:-8px;display:none;"></span>
                        </c:if>
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty sessionScope.loggedUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <div style="width:34px;height:34px;background:#ff4757;border-radius:50%;display:flex;align-items:center;justify-content:center;color:white;font-weight:700;font-size:0.9rem;">
                                    ${sessionScope.loggedUser.username.substring(0,1).toUpperCase()}
                                </div>
                                <span class="d-none d-lg-block">${sessionScope.loggedUser.username}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" style="min-width:200px;">
                                <li class="px-2 py-1 mb-1">
                                    <p class="mb-0 fw-bold small">${sessionScope.loggedUser.username}</p>
                                    <p class="mb-0 text-muted" style="font-size:0.75rem;">${sessionScope.loggedUser.role}</p>
                                </li>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-clock-rotate-left me-2 text-muted"></i>Order History</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/track"><i class="fa-solid fa-motorcycle me-2 text-muted"></i>Track Order</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/favorites"><i class="fa-solid fa-heart me-2 text-danger"></i>Favourites</a></li>
                                <c:if test="${sessionScope.loggedUser.role == 'ADMIN'}">
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/admin"><i class="fa-solid fa-gauge me-2"></i>Admin Panel</a></li>
                                </c:if>
                                <c:if test="${sessionScope.loggedUser.role == 'RESTAURANT_OWNER'}">
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/restaurant-admin"><i class="fa-solid fa-store me-2"></i>My Restaurant</a></li>
                                </c:if>
                                <c:if test="${sessionScope.loggedUser.role == 'DELIVERY_PARTNER'}">
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item text-primary" href="${pageContext.request.contextPath}/rider-dashboard"><i class="fa-solid fa-motorcycle me-2"></i>Rider Dashboard</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2 text-muted"></i>Logout</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-login" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Toast -->
<div class="toast-container position-fixed end-0 p-3" style="bottom: 80px; z-index: 1200">
    <div id="cartToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-semibold"><i class="fa-solid fa-check-circle me-2"></i>Added to cart!</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<div class="main-content">
