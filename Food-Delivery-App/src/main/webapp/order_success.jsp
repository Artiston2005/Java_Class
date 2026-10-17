<jsp:include page="includes/header.jsp" />

<style>
.stepper-wrapper {
  margin-top: 40px;
  display: flex;
  justify-content: space-between;
  margin-bottom: 30px;
  position: relative;
}
.stepper-wrapper::before {
  position: absolute;
  content: "";
  border-bottom: 2px solid #ccc;
  width: 100%;
  top: 20px;
  left: 0;
  z-index: 0;
}
.stepper-item {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  z-index: 1;
}
.stepper-item .step-counter {
  position: relative;
  z-index: 5;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #ccc;
  margin-bottom: 6px;
  color: white;
  font-weight: bold;
}
.stepper-item.completed .step-counter {
  background-color: #198754;
}
.stepper-item.active .step-counter {
  background-color: #ff4757;
}
.step-name {
  font-size: 0.85rem;
  font-weight: 600;
  color: #555;
}
</style>

<div class="container py-5 d-flex justify-content-center align-items-center" style="min-height: 70vh;">
    <div class="card border-0 shadow-sm p-5 text-center w-100" style="max-width: 700px;">
        <div class="mb-4 text-success">
            <i class="fa-solid fa-circle-check fa-4x"></i>
        </div>
        <h2 class="fw-bold mb-3">Order Confirmed!</h2>
        <p class="text-muted mb-4"><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "Your delicious food is being prepared." %></p>
        
        <!-- Tracking Stepper -->
        <div class="stepper-wrapper">
          <div class="stepper-item completed">
            <div class="step-counter"><i class="fa-solid fa-check"></i></div>
            <div class="step-name">Order Placed</div>
          </div>
          <div class="stepper-item active">
            <div class="step-counter"><i class="fa-solid fa-fire-burner"></i></div>
            <div class="step-name">Preparing</div>
          </div>
          <div class="stepper-item">
            <div class="step-counter"><i class="fa-solid fa-motorcycle"></i></div>
            <div class="step-name">On the Way</div>
          </div>
          <div class="stepper-item">
            <div class="step-counter"><i class="fa-solid fa-house-chimney"></i></div>
            <div class="step-name">Delivered</div>
          </div>
        </div>
        
        <div class="p-3 bg-light rounded mb-4 text-start">
            <h6 class="fw-bold">Delivery Details:</h6>
            <p class="mb-1 text-muted"><i class="fa-solid fa-user me-2"></i> ${sessionScope.loggedUser.username}</p>
            <p class="mb-0 text-muted"><i class="fa-solid fa-location-dot me-2"></i> ${sessionScope.loggedUser.address}</p>
        </div>

        <a href="menu" class="btn btn-primary-custom px-5 py-2 fw-bold">Order More</a>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
