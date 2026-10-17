<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Menu Management | Foodies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
<jsp:include page="includes/header.jsp" />

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold"><i class="fa-solid fa-utensils me-2"></i>Menu Management</h3>
        <a href="restaurant-admin" class="btn btn-outline-dark rounded-pill">Back to Dashboard</a>
    </div>

    <div class="card border-0 shadow-sm p-4 mb-4" id="itemFormCard">
        <h5 class="fw-bold mb-4" id="formTitle"><i class="fa-solid fa-pen-to-square text-danger me-2"></i>Add / Edit Menu Item</h5>
        <form action="restaurant-menu" method="POST" id="itemForm">
            <input type="hidden" name="action" value="addFood">
            <input type="hidden" name="itemId" id="formItemId" value="">
            <input type="hidden" name="restaurantId" value="${restaurant.id}">
            <div class="row g-3">
                <div class="col-md-8">
                    <label class="form-label small fw-bold">Item Name</label>
                    <input type="text" class="form-control" name="name" id="formName" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold">Price (&#8377;)</label>
                    <input type="number" step="0.01" class="form-control" name="price" id="formPrice" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold">Prep Time (mins)</label>
                    <input type="number" class="form-control" name="prepTime" id="formPrepTime" required value="15">
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold">Category</label>
                    <select class="form-select" name="categoryId" id="formCategoryId" required>
                        <c:forEach var="cat" items="${allCategories}">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold">Diet Type</label>
                    <select class="form-select" name="isVeg" id="formIsVeg" required>
                        <option value="true">Veg</option>
                        <option value="false">Non-Veg</option>
                    </select>
                </div>
                <div class="col-md-12">
                    <label class="form-label small fw-bold">Image URL</label>
                    <input type="url" class="form-control" name="imageUrl" id="formImageUrl" placeholder="https://...">
                </div>
                <div class="col-12">
                    <label class="form-label small fw-bold">Description</label>
                    <textarea class="form-control" name="description" id="formDescription" rows="2" required></textarea>
                </div>
                <div class="col-12 d-flex gap-2 mt-4">
                    <button type="submit" class="btn btn-dark rounded-pill px-5 fw-bold" id="formSubmitBtn">Save Item</button>
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" onclick="clearForm()">Clear / New</button>
                </div>
            </div>
        </form>
    </div>
    
    <div class="card border-0 shadow-sm rounded-4">
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Item</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${menuItems}">
                        <tr>
                            <td class="ps-4 fw-bold">${item.name}</td>
                            <td>
                                <span class="badge ${item.veg ? 'bg-success' : 'bg-danger'}">${item.veg ? 'Veg' : 'Non-Veg'}</span>
                            </td>
                            <td>&#8377;${item.price}</td>
                            <td class="text-end pe-4">
                                <button class="btn btn-sm btn-outline-dark me-2" onclick="editItem(${item.id}, '${item.name.replace("'", "\\'")}', ${item.price}, ${item.categoryId}, ${item.veg}, '${item.imageUrl}', '${item.description.replace("'", "\\'")}', ${item.prepTime})"><i class="fa-solid fa-pen"></i></button>
                                <form action="restaurant-menu" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteFood">
                                    <input type="hidden" name="foodId" value="${item.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this item?')"><i class="fa-solid fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty menuItems}">
                        <tr><td colspan="4" class="text-center py-4 text-muted">No menu items found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function editItem(id, name, price, categoryId, isVeg, imageUrl, desc, prepTime) {
    document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-pen text-danger me-2"></i>Edit Item: ' + name;
    document.getElementById('formItemId').value = id;
    document.getElementById('formName').value = name;
    document.getElementById('formPrice').value = price;
    document.getElementById('formPrepTime').value = prepTime;
    document.getElementById('formCategoryId').value = categoryId;
    document.getElementById('formIsVeg').value = isVeg.toString();
    document.getElementById('formImageUrl').value = imageUrl;
    document.getElementById('formDescription').value = desc;
    document.getElementById('formSubmitBtn').innerText = 'Update Item';
    document.getElementById('itemFormCard').scrollIntoView({ behavior: 'smooth' });
}

function clearForm() {
    document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-pen-to-square text-danger me-2"></i>Add / Edit Menu Item';
    document.getElementById('formItemId').value = '';
    document.getElementById('itemForm').reset();
    document.getElementById('formSubmitBtn').innerText = 'Save Item';
}
</script>
<jsp:include page="includes/footer.jsp" />
</body>
</html>