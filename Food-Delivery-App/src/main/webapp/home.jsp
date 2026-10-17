<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/header.jsp" />

<style>
/* ===== HERO ===== */
.hero-section {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
    min-height: 420px;
    display: flex;
    align-items: center;
    position: relative;
    overflow: hidden;
}
.hero-section::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    right: 0;
    height: 60px;
    background: #f8f9fa;
    clip-path: ellipse(55% 100% at 50% 100%);
}
.hero-search-bar {
    background: white;
    border-radius: 50px;
    padding: 8px 8px 8px 24px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    max-width: 680px;
    margin: 0 auto;
}
.hero-search-bar input {
    border: none;
    font-size: 1.1rem;
    outline: none;
    width: 100%;
    padding: 8px 0;
}
.hero-search-bar button {
    background: #ff4757;
    border: none;
    border-radius: 40px;
    color: white;
    padding: 12px 32px;
    font-weight: 700;
    font-size: 1rem;
    white-space: nowrap;
    transition: background 0.2s;
}
.hero-search-bar button:hover { background: #e84057; }

/* ===== CUISINE CHIPS ===== */
.cuisine-scroll {
    display: flex;
    gap: 12px;
    overflow-x: auto;
    padding-bottom: 8px;
    scrollbar-width: none;
}
.cuisine-scroll::-webkit-scrollbar { display: none; }
.cuisine-chip {
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    transition: transform 0.2s;
}
.cuisine-chip:hover { transform: translateY(-4px); }
.cuisine-chip .chip-icon {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid white;
    box-shadow: 0 4px 16px rgba(0,0,0,0.12);
}
.cuisine-chip span { font-size: 0.75rem; font-weight: 600; color: #2f3542; }

/* ===== OFFER BANNER ===== */
.offer-banner {
    background: linear-gradient(135deg, #ff4757, #ff6b6b);
    border-radius: 20px;
    color: white;
    padding: 28px 40px;
    position: relative;
    overflow: hidden;
}
.offer-banner::before {
    content: '\f805';
    position: absolute;
    right: -10px;
    top: 50%;
    transform: translateY(-50%);
    font-family: "Font Awesome 6 Free";
    font-weight: 900;
    font-size: 5rem;
    opacity: 0.15;
    color: white;
}

/* ===== RESTAURANT CARDS ===== */
.restaurant-card {
    border-radius: 16px !important;
    transition: transform 0.25s, box-shadow 0.25s;
    cursor: pointer;
}
.restaurant-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 16px 40px rgba(0,0,0,0.14) !important;
}
.restaurant-card .card-img-top {
    height: 200px;
    object-fit: cover;
    border-radius: 16px 16px 0 0;
}
.offer-tag {
    position: absolute;
    top: 12px;
    left: 12px;
    background: linear-gradient(135deg, #ff4757, #ff6b6b);
    color: white;
    font-size: 0.72rem;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 6px;
}
.closed-overlay {
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 200px;
    background: rgba(0,0,0,0.55);
    border-radius: 16px 16px 0 0;
    display: flex;
    align-items: center;
    justify-content: center;
}
.skeleton-card {
    border-radius: 16px;
    overflow: hidden;
    background: white;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.skeleton-img {
    height: 200px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
}
.skeleton-line {
    height: 14px;
    border-radius: 7px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
    margin-bottom: 10px;
}
@keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }
</style>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container text-center position-relative z-1 py-5">
        <h1 class="display-4 fw-bold text-white mb-2">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedUser}">Hey ${sessionScope.loggedUser.username}! </c:when>
                <c:otherwise>Craving Something Delicious?</c:otherwise>
            </c:choose>
        </h1>
        <p class="text-light mb-4 fs-5">Order from the best restaurants &nbsp;&bull;&nbsp; Fast delivery &nbsp;&bull;&nbsp; Always fresh</p>

        <form action="search" method="GET" class="hero-search-bar d-flex align-items-center mx-auto">
            <i class="fa-solid fa-magnifying-glass text-muted me-2" style="font-size:1.2rem;"></i>
            <input type="text" name="q" placeholder="Search for restaurant, dish, or cuisine..." value="${searchQuery}">
            <button type="submit">Search</button>
        </form>

        <c:if test="${not empty sessionScope.loggedUser && not empty sessionScope.loggedUser.address}">
            <p class="text-light mt-3 small"><i class="fa-solid fa-location-dot me-1"></i> Delivering to: <strong>${sessionScope.loggedUser.address}</strong> &middot; <a href="profile" class="text-warning">Change</a></p>
        </c:if>
    </div>
</section>

<div class="container py-5">

    <!-- Search result banner -->
    <c:if test="${not empty searchQuery}">
        <div class="alert alert-light border d-flex justify-content-between align-items-center mb-5">
            <span>Showing results for <strong>"${searchQuery}"</strong>  ${restaurants.size()} found</span>
            <a href="home" class="btn btn-sm btn-outline-dark rounded-pill">Clear</a>
        </div>
    </c:if>

    <c:if test="${empty searchQuery}">
    <!-- Cuisine Quick-Select -->
    <section class="mb-5">
        <h4 class="fw-bold mb-3">What's on your mind?</h4>
        <div class="cuisine-scroll">
            <a href="search?q=biryani" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=150&q=80" class="chip-icon" alt="Biryani">
                <span>Biryani</span>
            </a>
            <a href="search?q=pizza" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=150&q=80" class="chip-icon" alt="Pizza">
                <span>Pizza</span>
            </a>
            <a href="search?q=burger" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150&q=80" class="chip-icon" alt="Burger">
                <span>Burger</span>
            </a>
            <a href="search?q=chicken" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=150&q=80" class="chip-icon" alt="Chicken">
                <span>Chicken</span>
            </a>
            <a href="search?q=pasta" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1622973536968-3ead9e780960?w=150&q=80" class="chip-icon" alt="Pasta">
                <span>Pasta</span>
            </a>
            <a href="search?q=dessert" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1551024601-bec78aea704b?w=150&q=80" class="chip-icon" alt="Desserts">
                <span>Desserts</span>
            </a>
            <a href="search?q=salad" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=150&q=80" class="chip-icon" alt="Healthy">
                <span>Healthy</span>
            </a>
            <a href="search?q=naan" class="cuisine-chip text-decoration-none">
                <img src="https://images.unsplash.com/photo-1601050690597-df0568f70950?w=150&q=80" class="chip-icon" alt="Indian">
                <span>Indian</span>
            </a>
        </div>
    </section>

    <!-- Offer Banner -->
    <section class="mb-5">
        <div class="row g-3">
            <div class="col-lg-7">
                <div class="offer-banner" id="promoBanner" style="transition: opacity 0.3s ease;">
                    <h3 class="fw-bold mb-1" id="promoTitle">Get 50% OFF</h3>
                    <p class="mb-3 opacity-75" id="promoDesc">On your first order. Use code <strong>WELCOME50</strong></p>
                    <a href="menu" class="btn btn-light fw-bold rounded-pill px-4">Order Now &rarr;</a>
                </div>
            </div>
            <div class="col-lg-5">
                <div style="background: linear-gradient(135deg, #2ed573, #1e90ff); border-radius: 20px; color: white; padding: 28px 32px; height: 100%;">
                    <h3 class="fw-bold mb-1">30 Min Delivery</h3>
                    <p class="mb-3 opacity-75">Guaranteed or your delivery is free! Available in select zones.</p>
                    <a href="home" class="btn btn-light fw-bold rounded-pill px-4">Check Area &rarr;</a>
                </div>
            </div>
        </div>
    </section>

    <script>
        // Banner Shuffle Logic
        const promos = [
            { title: "Get 50% OFF", desc: "On your first order. Use code <strong>WELCOME50</strong>" },
            { title: "Flat 20% OFF", desc: "Festival special! Use code <strong>FESTIVE20</strong>" },
            { title: "Free Dessert", desc: "On orders above &#8377;500. Applied automatically!" }
        ];
        let promoIndex = 0;
        setInterval(() => {
            promoIndex = (promoIndex + 1) % promos.length;
            const banner = document.getElementById("promoBanner");
            if (banner) {
                banner.style.opacity = 0;
                setTimeout(() => {
                    document.getElementById("promoTitle").innerHTML = promos[promoIndex].title;
                    document.getElementById("promoDesc").innerHTML = promos[promoIndex].desc;
                    banner.style.opacity = 1;
                }, 300);
            }
        }, 4000);
    </script>
    </c:if>

    <!-- Restaurants Grid -->
    <section>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold mb-0">
                <c:choose>
                    <c:when test="${not empty searchQuery}">Search Results</c:when>
                    <c:otherwise>Top Restaurants Near You</c:otherwise>
                </c:choose>
            </h4>
            <div class="d-flex gap-2 align-items-center">
                <span class="badge bg-success rounded-pill"><i class="fa-solid fa-circle me-1" style="font-size:8px;"></i>Open Now</span>
                <span class="text-muted small">${restaurants.size()} restaurants</span>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty restaurants}">
                <div class="text-center py-5">
                    <img src="https://illustrations.popsy.co/red/no-results.svg" width="200" class="mb-4 opacity-75" alt="No results" onerror="this.style.display='none'">
                    <h4 class="text-muted">No restaurants found</h4>
                    <p class="text-muted">Try searching for something else</p>
                    <a href="home" class="btn btn-primary-custom rounded-pill px-5">Browse All</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="r" items="${restaurants}">
                        <div class="col-sm-6 col-lg-4">
                            <a href="menu?restaurantId=${r.id}" class="text-decoration-none text-dark">
                                <div class="card h-100 border-0 shadow-sm restaurant-card">
                                    <div class="position-relative">
                                        <img src="${r.logoUrl}" class="card-img-top" alt="${r.name}" onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80'">
                                        <c:if test="${not empty r.offerText}">
                                            <span class="offer-tag"><i class="fa-solid fa-percent me-1"></i>${r.offerText}</span>
                                        </c:if>
                                        <c:if test="${!r.open}">
                                            <div class="closed-overlay"><span class="badge bg-dark fs-6 px-4 py-2">Currently Closed</span></div>
                                        </c:if>
                                    </div>
                                    <div class="card-body p-3">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <h5 class="fw-bold mb-0 fs-6">${r.name}</h5>
                                            <span class="badge bg-success rounded-2 px-2 py-1">
                                                <i class="fa-solid fa-star me-1" style="font-size:10px;"></i>${r.rating}
                                            </span>
                                        </div>
                                        <p class="text-muted small mb-2">
                                            <c:choose>
                                                <c:when test="${not empty r.cuisineType}">${r.cuisineType}</c:when>
                                                <c:otherwise>Multi-Cuisine</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <div class="d-flex justify-content-between align-items-center border-top pt-2">
                                            <span class="text-muted small">
                                                <i class="fa-solid fa-clock me-1 text-primary"></i>${r.deliveryTime} mins
                                            </span>
                                            <span class="text-muted small">
                                                <c:choose>
                                                    <c:when test="${r.minOrder > 0}">Min &#8377;${r.minOrder}</c:when>
                                                    <c:otherwise>No Min</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="text-success small fw-bold">
                                                <i class="fa-solid fa-motorcycle me-1"></i>Free above &#8377;${r.freeDeliveryAbove > 0 ? r.freeDeliveryAbove : 299}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</div>

<jsp:include page="includes/footer.jsp" />
