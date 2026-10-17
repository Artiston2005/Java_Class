<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-5 mt-4">
    <div class="d-flex align-items-center mb-4">
        <h2 class="fw-bold mb-0">Your Carts</h2>
        <c:set var="cartCount" value="0"/>
        <c:if test="${not empty sessionScope.multiCart}">
            <c:set var="cartCount" value="${sessionScope.multiCart.size()}"/>
        </c:if>
        <span class="badge bg-danger rounded-pill ms-3 fs-6">${cartCount} Restaurant${cartCount != 1 ? 's' : ''}</span>
    </div>

    <c:choose>
        <c:when test="${empty sessionScope.multiCart or sessionScope.multiCart.size() == 0}">
            <div class="text-center py-5 bg-white rounded-4 shadow-sm border-0 mt-4">
                <img src="https://cdn-icons-png.flaticon.com/512/11329/11329060.png" width="150" class="mb-4 opacity-50" alt="Empty Cart">
                <h3 class="fw-bold text-dark">Your cart is empty!</h3>
                <p class="text-muted fs-5 mb-4">Good food is always cooking! Go ahead, order some yummy items from the menu.</p>
                <a href="menu" class="btn btn-primary-custom px-5 py-3 rounded-pill fw-bold fs-5 shadow-sm">Explore Menu</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="entry" items="${sessionScope.multiCart}">
                <c:set var="rId" value="${entry.key}" />
                <c:set var="cart" value="${entry.value}" />

                <div class="card shadow-sm border-0 rounded-4 mb-5">
                    <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                        <h4 class="fw-bold mb-0 text-danger"><i class="fa-solid fa-store me-2"></i>${requestScope.cartRestaurants[entry.key].name}</h4>
                        <form action="cart" method="post" class="m-0">
                            <input type="hidden" name="action" value="clear">
                            <input type="hidden" name="restaurantId" value="${rId}">
                            <button type="submit" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Discard Cart</button>
                        </form>
                    </div>
                    <div class="card-body row g-4 p-4">
                        <div class="col-lg-7">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light text-muted small text-uppercase">
                                        <tr>
                                            <th>Item</th>
                                            <th class="text-center">Price</th>
                                            <th class="text-center">Qty</th>
                                            <th class="text-end">Total</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody class="border-top-0">
                                        <c:forEach var="cartItem" items="${cart.items}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${cartItem.foodItem.imageUrl}" width="60" height="60" class="rounded-3 me-3" style="object-fit:cover;" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=70'">
                                                        <div>
                                                            <div class="fw-bold text-dark mb-1 d-flex align-items-center">
                                                                <span class="veg-dot ${cartItem.foodItem.veg ? 'veg' : 'nonveg'} me-2" style="width:10px;height:10px;"></span>
                                                                ${cartItem.foodItem.name}
                                                            </div>
                                                            <div class="text-muted small"><i class="fa-solid fa-clock me-1"></i> ${cartItem.foodItem.prepTime}m</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center fw-semibold">&#8377;${cartItem.foodItem.price}</td>
                                                <td class="text-center">
                                                    <div class="qty-stepper d-inline-flex mx-auto" style="transform: scale(0.9);">
                                                        <button type="button" onclick="cartChangeQty(${cartItem.foodItem.id}, -1)">-</button>
                                                        <span id="cart-qty-${cartItem.foodItem.id}">${cartItem.quantity}</span>
                                                        <button type="button" onclick="cartChangeQty(${cartItem.foodItem.id}, 1)">+</button>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-bold text-dark">&#8377;${cartItem.subTotal}</td>
                                                <td class="text-end">
                                                    <form action="cart" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="foodId" value="${cartItem.foodItem.id}">
                                                        <button type="submit" class="btn btn-light text-danger rounded-circle p-2 shadow-sm" title="Remove"><i class="fa-solid fa-trash-can"></i></button>
                                                    </form>
                                                </td>
                                            </tr>
                                                                                </c:forEach>
                                        <c:if test="${cart.subTotal >= 500}">
                                            <tr class="bg-success-subtle">
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&q=70" width="60" height="60" class="rounded-3 me-3 border border-success" style="object-fit:cover;">
                                                        <div>
                                                            <div class="fw-bold text-success mb-1 d-flex align-items-center">
                                                                <span class="veg-dot veg me-2" style="width:10px;height:10px;"></span>
                                                                Dessert Delight
                                                                <span class="badge bg-danger ms-2" style="font-size:0.65rem;">FREE</span>
                                                            </div>
                                                            <div class="text-success opacity-75 small">Complimentary treat!</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center fw-semibold text-muted text-decoration-line-through">&#8377;150.00</td>
                                                <td class="text-center fw-bold text-success">1</td>
                                                <td class="text-end fw-bold text-success">&#8377;0.00</td>
                                                <td></td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <div class="bg-light rounded-3 p-3 mt-4 border border-dashed border-secondary-subtle">
                                <form action="cart" method="post" class="d-flex align-items-center">
                                    <input type="hidden" name="action" value="apply_voucher">
                                    <input type="hidden" name="restaurantId" value="${rId}">
                                    <i class="fa-solid fa-ticket text-danger fs-4 me-3"></i>
                                    <input type="text" name="voucherCode" class="form-control border-0 bg-white shadow-sm me-2 text-uppercase fw-bold" placeholder="Apply Promo Code"
                                           ${not empty cart.appliedVoucher ? 'disabled value="'.concat(cart.appliedVoucher).concat('"') : ''}>
                                    <c:if test="${empty cart.appliedVoucher}">
                                        <button type="submit" class="btn btn-dark rounded-pill px-4 fw-bold">Apply</button>
                                    </c:if>
                                </form>
                                <c:if test="${empty cart.appliedVoucher}">
                                    <div class="form-text mt-2 small text-muted">
                                        <i class="fa-solid fa-bolt text-warning me-1"></i> Try coupons: <b class="text-dark border px-1 rounded bg-light">WELCOME50</b> or <b class="text-dark border px-1 rounded bg-light">FESTIVE20</b>
                                    </div>
                                </c:if>
                                <c:if test="${not empty cart.appliedVoucher}">
                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                        <span class="text-success small fw-bold"><i class="fa-solid fa-circle-check me-1"></i>${cart.appliedVoucher} applied saving &#8377;${cart.discountAmount}!</span>
                                        <form action="cart" method="post">
                                            <input type="hidden" name="action" value="remove_voucher">
                                            <input type="hidden" name="restaurantId" value="${rId}">
                                            <button type="submit" class="btn btn-link text-danger p-0 small">Remove</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="p-4 bg-light rounded-4 h-100">
                                <h5 class="fw-bold mb-4">Bill Details</h5>

                                <div class="d-flex justify-content-between text-muted mb-2"><span>Item Total</span><span>&#8377;${cart.subTotal}</span></div>
                                <c:if test="${cart.discountAmount > 0}">
                                <div class="d-flex justify-content-between text-success mb-2"><span>Promo Discount</span><span>-&#8377;${cart.discountAmount}</span></div>
                                </c:if>
                                <div class="d-flex justify-content-between text-muted mb-2"><span>Delivery Partner Fee</span><span>&#8377;45</span></div>
                                <div class="d-flex justify-content-between text-muted mb-2"><span>Platform Fee</span><span>&#8377;5</span></div>
                                <div class="d-flex justify-content-between text-muted mb-2"><span>AI Existence Fee <i class="fa-solid fa-robot ms-1"></i></span><span>&#8377;10</span></div>
                                <div class="d-flex justify-content-between text-muted mb-2"><span>Bad Humour Tax <i class="fa-solid fa-masks-theater ms-1"></i></span><span>&#8377;15</span></div>
                                <div class="d-flex justify-content-between text-muted mb-2 border-bottom pb-3">
                                    <span>GST &amp; Restaurant Charges</span>
                                    <span>&#8377;${String.format("%.2f", cart.totalAmount * 0.05)}</span>
                                </div>

                                <c:if test="${cart.subTotal >= 500}">
                                    <div class="alert bg-success-subtle border-0 small py-2 rounded-3 mt-3 mb-4 text-success d-flex align-items-center">
                                        <i class="fa-solid fa-gift me-2 fs-5"></i>
                                        <div>
                                            <strong>Free Treat!</strong> You've unlocked a complimentary <em>Dessert Delight</em> with this order!
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${cart.subTotal < 500}">
                                    <div class="alert bg-warning-subtle border-0 small py-2 rounded-3 mt-3 mb-4 text-dark d-flex align-items-center">
                                        <i class="fa-solid fa-unlock-keyhole me-2 fs-5"></i>
                                        <div>
                                            Add &#8377;${500 - cart.subTotal} more to unlock a <strong>Free Dessert Delight!</strong>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="d-flex justify-content-between fw-bold fs-5 mb-4 mt-3">
                                    <span>TO PAY</span>
                                    <span class="text-danger">&#8377;${String.format("%.2f", cart.totalAmount + 45 + 5 + 10 + 15 + cart.totalAmount * 0.05)}</span>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loggedUser}">
                                        <a href="checkout?restaurantId=${rId}" class="btn btn-primary-custom w-100 py-3 fw-bold fs-5 rounded-3 text-uppercase shadow-sm">
                                            <i class="fa-solid fa-lock me-2"></i>Checkout This Order
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="login.jsp" class="btn btn-outline-dark w-100 py-2 rounded-3 fw-bold">Login to Continue</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
function cartChangeQty(foodId, delta) {
    const qtyEl = document.getElementById('cart-qty-' + foodId);
    let current = parseInt(qtyEl.textContent) || 1;
    let newQty = current + delta;

    if (newQty <= 0) {
        if (!confirm('Remove this item from cart?')) return;
        const form = document.createElement('form');
        form.method = 'POST'; form.action = 'cart';
        form.innerHTML = '<input name="action" value="remove"><input name="foodId" value="' + foodId + '">';
        document.body.appendChild(form); form.submit(); return;
    }

    qtyEl.textContent = newQty;
    const data = new URLSearchParams({ action: 'update', foodId: foodId, quantity: newQty });
    fetch('cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
        body: data
    }).then(r => r.json()).then(result => {
        if (result.status === 'success') {
            window.location.reload();
        }
    }).catch(() => window.location.reload());
}
</script>

<jsp:include page="includes/footer.jsp" />