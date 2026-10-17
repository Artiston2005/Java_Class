<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="includes/header.jsp" />

<style>
.profile-sidebar { background: linear-gradient(180deg, #ff4757 0%, #ff6b6b 100%); border-radius: 24px; color: white; padding: 2rem; }
.avatar-circle { width: 90px; height: 90px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800; margin: 0 auto 1rem; border: 4px solid rgba(255,255,255,0.4); }
.order-card { border-radius: 16px; transition: box-shadow 0.2s; }
.order-card:hover { box-shadow: 0 8px 24px rgba(0,0,0,0.1) !important; }
.status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }
.address-card { border-radius: 14px; border: 2px solid #eee; transition: border-color 0.2s; cursor: pointer; }
.address-card:hover { border-color: #ff4757; }
.address-card.active-addr { border-color: #ff4757; background: #fff5f6; }
</style>

<div class="container py-5" style="min-height: 80vh;">
    <c:if test="${not empty sessionScope.profileMessage}">
        <div class="alert alert-success small rounded-3 mb-4"><i class="fa-solid fa-check-circle me-2"></i>${sessionScope.profileMessage}</div>
        <% session.removeAttribute("profileMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.profileError}">
        <div class="alert alert-danger small rounded-3 mb-4"><i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.profileError}</div>
        <% session.removeAttribute("profileError"); %>
    </c:if>

    <div class="row g-4">
        <!-- LEFT Sidebar -->
        <div class="col-lg-3">
            <div class="profile-sidebar text-center mb-4">
                <div class="avatar-circle">${sessionScope.loggedUser.username.substring(0,1).toUpperCase()}</div>
                <h5 class="fw-bold mb-0">${sessionScope.loggedUser.username}</h5>
                <p class="opacity-75 small mb-3">${sessionScope.loggedUser.role}</p>
                <div class="d-flex justify-content-around text-center">
                    <div><div class="fw-bold fs-5">${orders.size()}</div><div class="opacity-75 small">Orders</div></div>
                    <div><div class="fw-bold fs-5">${addresses.size()}</div><div class="opacity-75 small">Addresses</div></div>
                </div>
            </div>

            <!-- Saved Addresses -->
            <div class="card border-0 shadow-sm p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold mb-0">Saved Addresses</h6>
                    <button class="btn btn-sm btn-primary-custom rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#newAddressModal">+ Add</button>
                </div>
                <c:choose>
                    <c:when test="${empty addresses}">
                        <div class="text-center py-3 text-muted small">
                            <i class="fa-solid fa-location-dot fa-2x mb-2 opacity-50"></i>
                            <p class="mb-0">No addresses saved yet</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="addr" items="${addresses}">
                            <div class="address-card p-3 mb-2 ${addr.id == 1 ? 'active-addr' : ''}">
                                <div class="d-flex align-items-start gap-2">
                                    <i class="fa-solid ${addr.label == 'Home' ? 'fa-house' : (addr.label == 'Work' ? 'fa-briefcase' : 'fa-location-dot')} text-danger mt-1"></i>
                                    <div>
                                        <div class="fw-bold small">${addr.label}</div>
                                        <div class="text-muted" style="font-size:0.78rem;">${addr.addressText}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- RIGHT: Order History -->
        <div class="col-lg-9">
            <h4 class="fw-bold mb-4"><i class="fa-solid fa-clock-rotate-left me-2 text-danger"></i>Order History</h4>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="text-center py-5 card border-0 shadow-sm">
                        <i class="fa-solid fa-bag-shopping fa-4x text-muted mb-3 opacity-50"></i>
                        <h5 class="text-muted">No orders yet</h5>
                        <p class="text-muted small">Your past orders will appear here</p>
                        <a href="home" class="btn btn-primary-custom rounded-pill px-5">Order Now</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                    <div class="card border-0 shadow-sm order-card mb-3 p-4">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                            <div>
                                <div class="fw-bold">Order #${order.id}</div>
                                <div class="text-muted small"><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/></div>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <span class="status-badge ${order.status == 'DELIVERED' ? 'bg-success-subtle text-success' : (order.status == 'REJECTED' ? 'bg-danger-subtle text-danger' : (order.status == 'OUT_FOR_DELIVERY' ? 'bg-info-subtle text-info' : 'bg-warning-subtle text-warning'))}">
                                    ${order.status}
                                </span>
                                <c:if test="${order.status == 'DELIVERED' && order.rating == 0}">
                                    <button class="btn btn-sm btn-outline-success rounded-pill" data-bs-toggle="modal" data-bs-target="#rateModal${order.id}">
                                        <i class="fa-solid fa-star me-1"></i>Rate
                                    </button>
                                </c:if>
                                <c:if test="${order.status == 'DELIVERED' && order.rating > 0}">
                                    <span class="btn btn-sm btn-light text-muted rounded-pill disabled"><i class="fa-solid fa-check me-1"></i>Rated</span>
                                </c:if>
                                <a href="track?orderId=${order.id}" class="btn btn-sm btn-outline-dark rounded-pill">
                                    <i class="fa-solid fa-motorcycle me-1"></i>Track
                                </a>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <c:forEach var="item" items="${order.items}">
                            <div class="col-auto">
                                <span class="badge bg-light text-dark border" style="font-size:0.8rem;">
                                    ${item.quantity}&times; ${item.foodItemName}
                                </span>
                            </div>
                            </c:forEach>
                        </div>

                        <div class="d-flex justify-content-between align-items-center border-top pt-3">
                            <div class="text-muted small">
                                <i class="fa-solid fa-wallet me-1"></i>
                                ${not empty order.paymentMethod ? order.paymentMethod : 'COD'}
                            </div>
                            <div class="fw-bold fs-5">&#8377;<fmt:formatNumber value="${order.totalAmount}" pattern="0.00"/></div>
                        </div>
                    </div>
                    
                    <!-- Rate Order Modal -->
                    <div class="modal fade" id="rateModal${order.id}" tabindex="-1">
                      <div class="modal-dialog modal-md modal-dialog-centered">
                        <div class="modal-content rounded-4 overflow-hidden border-0 shadow">
                          <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title fw-bold">Rate Order #${order.id}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                          </div>
                          <form action="profile" method="POST">
                            <div class="modal-body py-4">
                                <input type="hidden" name="action" value="rateOrder">
                                <input type="hidden" name="orderId" value="${order.id}">
                                
                                <h6 class="fw-bold">Rate the Restaurant</h6>
                                <p class="small text-muted mb-2">How was the overall experience?</p>
                                <div class="d-flex gap-2 mb-2 fs-4" style="cursor:pointer;" id="starRatingRest${order.id}">
                                    <i class="fa-solid fa-star text-warning" onclick="setRating('Rest${order.id}', 1)"></i>
                                    <i class="fa-solid fa-star text-warning" onclick="setRating('Rest${order.id}', 2)"></i>
                                    <i class="fa-solid fa-star text-warning" onclick="setRating('Rest${order.id}', 3)"></i>
                                    <i class="fa-solid fa-star text-warning" onclick="setRating('Rest${order.id}', 4)"></i>
                                    <i class="fa-solid fa-star text-warning" onclick="setRating('Rest${order.id}', 5)"></i>
                                </div>
                                <input type="hidden" name="restaurantRating" id="ratingValueRest${order.id}" value="5">
                                <textarea name="restaurantComment" class="form-control form-control-sm mb-4" placeholder="Any comments for the restaurant? (Optional)" rows="2"></textarea>
                                
                                <h6 class="fw-bold border-top pt-3">Rate the Food</h6>
                                <c:forEach var="item" items="${order.items}">
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="small fw-bold">${item.foodItemName}</span>
                                            <div class="d-flex gap-1 fs-6" style="cursor:pointer;" id="starRatingFood${item.id}">
                                                <i class="fa-solid fa-star text-warning" onclick="setRating('Food${item.id}', 1)"></i>
                                                <i class="fa-solid fa-star text-warning" onclick="setRating('Food${item.id}', 2)"></i>
                                                <i class="fa-solid fa-star text-warning" onclick="setRating('Food${item.id}', 3)"></i>
                                                <i class="fa-solid fa-star text-warning" onclick="setRating('Food${item.id}', 4)"></i>
                                                <i class="fa-solid fa-star text-warning" onclick="setRating('Food${item.id}', 5)"></i>
                                            </div>
                                        </div>
                                        <input type="hidden" name="foodRating_${item.foodItemId}" id="ratingValueFood${item.id}" value="5">
                                        <input type="text" name="foodComment_${item.foodItemId}" class="form-control form-control-sm mt-1" placeholder="How was this item? (Optional)">
                                    </div>
                                </c:forEach>

                                <button type="submit" class="btn btn-primary-custom rounded-pill w-100 fw-bold mt-2">Submit Detailed Rating</button>
                            </div>
                          </form>
                        </div>
                      </div>
                    </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- New Address Modal -->
<div class="modal fade" id="newAddressModal" tabindex="-1">
  <div class="modal-dialog modal-xl">
    <div class="modal-content rounded-4 overflow-hidden">
      <div class="modal-header border-0 px-4 pt-4 pb-0">
        <h5 class="modal-title fw-bold fs-4">Save Delivery Address</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="profile" method="POST">
        <div class="modal-body p-4">
            <input type="hidden" name="action" value="addAddress">
            <div class="row g-4">
                <div class="col-lg-6">
                    <label class="form-label fw-bold small mb-2"><i class="fa-solid fa-location-crosshairs text-danger me-2"></i>Pin your exact location</label>
                    <div id="map" style="height: 320px; border-radius: 12px; border: 2px solid #eee;"></div>
                    <div class="row g-2 mt-2">
                        <div class="col-6"><input type="text" class="form-control form-control-sm" id="latInput" name="lat" readonly placeholder="Latitude (auto-filled)" style="background:#f8f9fa;"></div>
                        <div class="col-6"><input type="text" class="form-control form-control-sm" id="lngInput" name="lng" readonly placeholder="Longitude (auto-filled)" style="background:#f8f9fa;"></div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">FLAT / HOUSE / BLOCK NO. <span class="text-danger">*</span></label>
                        <input type="text" class="form-control shadow-none" name="flatNo" required placeholder="e.g. Flat 4B, 3rd Floor">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">APARTMENT / ROAD / AREA <span class="text-danger">*</span></label>
                        <input type="text" class="form-control shadow-none" name="area" required placeholder="e.g. MG Road, Koramangala">
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small fw-bold">PINCODE <span class="text-danger">*</span></label>
                            <input type="text" class="form-control shadow-none" name="pincode" required pattern="[0-9]{6}" placeholder="6-digit PIN">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small fw-bold">LANDMARK</label>
                            <input type="text" class="form-control shadow-none" name="landmark" placeholder="Near Apollo Hospital">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label text-muted small fw-bold d-block mb-2">SAVE AS</label>
                        <div class="d-flex gap-2 flex-wrap">
                            <input type="radio" class="btn-check" name="label" id="lblHome" value="Home" checked>
                            <label class="btn btn-outline-dark rounded-pill px-4" for="lblHome"><i class="fa-solid fa-house me-2"></i>Home</label>
                            <input type="radio" class="btn-check" name="label" id="lblWork" value="Work">
                            <label class="btn btn-outline-dark rounded-pill px-4" for="lblWork"><i class="fa-solid fa-briefcase me-2"></i>Work</label>
                            <input type="radio" class="btn-check" name="label" id="lblOther" value="Other">
                            <label class="btn btn-outline-dark rounded-pill px-4" for="lblOther"><i class="fa-solid fa-location-dot me-2"></i>Other</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer border-0 px-4 pb-4 pt-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-primary-custom px-5 rounded-pill fw-bold">Save Address</button>
        </div>
      </form>
    </div>
  </div>
</div>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
function setRating(orderId, rating) {
    document.getElementById('ratingValue' + orderId).value = rating;
    let stars = document.getElementById('starRating' + orderId).children;
    for (let i = 0; i < 5; i++) {
        if (i < rating) {
            stars[i].classList.remove('fa-regular');
            stars[i].classList.add('fa-solid');
        } else {
            stars[i].classList.add('fa-regular');
            stars[i].classList.remove('fa-solid');
        }
    }
}
document.getElementById('newAddressModal').addEventListener('shown.bs.modal', function() {
    if (window._mapInit) return;
    window._mapInit = true;
    const map = L.map('map').setView([20.5937, 78.9629], 5);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
    let marker;
    map.on('click', function(e) {
        const { lat, lng } = e.latlng;
        if (marker) map.removeLayer(marker);
        marker = L.marker([lat, lng]).addTo(map);
        document.getElementById('latInput').value = lat.toFixed(6);
        document.getElementById('lngInput').value = lng.toFixed(6);
    });
});
</script>

<jsp:include page="includes/footer.jsp" />
