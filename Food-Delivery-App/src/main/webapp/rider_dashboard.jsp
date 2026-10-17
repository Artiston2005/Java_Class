<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delivery Partner | Foodies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
<jsp:include page="includes/header.jsp" />

<style>
.stat-card { border-radius: 20px; padding: 24px; color: white; position: relative; overflow: hidden; }
.stat-card::after { content: ''; position: absolute; right: -20px; bottom: -20px; width: 120px; height: 120px; border-radius: 50%; background: rgba(255,255,255,0.12); }
</style>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0"><i class="fa-solid fa-motorcycle me-2 text-primary"></i>Delivery Dashboard</h3>
        <span class="badge bg-success fs-6 px-4 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-2"></i>Online</span>
    </div>

    <!-- Stats Row -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="stat-card bg-primary shadow h-100">
                <h3 class="fw-bold mb-1 fs-1">${totalDeliveries}</h3>
                <p class="mb-0 opacity-75">Total Deliveries Completed</p>
                <i class="fa-solid fa-box-open fa-3x position-absolute opacity-25" style="right:30px;top:20px;"></i>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card bg-success shadow h-100">
                <h3 class="fw-bold mb-1 fs-1">&#8377;${totalEarnings}</h3>
                <p class="mb-0 opacity-75">All-Time Earnings</p>
                <i class="fa-solid fa-indian-rupee-sign fa-3x position-absolute opacity-25" style="right:30px;top:20px;"></i>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card shadow h-100" style="background: linear-gradient(135deg, #f39c12, #d35400);">
                <h3 class="fw-bold mb-1 fs-1">${activeDeliveries.size()}</h3>
                <p class="mb-0 opacity-75">Current Active Deliveries</p>
                <i class="fa-solid fa-route fa-3x position-absolute opacity-25" style="right:30px;top:20px;"></i>
            </div>
        </div>
    </div>
    
    <div class="row">
                <!-- Active Deliveries -->
        <div class="col-md-6 mb-4">
            <h5 class="fw-bold text-success mb-3">Active Deliveries</h5>
            
            <c:if test="${not empty activeDeliveries}">
                <!-- Live Map for Current Delivery -->
                <div class="card border-0 shadow-sm rounded-4 mb-4 overflow-hidden">
                    <div class="card-header bg-white border-0 p-3 pb-0">
                        <h6 class="fw-bold mb-0"><i class="fa-solid fa-map-location-dot text-success me-2"></i>Live Navigation Route</h6>
                    </div>
                    <div class="card-body p-3">
                        <div id="deliveryMap" style="height: 250px; width: 100%; border-radius: 12px; background: #e9ecef;" class="mb-2"></div>
                        <p class="text-muted small mb-0"><i class="fa-solid fa-circle-info me-1"></i>Map shows approximate routing to the dropoff location.</p>
                    </div>
                </div>
            </c:if>
            <c:forEach var="order" items="${activeDeliveries}">
                <div class="card border-0 shadow-sm rounded-4 mb-3 border-start border-success border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold fs-5">Order #${order.id}</span>
                            <span class="badge bg-success">OUT FOR DELIVERY</span>
                        </div>
                        
                        <!-- Earnings -->
                        <div class="mb-3 py-2 px-3 bg-light rounded-3 d-flex justify-content-between align-items-center border">
                            <span class="fw-medium text-muted small"><i class="fa-solid fa-wallet me-2"></i>Your Earnings</span>
                            <span class="fw-bold text-success">&#8377; ${order.deliveryFee}</span>
                        </div>

                        <!-- Pickup & Dropoff -->
                        <div class="position-relative mb-4 ms-2 ps-4" style="border-left: 2px dashed #dee2e6;">
                            <!-- Pickup -->
                            <div class="position-relative mb-3">
                                <span class="position-absolute translate-middle p-2 bg-white border border-2 border-primary rounded-circle" style="left: -24px; top: 10px;"></span>
                                <h6 class="fw-bold mb-1">Pickup: ${not empty restaurantMap[order.id] ? restaurantMap[order.id].name : 'Restaurant'}</h6>
                                <p class="text-muted small mb-0">${not empty restaurantMap[order.id] ? restaurantMap[order.id].cuisineType : 'Cuisine not available'}</p>
                            </div>
                            
                            <!-- Dropoff -->
                            <div class="position-relative">
                                <span class="position-absolute translate-middle p-2 bg-success rounded-circle" style="left: -24px; top: 10px;"></span>
                                <h6 class="fw-bold mb-1">Dropoff: ${not empty customerMap[order.userId] ? customerMap[order.userId].username : 'Unknown Customer'}</h6>
                                <p class="text-muted small mb-0">${not empty customerMap[order.userId] ? customerMap[order.userId].address : 'Address not available'}</p>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="small fw-bold">Amount to Collect:</span>
                            <span class="fw-bold fs-5"><c:choose>
                                <c:when test="${order.paymentMethod == 'CASH'}">&#8377; ${order.totalAmount}</c:when>
                                <c:otherwise><span class="badge bg-success">PAID ONLINE</span></c:otherwise>
                            </c:choose></span>
                        </div>

                        <form action="rider-dashboard" method="POST">
                            <input type="hidden" name="action" value="DELIVERED">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn btn-success w-100 rounded-pill py-2 fw-bold shadow-sm"><i class="fa-solid fa-check-circle me-2"></i>Mark as Delivered</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty activeDeliveries}">
                <div class="alert alert-light text-muted border-0 shadow-sm rounded-3">No active deliveries. Go pick one up!</div>
            </c:if>
        </div>

        <!-- Available Deliveries -->
        <div class="col-md-6 mb-4">
            <h5 class="fw-bold text-primary mb-3">Available for Pickup</h5>
            <c:forEach var="order" items="${availableDeliveries}">
                <div class="card border-0 shadow-sm rounded-4 mb-3 border-start border-primary border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold fs-5">Order #${order.id}</span>
                            <span class="badge bg-warning text-dark">READY FOR PICKUP</span>
                        </div>

                        <!-- Earnings -->
                        <div class="mb-3 py-2 px-3 bg-light rounded-3 d-flex justify-content-between align-items-center border">
                            <span class="fw-medium text-muted small"><i class="fa-solid fa-wallet me-2"></i>Expected Earnings</span>
                            <span class="fw-bold text-success">&#8377; ${order.deliveryFee}</span>
                        </div>

                        <!-- Pickup & Dropoff -->
                        <div class="position-relative mb-4 ms-2 ps-4" style="border-left: 2px dashed #dee2e6;">
                            <!-- Pickup -->
                            <div class="position-relative mb-3">
                                <span class="position-absolute translate-middle p-2 bg-white border border-2 border-primary rounded-circle" style="left: -24px; top: 10px;"></span>
                                <h6 class="fw-bold mb-1">Pickup: ${not empty restaurantMap[order.id] ? restaurantMap[order.id].name : 'Restaurant'}</h6>
                                <p class="text-muted small mb-0">${not empty restaurantMap[order.id] ? restaurantMap[order.id].cuisineType : 'Cuisine not available'}</p>
                            </div>
                            
                            <!-- Dropoff -->
                            <div class="position-relative">
                                <span class="position-absolute translate-middle p-2 bg-success rounded-circle" style="left: -24px; top: 10px;"></span>
                                <h6 class="fw-bold mb-1">Dropoff: ${not empty customerMap[order.userId] ? customerMap[order.userId].username : 'Unknown Customer'}</h6>
                                <p class="text-muted small mb-0">${not empty customerMap[order.userId] ? customerMap[order.userId].address : 'Address not available'}</p>
                            </div>
                        </div>

                        <form action="rider-dashboard" method="POST">
                            <input type="hidden" name="action" value="ACCEPT_DELIVERY">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-bold shadow-sm"><i class="fa-solid fa-motorcycle me-2"></i>Accept Delivery</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty availableDeliveries}">
                <div class="alert alert-light text-muted border-0 shadow-sm rounded-3">No available orders right now.</div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script>
    document.addEventListener("DOMContentLoaded", function() {
        if (document.getElementById('deliveryMap')) {
            // Initialize Leaflet map centered on Jaipur (as per footer HQ)
            var map = L.map('deliveryMap').setView([26.7820, 75.8235], 13);
            L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
                attribution: '&copy; OpenStreetMap contributors &copy; CARTO',
                maxZoom: 19
            }).addTo(map);

            // Pickup Marker
            var pickupIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div style="background-color:#0d6efd;width:14px;height:14px;border-radius:50%;border:2px solid white;box-shadow:0 0 4px rgba(0,0,0,0.5);"></div>',
                iconSize: [14, 14],
                iconAnchor: [7, 7]
            });
            var pickupMarker = L.marker([26.7800, 75.8200], {icon: pickupIcon}).addTo(map);
            pickupMarker.bindPopup("<b>Pickup Location</b><br>Restaurant");

            // Dropoff Marker
            var dropoffIcon = L.divIcon({
                className: 'custom-div-icon',
                html: '<div style="background-color:#198754;width:16px;height:16px;border-radius:50%;border:2px solid white;box-shadow:0 0 4px rgba(0,0,0,0.5);"></div>',
                iconSize: [16, 16],
                iconAnchor: [8, 8]
            });
            var dropoffMarker = L.marker([26.7900, 75.8350], {icon: dropoffIcon}).addTo(map);
            dropoffMarker.bindPopup("<b>Dropoff Location</b><br>Customer");

            // Draw a dashed line between them to simulate a route
            var latlngs = [
                [26.7800, 75.8200],
                [26.7850, 75.8250],
                [26.7880, 75.8220],
                [26.7900, 75.8350]
            ];
            var polyline = L.polyline(latlngs, {color: '#ff4757', weight: 4, dashArray: '8, 8'}).addTo(map);
            map.fitBounds(polyline.getBounds(), {padding: [30, 30]});
        }
    });

    // WebSocket: connect as a rider to receive real-time new delivery alerts to receive real-time new delivery alerts
    const wsUrl = "ws://" + window.location.host + "${pageContext.request.contextPath}/live/rider/${sessionScope.loggedUser.id}";
    const socket = new WebSocket(wsUrl);

    socket.onmessage = function(event) {
        const msg = JSON.parse(event.data);
        if (msg.type === "NEW_DELIVERY_AVAILABLE") {
            // Play notification sound
            const audio = new Audio("https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3");
            audio.play().catch(() => {});

            // Show a toast banner
            const toast = document.createElement("div");
            toast.innerHTML = '<div style="position:fixed;top:80px;right:20px;z-index:9999;background:#ff4757;color:white;padding:14px 20px;border-radius:12px;box-shadow:0 4px 20px rgba(0,0,0,0.2);font-weight:600;font-size:1rem;">' +
                '<i class="fa-solid fa-motorcycle me-2"></i> New delivery available! Order #' + msg.orderId + 
            '</div>';
            document.body.appendChild(toast);

            // Reload after 2 seconds so the new order appears
            setTimeout(() => window.location.reload(), 2000);
        }
    };

    socket.onclose = function() {
        // Fallback: if WebSocket drops, poll every 20s
        setTimeout(() => window.location.reload(), 20000);
    };
</script>
</body>
</html>