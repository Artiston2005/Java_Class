<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<jsp:include page="includes/header.jsp" />

<style>
/* Checkout layout */
.checkout-step-nav { display: flex; gap: 0; }
.checkout-step-nav .step { flex: 1; padding: 14px; text-align: center; font-weight: 600; font-size: 0.9rem; border-bottom: 3px solid #dee2e6; color: #aaa; cursor: pointer; transition: all 0.2s; }
.checkout-step-nav .step.active { color: #ff4757; border-bottom-color: #ff4757; }
.checkout-step-nav .step.done { color: #2ed573; border-bottom-color: #2ed573; }

/* Payment method cards */
.pay-method { border: 2px solid #dee2e6; border-radius: 12px; padding: 16px 20px; cursor: pointer; transition: all 0.2s; }
.pay-method:hover, .pay-method.selected { border-color: #ff4757; background: #fff5f6; }
.pay-method input[type=radio] { display: none; }

/* Card flip */
.card-flip-container { perspective: 1000px; height: 200px; }
.card-flip-inner { position: relative; width: 100%; height: 100%; transition: transform 0.7s; transform-style: preserve-3d; }
.card-flip-container.flipped .card-flip-inner { transform: rotateY(180deg); }
.card-front, .card-back {
    position: absolute; width: 100%; height: 100%; border-radius: 18px;
    backface-visibility: hidden; display: flex; flex-direction: column; justify-content: space-between; padding: 22px 24px;
    background: linear-gradient(135deg, #1a1a2e, #0f3460);
    color: white; box-shadow: 0 10px 32px rgba(0,0,0,0.2);
}
.card-back { transform: rotateY(180deg); background: linear-gradient(135deg, #0f3460, #1a1a2e); align-items: flex-start; }
.card-magnetic-strip { width: 100%; height: 44px; background: #000; border-radius: 4px; margin-bottom: 16px; }
.cvv-box { background: white; color: #333; border-radius: 6px; padding: 8px 16px; font-weight: 700; letter-spacing: 4px; display: inline-block; }

/* Order review */
.review-item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dashed #eee; font-size: 0.9rem; }
.review-item:last-child { border-bottom: none; }
</style>

<div class="container py-5" style="min-height: 70vh;">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <!-- Step Nav -->
            <div class="card border-0 shadow-sm mb-4 overflow-hidden">
                <div class="checkout-step-nav" id="stepNav">
                    <div class="step done" id="navStep1"><i class="fa-solid fa-location-dot me-2"></i>Address</div>
                    <div class="step active" id="navStep2"><i class="fa-solid fa-credit-card me-2"></i>Payment</div>
                    <div class="step" id="navStep3"><i class="fa-solid fa-receipt me-2"></i>Review &amp; Pay</div>
                </div>
            </div>

            <div class="row g-4">
                <!-- LEFT: Multi-step form -->
                <div class="col-lg-7">

                    <!-- Step 1: Address (already done, pre-filled) -->
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-location-dot text-danger me-2"></i>Delivering To</h5>
                            <a href="profile" class="btn btn-sm btn-outline-dark rounded-pill">Change</a>
                        </div>
                        <div class="bg-light rounded-3 p-3 mt-3">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedUser.address}">
                                    <p class="mb-0 fw-semibold">${sessionScope.loggedUser.username}</p>
                                    <p class="mb-0 text-muted small">${sessionScope.loggedUser.address}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="mb-0 text-danger small"><i class="fa-solid fa-triangle-exclamation me-1"></i>No address saved. <a href="profile">Add one now</a></p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Step 2: Payment Method -->
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <h5 class="fw-bold mb-4"><i class="fa-solid fa-shield-halved text-success me-2"></i>Choose Payment Method</h5>

                        <form action="checkout" method="POST" id="checkoutForm">
                            <input type="hidden" name="restaurantId" value="${requestScope.restaurant.id}">
                            <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="COD">

                            <!-- UPI -->
                            <div class="pay-method mb-3 selected" id="pm-upi" onclick="selectPayment('UPI', this)">
                                <div class="d-flex align-items-center gap-3">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/UPI-Logo-vector.svg/220px-UPI-Logo-vector.svg.png" height="28" alt="UPI">
                                    <div>
                                        <div class="fw-bold">UPI</div>
                                        <div class="text-muted small">Pay via GPay, PhonePe, BHIM</div>
                                    </div>
                                    <span class="ms-auto badge bg-success-subtle text-success">Recommended</span>
                                </div>
                                <div id="upi-details" class="mt-3">
                                    <input type="text" class="form-control" placeholder="Enter UPI ID (e.g. name@upi)" id="upiInput">
                                </div>
                            </div>

                            <!-- Card -->
                            <div class="pay-method mb-3" id="pm-card" onclick="selectPayment('CARD', this)">
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fa-brands fa-cc-visa fs-3 text-primary"></i>
                                    <div>
                                        <div class="fw-bold">Credit / Debit Card</div>
                                        <div class="text-muted small">Visa, Mastercard, RuPay</div>
                                    </div>
                                </div>
                                <div id="card-details" class="mt-3" style="display:none;">
                                    <!-- Visual card -->
                                    <div class="card-flip-container mb-3" id="cardFlip">
                                        <div class="card-flip-inner">
                                            <div class="card-front">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span style="font-size:1.4rem;font-weight:700;">FOODIES</span>
                                                    <i class="fa-brands fa-cc-visa fs-2"></i>
                                                </div>
                                                <div>
                                                    <div style="letter-spacing:4px;font-size:1.1rem;font-weight:600;" id="cardNumDisplay">&bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull;</div>
                                                    <div class="d-flex justify-content-between mt-2">
                                                        <div>
                                                            <div style="font-size:0.6rem;opacity:0.7;">CARD HOLDER</div>
                                                            <div id="cardNameDisplay" style="font-size:0.85rem;">YOUR NAME</div>
                                                        </div>
                                                        <div>
                                                            <div style="font-size:0.6rem;opacity:0.7;">EXPIRES</div>
                                                            <div id="cardExpDisplay" style="font-size:0.85rem;">MM/YY</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-back">
                                                <div class="card-magnetic-strip"></div>
                                                <div>
                                                    <div style="font-size:0.65rem;opacity:0.7;margin-bottom:6px;">CVV</div>
                                                    <div class="cvv-box" id="cvvDisplay">&bull;&bull;&bull;</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">CARD NUMBER</label>
                                        <input type="text" class="form-control" maxlength="19" placeholder="0000 0000 0000 0000" id="cardNum" oninput="formatCard(this)">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">NAME ON CARD</label>
                                        <input type="text" class="form-control" placeholder="As printed on card" id="cardName" oninput="document.getElementById('cardNameDisplay').textContent=this.value.toUpperCase()||'YOUR NAME'">
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-6">
                                            <label class="form-label small fw-bold">EXPIRY</label>
                                            <input type="text" class="form-control" placeholder="MM/YY" maxlength="5" id="cardExp" oninput="document.getElementById('cardExpDisplay').textContent=this.value||'MM/YY'">
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label small fw-bold">CVV</label>
                                            <input type="password" class="form-control" placeholder="***" maxlength="3" id="cardCvv" onfocus="document.getElementById('cardFlip').classList.add('flipped')" onblur="document.getElementById('cardFlip').classList.remove('flipped')" oninput="document.getElementById('cvvDisplay').innerHTML=this.value?'&bull;'.repeat(this.value.length):'&bull;&bull;&bull;'">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Net Banking -->
                            <div class="pay-method mb-3" id="pm-nb" onclick="selectPayment('NETBANKING', this)">
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fa-solid fa-building-columns fs-3 text-dark"></i>
                                    <div>
                                        <div class="fw-bold">Net Banking</div>
                                        <div class="text-muted small">All major Indian banks supported</div>
                                    </div>
                                </div>
                                <div id="nb-details" class="mt-3" style="display:none;">
                                    <select class="form-select">
                                        <option>Select Your Bank</option>
                                        <option>State Bank of India</option>
                                        <option>HDFC Bank</option>
                                        <option>ICICI Bank</option>
                                        <option>Axis Bank</option>
                                        <option>Kotak Mahindra Bank</option>
                                    </select>
                                </div>
                            </div>

                            <!-- COD -->
                            <div class="pay-method mb-4" id="pm-cod" onclick="selectPayment('COD', this)">
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fa-solid fa-money-bills fs-3 text-success"></i>
                                    <div>
                                        <div class="fw-bold">Cash on Delivery</div>
                                        <div class="text-muted small">Pay when your order arrives</div>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary-custom w-100 py-3 fw-bold fs-5 rounded-3 shadow-sm" id="payBtn">
                                <i class="fa-solid fa-lock me-2"></i>Pay Securely &amp; Place Order
                            </button>
                            <p class="text-center text-muted small mt-2"><i class="fa-solid fa-shield me-1"></i>Your payment is 256-bit SSL encrypted</p>
                        </form>
                    </div>
                </div>

                <!-- RIGHT: Order Summary -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm p-4 sticky-top" style="top: 90px;">
                        
                        <%-- Restaurant Info --%>
                        <c:if test="${not empty requestScope.restaurant}">
                            <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                                <c:if test="${not empty requestScope.restaurant.logoUrl}">
                                    <img src="${requestScope.restaurant.logoUrl}" alt="${requestScope.restaurant.name}" style="width:48px;height:48px;object-fit:cover;border-radius:12px;">
                                </c:if>
                                <div>
                                    <div class="fw-bold fs-6">${requestScope.restaurant.name}</div>
                                    <div class="text-muted small">Checkout</div>
                                </div>
                            </div>
                        </c:if>

                        <h5 class="fw-bold mb-4">Order Summary</h5>

                        <c:if test="${empty requestScope.checkoutCart.items}">
                            <div class="text-center text-muted py-4">
                                <i class="fa-solid fa-basket-shopping fa-3x mb-3"></i>
                                <p>Your cart is empty</p>
                                <a href="home" class="btn btn-primary-custom btn-sm rounded-pill">Browse Menu</a>
                            </div>
                        </c:if>

                        <c:forEach var="cartItem" items="${requestScope.checkoutCart.items}">
                            <div class="review-item">
                                <span>
                                    <span class="badge ${cartItem.foodItem.veg ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} me-1" style="font-size:9px;">
                                        <i class="fa-solid fa-circle" style="font-size:6px;"></i>
                                    </span>
                                    `${cartItem.quantity} &times; `${cartItem.foodItem.name}
                                </span>
                                <span class="fw-semibold">&#8377;${cartItem.subTotal}</span>
                            </div>
                        </c:forEach>
                        <c:if test="${requestScope.checkoutCart.subTotal >= 500}">
                            <div class="review-item">
                                <span>
                                    <span class="badge bg-success-subtle text-success me-1" style="font-size:9px;">
                                        <i class="fa-solid fa-circle" style="font-size:6px;"></i>
                                    </span>
                                    1 &times; Dessert Delight <span class="badge bg-danger ms-1">FREE</span>
                                </span>
                                <span class="fw-semibold text-success">&#8377;0.0</span>
                            </div>
                        </c:if>

                        <div class="mt-3 pt-2 border-top">
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>Item Total</span><span>&#8377;${requestScope.checkoutCart.subTotal}</span>
                            </div>
                            <c:if test="${requestScope.checkoutCart.discountAmount > 0}">
                            <div class="d-flex justify-content-between text-success small mb-1">
                                <span>Voucher Discount</span><span>-&#8377;${requestScope.checkoutCart.discountAmount}</span>
                            </div>
                            </c:if>
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>Delivery Partner Fee</span><span>&#8377;45</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>Platform Fee</span><span>&#8377;5</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>AI Existence Fee <i class="fa-solid fa-robot ms-1"></i></span><span>&#8377;10</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>Bad Humour Tax <i class="fa-solid fa-masks-theater ms-1"></i></span><span>&#8377;15</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-2">
                                <span>GST (5%)</span>
                                <span>&#8377;${String.format("%.2f", requestScope.checkoutCart.totalAmount * 0.05)}</span>
                            </div>
                            <div class="d-flex justify-content-between fw-bold fs-5 border-top pt-2 mt-2">
                                <span>Total</span>
                                <span class="text-primary-emphasis">&#8377;${String.format("%.2f", requestScope.checkoutCart.totalAmount + 60 + requestScope.checkoutCart.totalAmount * 0.05)}</span>
                            </div>
                        </div>

                        <c:if test="${not empty requestScope.checkoutCart.appliedVoucher}">
                        <div class="alert alert-success-subtle border-success small mt-3 py-2 mb-0 rounded-3">
                            <i class="fa-solid fa-tag me-1 text-success"></i> <strong>${requestScope.checkoutCart.appliedVoucher}</strong> applied  You saved &#8377;${requestScope.checkoutCart.discountAmount}!
                        </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function selectPayment(method, el) {
    document.querySelectorAll('.pay-method').forEach(p => p.classList.remove('selected'));
    el.classList.add('selected');
    document.getElementById('paymentMethodInput').value = method;
    document.getElementById('upi-details').style.display = 'none';
    document.getElementById('card-details').style.display = 'none';
    document.getElementById('nb-details').style.display = 'none';
    if (method === 'UPI') document.getElementById('upi-details').style.display = 'block';
    if (method === 'CARD') document.getElementById('card-details').style.display = 'block';
    if (method === 'NETBANKING') document.getElementById('nb-details').style.display = 'block';
    const labels = { 'UPI': 'Pay via UPI', 'CARD': 'Pay with Card', 'NETBANKING': 'Pay via Net Banking', 'COD': 'Place Order (COD)' };
    document.getElementById('payBtn').innerHTML = '<i class="fa-solid fa-lock me-2"></i>' + labels[method] + ' &amp; Place Order';
}

function formatCard(input) {
    let v = input.value.replace(/\D/g,'').substring(0,16);
    let parts = v.match(/.{1,4}/g) || [];
    input.value = parts.join(' ');
    document.getElementById('cardNumDisplay').innerHTML = (v.padEnd(16,'*')).match(/.{1,4}/g).join(' ');
}

// Set initial selection
selectPayment('UPI', document.getElementById('pm-upi'));
</script>

<jsp:include page="includes/footer.jsp" />
