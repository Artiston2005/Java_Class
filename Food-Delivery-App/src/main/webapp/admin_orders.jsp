<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="includes/header.jsp" />

<div class="container py-5" style="min-height: 70vh;">
    <div class="row mb-4">
        <div class="col d-flex justify-content-between align-items-center">
            <h2 class="fw-bold"><i class="fa-solid fa-bell text-danger me-2"></i>Live Orders Dashboard</h2>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-dark">Back to Catalog</a>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty groupedOrders}">
            <div class="card border-0 shadow-sm p-5 text-center text-muted">
                <i class="fa-solid fa-inbox fa-3x mb-3 opacity-50"></i>
                <h5>No incoming orders yet.</h5>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="entry" items="${groupedOrders}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                        <h5 class="fw-bold text-danger mb-0"><i class="fa-solid fa-store me-2"></i>${entry.key}</h5>
                    </div>
                    <div class="card-body p-0 mt-3">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Order ID</th>
                                    <th>Date & Time</th>
                                    <th>Customer</th>
                                    <th>Items</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${entry.value}">
                                    <tr>
                                        <td class="ps-4 fw-bold">#${order.id}</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" /></td>
                                        <td class="fw-medium">${userNames[order.userId]}</td>
                                        <td>
                                            <ul class="list-unstyled mb-0 small">
                                                <c:forEach var="item" items="${order.items}">
                                                    <li><span class="badge bg-light text-dark border me-1">${item.quantity}x</span> ${item.foodItemName}</li>
                                                </c:forEach>
                                            </ul>
                                        </td>
                                        <td class="fw-bold text-dark">&#8377; ${order.totalAmount}</td>
                                        <td>
                                            <span class="badge ${order.status == 'DELIVERED' ? 'bg-success' : (order.status == 'PREPARING' ? 'bg-warning text-dark' : (order.status == 'REJECTED' ? 'bg-danger' : 'bg-info'))}">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-flex justify-content-end gap-2">
                                                <input type="hidden" name="orderId" value="${order.id}">
                                                <select name="status" class="form-select form-select-sm" style="width: auto;">
                                                    <option value="PREPARING" ${order.status == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                                    <option value="OUT_FOR_DELIVERY" ${order.status == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                                    <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                                    <option value="REJECTED" ${order.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-dark">Update</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="includes/footer.jsp" />
