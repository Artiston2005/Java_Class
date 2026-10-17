<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="includes/header.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<style>
.stat-card { border-radius: 20px; padding: 24px; color: white; position: relative; overflow: hidden; }
.stat-card::after { content: ''; position: absolute; right: -20px; bottom: -20px; width: 120px; height: 120px; border-radius: 50%; background: rgba(255,255,255,0.12); }
.stat-card .icon { width: 50px; height: 50px; border-radius: 14px; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; margin-bottom: 12px; }
</style>

<div class="container-fluid py-4 px-4 px-lg-5" style="min-height: 80vh;">
    <c:choose>
        <c:when test="${sessionScope.loggedUser.role != 'RESTAURANT_OWNER'}">
            <div class="text-center py-5">
                <i class="fa-solid fa-shield-xmark fa-4x text-danger mb-3"></i>
                <h3>Access Denied</h3>
            </div>
        </c:when>
        <c:otherwise>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-5" id="dash-header">
            <div>
                <h2 class="fw-bold mb-0">${restaurant.name} Dashboard</h2>
                <p class="text-muted mb-0">Welcome back, ${sessionScope.loggedUser.username}</p>
            </div>
            <div class="d-flex gap-2">
                <a href="restaurant-menu" class="btn btn-outline-danger rounded-pill fw-bold px-4"><i class="fa-solid fa-utensils me-2"></i>Menu Management</a>
                <a href="restaurant-admin?view=live" class="btn btn-danger fw-bold px-4 rounded-pill">
                    <i class="fa-solid fa-bell me-2"></i>Live Orders
                    <c:if test="${pendingCount > 0}"><span class="badge bg-light text-danger ms-1">${pendingCount}</span></c:if>
                </a>
            </div>
        </div>

        <!-- Stats Row -->
        <div class="row g-4 mb-5">
            <div class="col-6 col-lg-2">
                <div class="stat-card" style="background: linear-gradient(135deg,#ff4757,#ff6b6b); padding: 18px;">
                    <div class="icon" style="width:35px;height:35px;font-size:1.1rem;margin-bottom:8px;"><i class="fa-solid fa-bag-shopping"></i></div>
                    <div class="fs-3 fw-bold"><c:out value="${todayOrders}" default="0"/></div>
                    <div class="opacity-75 small" style="font-size:0.75rem;">Orders Today</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="stat-card" style="background: linear-gradient(135deg,#2ed573,#1e90ff); padding: 18px;">
                    <div class="icon" style="width:35px;height:35px;font-size:1.1rem;margin-bottom:8px;"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                    <div class="fs-3 fw-bold">&#8377;<c:out value="${todayRevenue}" default="0"/></div>
                    <div class="opacity-75 small" style="font-size:0.75rem;">Revenue Today</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="stat-card" style="background: linear-gradient(135deg,#7c5cbf,#a29bfe); padding: 18px;">
                    <div class="icon" style="width:35px;height:35px;font-size:1.1rem;margin-bottom:8px;"><i class="fa-solid fa-receipt"></i></div>
                    <div class="fs-3 fw-bold"><c:out value="${totalOrders}" default="0"/></div>
                    <div class="opacity-75 small" style="font-size:0.75rem;">Total Orders</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="stat-card" style="background: linear-gradient(135deg,#fd9644,#fca652); padding: 18px;">
                    <div class="icon" style="width:35px;height:35px;font-size:1.1rem;margin-bottom:8px;"><i class="fa-solid fa-chart-line"></i></div>
                    <div class="fs-3 fw-bold">&#8377;<c:out value="${totalRevenue}" default="0"/></div>
                    <div class="opacity-75 small" style="font-size:0.75rem;">Total Revenue</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="stat-card" style="background: linear-gradient(135deg,#f1c40f,#f39c12); padding: 18px;">
                    <div class="icon" style="width:35px;height:35px;font-size:1.1rem;margin-bottom:8px;"><i class="fa-solid fa-star"></i></div>
                    <div class="fs-3 fw-bold"><c:out value="${averageRating}" default="5.0"/></div>
                    <div class="opacity-75 small" style="font-size:0.75rem;">Average Rating</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="stat-card" style="background: linear-gradient(135deg,#34495e,#2c3e50); padding: 18px;">
                    <div class="icon" style="width:35px;height:35px;font-size:1.1rem;margin-bottom:8px;"><i class="fa-solid fa-utensils"></i></div>
                    <div class="fs-3 fw-bold"><c:out value="${totalMenuCount}" default="0"/></div>
                    <div class="opacity-75 small" style="font-size:0.75rem;">Menu Items</div>
                </div>
            </div>
        </div>



        <!-- ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ LIVE ORDERS VIEW ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ -->
        <c:if test="${viewMode == 'live'}">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0"><i class="fa-solid fa-circle text-danger me-2 fa-beat"></i>Live Orders <span class="badge bg-danger ms-2">${pendingCount} Pending</span></h4>
                <a href="restaurant-admin" class="btn btn-outline-dark rounded-pill"><i class="fa-solid fa-chart-pie me-2"></i>Back to Dashboard</a>
            </div>
            <c:if test="${empty liveOrders}">
                <div class="card border-0 shadow-sm text-center py-5">
                    <i class="fa-solid fa-check-circle fa-4x text-success mb-3 opacity-50"></i>
                    <h5 class="text-muted">No pending orders right now.</h5>
                    <p class="text-muted small">All caught up! New orders will appear here automatically.</p>
                </div>
            </c:if>
            <div class="row g-3">
                <c:forEach var="order" items="${liveOrders}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 border-start border-4 ${order.status == 'PENDING' ? 'border-warning' : 'border-info'}">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h5 class="fw-bold mb-1">Order #${order.id}</h5>
                                        <span class="text-muted small"><fmt:formatDate value="${order.orderDate}" pattern="dd MMM, hh:mm a"/></span>
                                    </div>
                                    <span class="badge ${order.status == 'PENDING' ? 'bg-warning text-dark' : 'bg-info'} rounded-pill px-3 py-2">${order.status}</span>
                                </div>
                                <div class="mb-3">
                                    <c:forEach var="item" items="${order.items}">
                                        <div class="d-flex justify-content-between small text-muted">
                                            <span>${item.quantity}x ${item.foodItemName}</span>
                                            <span>&#8377;<fmt:formatNumber value="${item.price * item.quantity}" pattern="0"/></span>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="d-flex justify-content-between align-items-center border-top pt-3 mt-2">
                                    <div class="fw-bold text-dark">&#8377;${order.totalAmount} &bull; <span class="badge bg-light text-dark border">${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</span></div>
                                </div>
                                <c:if test="${order.status == 'PENDING'}">
                                    <div class="d-flex gap-2 mt-3">
                                        <form action="restaurant-admin" method="POST" class="flex-fill">
                                            <input type="hidden" name="action" value="updateOrderStatus">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="status" value="PREPARING">
                                            <button type="submit" class="btn btn-success w-100 rounded-pill fw-bold"><i class="fa-solid fa-check me-1"></i>Accept</button>
                                        </form>
                                        <form action="restaurant-admin" method="POST" class="flex-fill">
                                            <input type="hidden" name="action" value="updateOrderStatus">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="status" value="REJECTED">
                                            <button type="submit" class="btn btn-outline-danger w-100 rounded-pill fw-bold"><i class="fa-solid fa-xmark me-1"></i>Reject</button>
                                        </form>
                                    </div>
                                </c:if>
                                <c:if test="${order.status == 'PREPARING'}">
                                    <div class="alert alert-info small py-2 mb-0 mt-3 rounded-3"><i class="fa-solid fa-fire-burner me-1"></i>Kitchen is preparing this order.</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ DASHBOARD VIEW ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ -->
        <c:if test="${viewMode == 'dashboard'}">
        <div class="row g-4 mb-4">
            <!-- Order Status Chart -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm p-4 h-100">
                    <h5 class="fw-bold mb-4"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Order Status</h5>
                    <canvas id="statusChart" height="230"></canvas>
                </div>
            </div>

            <!-- Recent Reviews -->
        <div class="d-flex justify-content-between align-items-center mt-5 mb-4">
            <h4 class="fw-bold mb-0"><i class="fa-solid fa-star text-warning me-2"></i>Recent Customer Reviews</h4>
            <c:if test="${reviews.size() > 3}">
                <button class="btn btn-outline-dark btn-sm rounded-pill px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#reviewsModal">View All Reviews</button>
            </c:if>
        </div>
        <div class="row g-4 mb-5">
            <c:forEach var="rev" items="${reviews}" end="2">
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 rounded-4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="fw-bold"><i class="fa-solid fa-user-circle text-muted me-2"></i>${rev.username}</span>
                                <span class="text-warning small">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa-${i <= rev.rating ? 'solid' : 'regular'} fa-star"></i>
                                    </c:forEach>
                                </span>
                            </div>
                            <p class="text-muted small mb-0">${not empty rev.comment ? rev.comment : '<em>No comment provided</em>'}</p>
                            <div class="text-end mt-2"><small class="text-muted" style="font-size:0.7rem;">${rev.createdAt}</small></div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty reviews}">
                <div class="col-12 text-center text-muted py-4">No reviews yet! Keep delivering great food.</div>
            </c:if>
        </div>
        <!-- Recent Orders -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0">Recent Orders</h5>
                        <div class="d-flex gap-2">
                            <c:if test="${allOrders.size() > 5}">
                                <button class="btn btn-outline-dark rounded-pill fw-bold px-4" data-bs-toggle="modal" data-bs-target="#ordersModal">View All</button>
                            </c:if>
                            <a href="restaurant-admin?view=live" class="btn btn-danger rounded-pill fw-bold px-4"><i class="fa-solid fa-bell me-2"></i>Live Orders</a>
                        </div>
                    </div>
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Order ID</th>
                            <th>Items</th>
                            <th>Amount</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Time</th>
                            <th class="pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${allOrders}" end="4">
                        <tr>
                            <td class="ps-4 fw-bold">#${order.id}</td>
                            <td class="small text-muted">
                                <c:forEach var="item" items="${order.items}" varStatus="s">
                                    ${item.quantity}x ${item.foodItemName}<c:if test="${!s.last}">, </c:if>
                                </c:forEach>
                            </td>
                            <td class="fw-bold">&#8377;${order.totalAmount}</td>
                            <td><span class="badge bg-light text-dark border">${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</span></td>
                            <td>
                                <span class="badge ${order.status == 'DELIVERED' ? 'bg-success' : (order.status == 'REJECTED' ? 'bg-danger' : (order.status == 'OUT_FOR_DELIVERY' ? 'bg-info' : (order.status == 'PREPARING' ? 'bg-warning text-dark' : 'bg-secondary')))}">
                                    ${order.status}
                                </span>
                            </td>
                            <td class="text-muted small"><fmt:formatDate value="${order.orderDate}" pattern="dd MMM, hh:mm a" /></td>
                            <td class="pe-4">
                                <c:if test="${order.status == 'PENDING'}">
                                    <form action="restaurant-admin" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updateOrderStatus">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <input type="hidden" name="status" value="PREPARING">
                                        <button type="submit" class="btn btn-sm btn-success rounded-pill" title="Accept"><i class="fa-solid fa-check"></i></button>
                                    </form>
                                    <form action="restaurant-admin" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updateOrderStatus">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <input type="hidden" name="status" value="REJECTED">
                                        <button type="submit" class="btn btn-sm btn-danger rounded-pill" title="Reject"><i class="fa-solid fa-xmark"></i></button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
                </div>
            </div>
        </div>
        </c:if>

        </c:otherwise>
    </c:choose>
</div>

<!-- All Reviews Modal -->
<div class="modal fade" id="reviewsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0 pb-0 mt-2 mx-2">
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-star text-warning me-2"></i>All Customer Reviews</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="col-md-6">
                            <div class="card border-0 shadow-sm h-100 rounded-4 bg-light">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="fw-bold"><i class="fa-solid fa-user-circle text-muted me-2"></i>${rev.username}</span>
                                        <span class="text-warning small">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fa-${i <= rev.rating ? 'solid' : 'regular'} fa-star"></i>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <p class="text-muted small mb-0">${not empty rev.comment ? rev.comment : '<em>No comment provided</em>'}</p>
                                    <div class="text-end mt-2"><small class="text-muted" style="font-size:0.7rem;">${rev.createdAt}</small></div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- All Orders Modal -->
<div class="modal fade" id="ordersModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0 pb-0 mt-2 mx-2">
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-list text-danger me-2"></i>All Orders</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0 mt-3">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Order ID</th>
                            <th>Items</th>
                            <th>Amount</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${allOrders}">
                        <tr>
                            <td class="ps-4 fw-bold">#${order.id}</td>
                            <td class="small text-muted">
                                <c:forEach var="item" items="${order.items}" varStatus="s">
                                    ${item.quantity}x ${item.foodItemName}<c:if test="${!s.last}">, </c:if>
                                </c:forEach>
                            </td>
                            <td class="fw-bold">&#8377;${order.totalAmount}</td>
                            <td><span class="badge bg-light text-dark border">${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</span></td>
                            <td>
                                <span class="badge ${order.status == 'DELIVERED' ? 'bg-success' : (order.status == 'REJECTED' ? 'bg-danger' : (order.status == 'OUT_FOR_DELIVERY' ? 'bg-info' : (order.status == 'PREPARING' ? 'bg-warning text-dark' : 'bg-secondary')))}">
                                    ${order.status}
                                </span>
                            </td>
                            <td class="text-muted small"><fmt:formatDate value="${order.orderDate}" pattern="dd MMM, hh:mm a" /></td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
// ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ Status donut chart ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬
const ctx = document.getElementById('statusChart');
if (ctx) {
    const chartData = [
        parseInt('${empty chartPending ? 0 : chartPending}') || 0,
        parseInt('${empty chartPreparing ? 0 : chartPreparing}') || 0,
        parseInt('${empty chartOut ? 0 : chartOut}') || 0,
        parseInt('${empty chartDelivered ? 0 : chartDelivered}') || 0,
        parseInt('${empty chartRejected ? 0 : chartRejected}') || 0
    ];
    const total = chartData.reduce((a, b) => a + b, 0);

    if (total === 0) {
        // Show empty state message
        ctx.parentElement.innerHTML += '<div class="text-center text-muted py-4"><i class="fa-solid fa-chart-pie fa-3x mb-3 opacity-25"></i><p>No orders yet for this restaurant.</p></div>';
        ctx.style.display = 'none';
    } else {
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Rejected'],
                datasets: [{
                    data: chartData,
                    backgroundColor: ['#6c757d','#ffc107','#17a2b8','#28a745','#dc3545'],
                    borderWidth: 0,
                    hoverOffset: 8
                }]
            },
            options: {
                cutout: '70%',
                plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 16 } } }
            }
        });
    }
}

// ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ WebSocket: listen for new orders in real-time ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬
<c:if test="${not empty restaurant}">
const wsUrl = "ws://" + window.location.host + "${pageContext.request.contextPath}/live/restaurant/${restaurant.id}";
const socket = new WebSocket(wsUrl);

socket.onmessage = function(event) {
    const msg = JSON.parse(event.data);
    if (msg.type === "NEW_ORDER") {
        new Audio("https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3").play().catch(()=>{});
        const banner = document.createElement("div");
        banner.style.cssText = "position:fixed;top:80px;right:20px;z-index:9999;background:#ff4757;color:white;padding:16px 22px;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,0.2);font-weight:700;font-size:1rem;";
        banner.innerHTML = '<i class="fa-solid fa-bell me-2"></i> New Order #' + msg.orderId + ' just arrived!<br><small style="font-weight:400;opacity:.85">Refreshing in 3 seconds...</small>';
        document.body.appendChild(banner);
        setTimeout(() => window.location.reload(), 3000);
    }
};
socket.onclose = function() { setTimeout(() => window.location.reload(), 30000); };
</c:if>
</script>

<jsp:include page="includes/footer.jsp" />



