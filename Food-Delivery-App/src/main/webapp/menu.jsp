<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/header.jsp" />

<script>const quantities = {};</script>
<style>
.menu-search-bar input { border: 2px solid #dee2e6; border-radius: 50px 0 0 50px; padding: 10px 20px; outline: none; transition: border-color 0.2s; }
.menu-search-bar input:focus { border-color: #ff4757; }
.menu-search-bar button { border-radius: 0 50px 50px 0; background: #ff4757; color: white; border: none; padding: 10px 20px; }
.food-card { border-radius: 16px !important; transition: transform 0.2s, box-shadow 0.2s; }
.food-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.12) !important; }
.veg-dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; border: 2px solid; }
.veg-dot.veg { background: #28a745; border-color: #28a745; }
.veg-dot.nonveg { background: #dc3545; border-color: #dc3545; }
.qty-stepper { display: flex; align-items: center; border: 2px solid #ff4757; border-radius: 8px; overflow: hidden; }
.qty-stepper button { background: transparent; border: none; padding: 4px 10px; font-size: 1.1rem; color: #ff4757; font-weight: 700; cursor: pointer; transition: background 0.1s; }
.qty-stepper button:hover { background: #ff4757; color: white; }
.qty-stepper span { padding: 4px 12px; font-weight: 700; min-width: 32px; text-align: center; }
.bestseller-badge { background: linear-gradient(135deg,#ff4757,#ff6b6b); color: white; font-size: 0.65rem; padding: 3px 8px; border-radius: 4px; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase; }
.filter-sidebar .form-check-input:checked { background-color: #ff4757; border-color: #ff4757; }
/* Sticky floating cart bar */
.floating-cart-bar { position: fixed; bottom: 0; left: 0; right: 0; background: #ff4757; color: white; padding: 14px 24px; z-index: 1000; transform: translateY(100%); transition: transform 0.3s; border-radius: 16px 16px 0 0; box-shadow: 0 -4px 20px rgba(255,71,87,0.3); }
.floating-cart-bar.visible { transform: translateY(0); }
</style>

<c:if test="${not empty restaurant}">
<div style="background: linear-gradient(rgba(0,0,0,0.65), rgba(0,0,0,0.65)), url('${restaurant.logoUrl}') center/cover; color: white; padding: 3.5rem 0; text-align: center;">
    <h1 class="display-5 fw-bold">${restaurant.name}</h1>
    <p class="lead mb-0">
        <span class="me-3"><i class="fa-solid fa-star text-warning me-1"></i>${restaurant.rating}</span>
        <span class="me-3"><i class="fa-solid fa-clock me-1"></i>${restaurant.deliveryTime} mins</span>
        <span class="me-3"><i class="fa-solid fa-utensils me-1"></i>${restaurant.cuisineType}</span>
        <span><i class="fa-solid fa-indian-rupee-sign me-1"></i>Min order &#8377;${restaurant.minOrder}</span>
    </p>
    <c:if test="${not empty restaurant.offerText}">
        <div class="mt-3"><span class="badge bg-warning text-dark fs-6 px-4 py-2"><i class="fa-solid fa-percent me-2"></i>${restaurant.offerText}</span></div>
    </c:if>
</div>
</c:if>

<div class="container py-4">
    <!-- In-menu search + veg toggle bar -->
    <div class="d-flex flex-wrap gap-3 align-items-center justify-content-between mb-4">
        <div class="menu-search-bar d-flex" style="max-width: 380px;">
            <input type="text" id="menuSearch" placeholder="Search dishes..." class="w-100">
            <button type="button"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <div class="d-flex align-items-center gap-3">
            <div class="form-check form-switch fs-5 mb-0">
                <input class="form-check-input" type="checkbox" role="switch" id="vegOnlyToggle" style="cursor:pointer;">
                <label class="form-check-label fw-bold text-success small" for="vegOnlyToggle"><i class="fa-solid fa-leaf me-1"></i>Veg Only</label>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Sidebar Filters -->
        <aside class="col-lg-3 mb-4 filter-sidebar">
            <div class="card border-0 shadow-sm p-4 sticky-top" style="top:80px;">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-sliders me-2 text-danger"></i>Filters</h5>
                <form action="menu" method="GET" id="filterForm">
                    <c:if test="${not empty selectedRestaurantId}">
                        <input type="hidden" name="restaurantId" value="${selectedRestaurantId}">
                    </c:if>

                    <div class="mb-4">
                        <label class="form-label fw-semibold small text-muted text-uppercase">Category</label>
                        <select class="form-select shadow-none" name="category" onchange="document.getElementById('filterForm').submit()">
                            <option value="">All</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${cat.id == selectedCategory ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold small text-muted text-uppercase">Sort By</label>
                        <select class="form-select shadow-none" name="sortBy" onchange="document.getElementById('filterForm').submit()">
                            <option value="">Relevance</option>
                            <option value="rating" ${selectedSortBy == 'rating' ? 'selected' : ''}>&#9733; Top Rated</option>
                            <option value="fast" ${selectedSortBy == 'fast' ? 'selected' : ''}> Fastest</option>
                            <option value="price_asc" ${selectedSortBy == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price_desc" ${selectedSortBy == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                        </select>
                    </div>

                    <a href="menu${not empty selectedRestaurantId ? '?restaurantId='.concat(selectedRestaurantId) : ''}" class="btn btn-outline-dark w-100 btn-sm rounded-pill">Clear Filters</a>
                </form>
            </div>
        </aside>

        <!-- Menu Grid -->
        <main class="col-lg-9">
            <c:choose>
                <c:when test="${empty foodItems}">
                    <div class="text-center py-5">
                        <i class="fa-solid fa-bowl-food fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">No items found</h4>
                        <p class="text-muted">Try removing some filters</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="cat" items="${categories}">
                        <c:set var="hasItems" value="false" />
                        <c:forEach var="item" items="${foodItems}">
                            <c:if test="${item.categoryId == cat.id}">
                                <c:set var="hasItems" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${hasItems}">
                            <div class="category-section mt-2 mb-5">
                                <h4 class="fw-bold border-bottom pb-2 mb-4 text-dark">
                                    <i class="fa-solid fa-utensils me-2 text-danger fs-5"></i>${cat.name}
                                </h4>
                                <div class="row g-4 menuGrid">
                                    <c:forEach var="item" items="${foodItems}">
                                        <c:if test="${item.categoryId == cat.id}">
                            <div class="col-md-6 col-xl-4 menu-item-card" data-is-veg="${item.veg}" data-name="${item.name.toLowerCase()}">
                                <div class="card h-100 border-0 shadow-sm food-card">
                                    <div class="position-relative">
                                        <img src="${item.imageUrl}" class="card-img-top" alt="${item.name}" style="height: 170px; object-fit: cover; border-radius: 16px 16px 0 0;" onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=70'">
                                        <c:if test="${item.bestseller}">
                                            <span class="bestseller-badge position-absolute" style="top:10px;left:10px;"> Bestseller</span>
                                        </c:if>
                                    </div>
                                    <div class="card-body d-flex flex-column p-3">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="veg-dot ${item.veg ? 'veg' : 'nonveg'}"></span>
                                            <h6 class="card-title fw-bold mb-0 flex-grow-1">${item.name}</h6>
                                        </div>
                                        <p class="card-text text-muted" style="font-size:0.82rem;flex-grow:1;line-height:1.4;">${item.description}</p>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="text-muted" style="font-size:0.8rem;">
                                                <i class="fa-solid fa-star text-warning me-1"></i>${item.rating}
                                                &nbsp;&middot;&nbsp;
                                                <i class="fa-solid fa-clock me-1"></i>${item.prepTime}m
                                                <c:if test="${not empty item.calories}">
                                                    &nbsp;&middot;&nbsp;${item.calories} kcal
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mt-auto">
                                            <h5 class="fw-bold text-dark mb-0">&#8377;${item.price}</h5>
                                            
                                            <c:set var="qtyInCart" value="0" />
                                            <c:if test="${not empty sessionScope.multiCart}">
                                                <c:forEach var="entry" items="${sessionScope.multiCart}">
                                                    <c:forEach var="cItem" items="${entry.value.items}">
                                                        <c:if test="${cItem.foodItem.id == item.id}">
                                                            <c:set var="qtyInCart" value="${cItem.quantity}" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:forEach>
                                            </c:if>

                                            <div class="qty-stepper" id="stepper-${item.id}" style="display:${qtyInCart > 0 ? 'flex' : 'none'};">
                                                <button type="button" onclick="changeQty(${item.id}, -1)">-</button>
                                                <span id="qty-${item.id}">${qtyInCart > 0 ? qtyInCart : 1}</span>
                                                <button type="button" onclick="changeQty(${item.id}, 1)">+</button>
                                            </div>
                                            <button class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold add-btn" id="addBtn-${item.id}" onclick="addToCart(${item.id})" style="display:${qtyInCart > 0 ? 'none' : 'block'};">
                                                <i class="fa-solid fa-plus me-1"></i>Add
                                            </button>
                                            <c:if test="${qtyInCart > 0}">
                                                <script>quantities[${item.id}] = ${qtyInCart};</script>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<!-- Floating Cart Bar -->
<div class="floating-cart-bar d-flex justify-content-between align-items-center" id="floatingCartBar">
    <div>
        <span class="fw-bold fs-5" id="floatCartCount">0 items</span>
        <span class="ms-2 opacity-75 small">added to cart</span>
    </div>
    <a href="cart" class="btn btn-light text-danger fw-bold rounded-pill px-4">View Cart <i class="fa-solid fa-arrow-right ms-2"></i></a>
</div>

<script>
// --- Veg Toggle ---
const vegToggle = document.getElementById('vegOnlyToggle');
const menuCards = document.querySelectorAll('.menu-item-card');
vegToggle && vegToggle.addEventListener('change', function() {
    menuCards.forEach(card => {
        card.style.display = (this.checked && card.dataset.isVeg !== 'true') ? 'none' : '';
    });
});

// --- Live Search ---
document.getElementById('menuSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase().trim();
    menuCards.forEach(card => {
        const name = card.dataset.name || '';
        card.style.display = (q && !name.includes(q)) ? 'none' : '';
    });
});

// --- Qty Stepper & Add to Cart ---
let cartItemCount = ${totalCartQty > 0 ? totalCartQty : 0};

function changeQty(id, delta) {
    quantities[id] = Math.max(0, (quantities[id] || 1) + delta);
    
    if (quantities[id] === 0) {
        document.getElementById('stepper-' + id).style.display = 'none';
        document.getElementById('addBtn-' + id).style.display = 'block';
    } else {
        document.getElementById('qty-' + id).textContent = quantities[id];
    }
    
    // Fire update to backend!
    const data = new URLSearchParams({ action: 'update', foodId: id, quantity: quantities[id] });
    fetch('cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
        body: data
    })
    .then(r => r.json())
    .then(result => {
        if (result.status === 'success') {
            const badge = document.getElementById('cartBadge');
            if (badge) badge.textContent = result.cartCount;
            cartItemCount = result.cartCount;
            if (cartItemCount === 0) {
                document.getElementById('floatingCartBar').classList.remove('visible');
            } else {
                document.getElementById('floatCartCount').textContent = cartItemCount + (cartItemCount === 1 ? ' item' : ' items');
                document.getElementById('floatingCartBar').classList.add('visible');
            }
        }
    });
}

function addToCart(foodId) {
    const qty = quantities[foodId] || 1;
    const data = new URLSearchParams({ action: 'add', foodId: foodId, quantity: qty });

    const btn = document.getElementById('addBtn-' + foodId);
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
    btn.disabled = true;

    fetch('cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
        body: data
    })
    .then(r => r.json())
    .then(result => {
        if (result.status === 'success') {
            quantities[foodId] = qty;
            
            // Show stepper
            document.getElementById('stepper-' + foodId).style.display = 'flex';
            btn.style.display = 'none';

            // Update cart badge in nav
            const badge = document.getElementById('cartBadge');
            if (badge) badge.textContent = result.cartCount;

            // Show floating cart bar
            cartItemCount = result.cartCount;
            document.getElementById('floatCartCount').textContent = cartItemCount + (cartItemCount === 1 ? ' item' : ' items');
            document.getElementById('floatingCartBar').classList.add('visible');

            // Show toast
            const toastEl = document.getElementById('cartToast');
            if (toastEl) new bootstrap.Toast(toastEl).show();
        }
    })
    .catch(err => {
        btn.innerHTML = '<i class="fa-solid fa-plus me-1"></i>Add';
        btn.disabled = false;
    });
}
</script>

<jsp:include page="includes/footer.jsp" />

