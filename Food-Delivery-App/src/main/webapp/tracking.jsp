<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Track Order | Foodies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        .progress-track {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin: 40px 0;
            padding: 0 20px;
        }
        .progress-track::before {
            content: '';
            position: absolute;
            top: 24px;
            left: 40px;
            right: 40px;
            height: 4px;
            background: #e9ecef;
            z-index: 1;
        }
        .step {
            position: relative;
            z-index: 2;
            text-align: center;
            width: 80px;
        }
        .step .icon {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            color: #adb5bd;
            font-size: 20px;
            border: 4px solid #fff;
            transition: all 0.3s;
        }
        .step.active .icon {
            background: #ff4757;
            color: white;
            box-shadow: 0 0 0 4px #ffe3e5;
        }
        .step.completed .icon {
            background: #2ed573;
            color: white;
        }
        .step p {
            font-size: 12px;
            font-weight: 600;
            color: #adb5bd;
            margin: 0;
        }
        .step.active p { color: #ff4757; }
        .step.completed p { color: #2ed573; }
        .progress-bar-fill {
            position: absolute;
            top: 24px;
            left: 40px;
            height: 4px;
            background: #2ed573;
            z-index: 1;
            transition: width 0.5s ease;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="includes/header.jsp" />

<div class="container py-5">
    <c:choose>
        <c:when test="${empty order}">
            <div class="text-center py-5">
                <h4>No order found to track.</h4>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card border-0 shadow-sm p-4 rounded-4">
                        <div class="d-flex justify-content-between align-items-start mb-4">
                            <div>
                                <h3 class="fw-bold mb-1">Order #${order.id}</h3>
                                <p class="text-muted mb-0">Placed at: <fmt:formatDate value="${order.orderDate}" pattern="dd MMM, h:mm a"/></p>
                            </div>
                            <c:if test="${order.status != 'DELIVERED'}">
                                <span class="badge bg-danger rounded-pill px-3 py-2 fs-6"><i class="fa-regular fa-clock me-2"></i>28 mins</span>
                            </c:if>
                        </div>
                        
                        <!-- Progress line -->
                        <div class="progress-track" id="progressTrack" data-status="${order.status}">
                            <div class="progress-bar-fill" id="progressFill"></div>
                            <div class="step" id="step-PENDING">
                                <div class="icon"><i class="fa-solid fa-check"></i></div>
                                <p>Order<br>Placed</p>
                            </div>
                            <div class="step" id="step-PREPARING">
                                <div class="icon"><i class="fa-solid fa-fire-burner"></i></div>
                                <p>Preparing</p>
                            </div>
                            <div class="step" id="step-OUT_FOR_DELIVERY">
                                <div class="icon"><i class="fa-solid fa-motorcycle"></i></div>
                                <p>On the<br>Way</p>
                            </div>
                            <div class="step" id="step-DELIVERED">
                                <div class="icon"><i class="fa-solid fa-house-chimney"></i></div>
                                <p>Delivered</p>
                            </div>
                        </div>

                        <!-- Map -->
                        <div id="map" style="height: 300px; border-radius: 12px; margin-top: 20px;"></div>

                                                <!-- Rider Details -->
                        <c:if test="${not empty order.riderName}">
                            <div class="mt-4 p-3 bg-light rounded-4 d-flex align-items-center justify-content-between border border-2 border-primary border-opacity-25">
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" style="width: 50px; height: 50px;">
                                        <i class="fa-solid fa-motorcycle fa-lg"></i>
                                    </div>
                                    <div>
                                        <h6 class="fw-bold mb-1 text-primary">Your Delivery Partner</h6>
                                        <p class="mb-0 text-dark fw-medium">${order.riderName}</p>
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="tel:${order.riderPhone}" class="btn btn-primary rounded-circle shadow-sm" style="width: 42px; height: 42px; display: flex; align-items: center; justify-content: center;" title="Call Rider">
                                        <i class="fa-solid fa-phone"></i>
                                    </a>
                                    <a href="sms:${order.riderPhone}" class="btn btn-outline-primary rounded-circle shadow-sm bg-white" style="width: 42px; height: 42px; display: flex; align-items: center; justify-content: center;" title="Message Rider">
                                        <i class="fa-solid fa-comment-dots"></i>
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Order Summary Sidebar -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4 rounded-4 mb-3">

                        <%-- Restaurant Info --%>
                        <c:if test="${not empty restaurantName}">
                            <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                                <c:if test="${not empty restaurantLogo}">
                                    <img src="${restaurantLogo}" alt="${restaurantName}" style="width:48px;height:48px;object-fit:cover;border-radius:12px;">
                                </c:if>
                                <div>
                                    <div class="fw-bold fs-6">${restaurantName}</div>
                                    <div class="text-muted small">Your Order</div>
                                </div>
                            </div>
                        </c:if>

                        <h5 class="fw-bold mb-3">Order Summary</h5>

                        <%-- Items --%>
                        <c:if test="${not empty order.items}">
                            <c:forEach var="item" items="${order.items}">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-light text-dark border rounded-1 fw-bold">${item.quantity}</span>
                                        <span class="small fw-medium">${item.foodItemName}</span>
                                    </div>
                                    <span class="small fw-bold">&#8377;<fmt:formatNumber value="${item.price * item.quantity}" pattern="0.00"/></span>
                                </div>
                            </c:forEach>
                        </c:if>

                        <%-- Price Breakdown — same lines as cart.jsp --%>
                        <div class="border-top mt-3 pt-3">
                            <div class="d-flex justify-content-between small text-muted mb-1">
                                <span>Item Total</span>
                                <span>&#8377;<fmt:formatNumber value="${order.itemSubtotal}" pattern="0.00"/></span>
                            </div>
                            <c:if test="${order.discountAmount > 0}">
                            <div class="d-flex justify-content-between small text-success mb-1">
                                <span>Promo Discount</span>
                                <span>-&#8377;<fmt:formatNumber value="${order.discountAmount}" pattern="0.00"/></span>
                            </div>
                            </c:if>
                            <div class="d-flex justify-content-between small text-muted mb-1">
                                <span>Delivery Partner Fee</span>
                                <span>&#8377;<fmt:formatNumber value="${order.deliveryFee}" pattern="0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between small text-muted mb-1">
                                <span>Platform Fee</span>
                                <span>&#8377;<fmt:formatNumber value="${order.platformFee}" pattern="0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between small text-muted mb-1">
                                <span>AI Existence Fee <i class="fa-solid fa-robot ms-1"></i></span>
                                <span>&#8377;<fmt:formatNumber value="${order.aiFee}" pattern="0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between small text-muted mb-1">
                                <span>Bad Humour Tax <i class="fa-solid fa-masks-theater ms-1"></i></span>
                                <span>&#8377;<fmt:formatNumber value="${order.humourTax}" pattern="0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between small text-muted mb-3">
                                <span>GST &amp; Restaurant Charges (5%)</span>
                                <span>&#8377;<fmt:formatNumber value="${order.gstAmount}" pattern="0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between fw-bold fs-5 border-top pt-3">
                                <span>Total Paid</span>
                                <span class="text-danger">&#8377;<fmt:formatNumber value="${order.totalAmount}" pattern="0.00"/></span>
                            </div>
                            <div class="text-muted small mt-1">
                                Payment: <span class="badge bg-light text-dark border">${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</span>
                            </div>
                        </div>

                        <%-- Cancel Button — only if PENDING --%>
                        <c:if test="${order.status == 'PENDING'}">
                            <form action="track" method="POST" class="mt-4" onsubmit="return confirm('Cancel this order?')">
                                <input type="hidden" name="action" value="CANCEL">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <button type="submit" class="btn btn-outline-danger w-100 rounded-pill fw-bold">
                                    <i class="fa-solid fa-xmark me-2"></i>Cancel Order
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${order.status == 'REJECTED'}">
                            <div class="alert alert-danger small text-center mt-3 mb-0 rounded-3 py-2">
                                <i class="fa-solid fa-ban me-1"></i> This order was cancelled.
                            </div>
                        </c:if>

                        <a href="profile" class="btn btn-outline-dark w-100 mt-3 rounded-pill fw-bold">View All Orders</a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="includes/footer.jsp" />

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    const status = document.getElementById('progressTrack')?.dataset.status;
    if (status) {
        const statuses = ['PENDING', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED'];
        let currentIndex = statuses.indexOf(status);
        if (currentIndex === -1) currentIndex = 0; // Default

        statuses.forEach((s, i) => {
            const el = document.getElementById('step-' + s);
            if (!el) return;
            if (i < currentIndex) el.classList.add('completed');
            if (i === currentIndex) el.classList.add('active');
        });

        // Set progress bar width
        const fill = document.getElementById('progressFill');
        if (fill) {
            const pct = (currentIndex / (statuses.length - 1)) * 100;
            fill.style.width = pct + '%';
        }
    }

    // Initialize Map
    if(document.getElementById('map')) {
        const map = L.map('map').setView([26.9124, 75.7873], 13); // Jaipur coordinates
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        L.marker([26.9124, 75.7873]).addTo(map).bindPopup('Delivery Location').openPopup();
    }
</script>

<!-- WEBSOCKET REAL-TIME LISTENER -->
<script>
    if (${not empty sessionScope.loggedUser}) {
        const wsUrl = "ws://" + window.location.host + "${pageContext.request.contextPath}/live/customer/${sessionScope.loggedUser.id}";
        const socket = new WebSocket(wsUrl);

        socket.onmessage = function(event) {
            const msg = JSON.parse(event.data);
            if (msg.type === "ORDER_STATUS_CHANGED" && msg.orderId == "${order.id}") {
                let audio = new Audio('https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3');
                audio.play();
                window.location.reload();
            }
        };
    }
</script>
</body>
</html>