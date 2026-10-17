<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/header.jsp" />

<style>
.register-card { border-radius: 24px; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.12); }
.register-left { background: linear-gradient(135deg, #0f3460, #16213e, #1a1a2e); min-height: 500px; display: flex; flex-direction: column; justify-content: center; padding: 3rem; }
.register-right { padding: 3rem; overflow-y: auto; }
.input-icon-group { position: relative; }
.input-icon-group .form-control { padding-left: 44px; border-radius: 10px; border: 2px solid #eee; transition: border-color 0.2s; }
.input-icon-group .form-control:focus { border-color: #ff4757; box-shadow: none; }
.input-icon-group .icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #aaa; }
</style>

<div class="container py-5" style="min-height: 80vh; display: flex; align-items: center;">
    <div class="row register-card bg-white w-100 mx-0 g-0">
        <!-- Left Panel -->
        <div class="col-lg-4 register-left text-white d-none d-lg-flex flex-column">
            <div>
                <h2 class="fw-bold mb-3"><i class="fa-solid fa-burger me-2 text-danger"></i>Foodies</h2>
                <h4 class="mb-3">Join the family!</h4>
                <p class="opacity-75 small mb-4">Create your account and get exclusive first-order offers, faster checkout, and real-time tracking.</p>
                <div class="bg-white bg-opacity-10 rounded-3 p-3">
                    <p class="mb-2 small"><i class="fa-solid fa-gift text-warning me-2"></i><strong>50% OFF</strong> on your first order</p>
                    <p class="mb-2 small"><i class="fa-solid fa-truck-fast text-info me-2"></i>Free delivery for 30 days</p>
                    <p class="mb-0 small"><i class="fa-solid fa-star text-warning me-2"></i>Exclusive member deals</p>
                </div>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="col-lg-8 register-right">
            <h3 class="fw-bold mb-1">Create Account</h3>
            <p class="text-muted mb-4">It's free and takes less than a minute!</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger rounded-3 py-2 small"><i class="fa-solid fa-circle-xmark me-2"></i>${errorMessage}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger rounded-3 py-2 small"><i class="fa-solid fa-circle-xmark me-2"></i>${param.error}</div>
            </c:if>

            <form action="register" method="POST">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Username <span class="text-danger">*</span></label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-user icon"></i>
                            <input type="text" class="form-control" name="username" required placeholder="Choose a username">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Email <span class="text-danger">*</span></label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-envelope icon"></i>
                            <input type="email" class="form-control" name="email" required placeholder="you@example.com">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Password <span class="text-danger">*</span></label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-lock icon"></i>
                            <input type="password" class="form-control" name="password" id="password" required placeholder="Min 8 characters">
                        </div>
                        <div class="progress mt-2" style="height:4px;">
                            <div class="progress-bar" id="pwStrengthBar" style="width:0%;transition:width 0.3s;"></div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Confirm Password <span class="text-danger">*</span></label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-lock icon"></i>
                            <input type="password" class="form-control" name="confirmPassword" id="confirmPw" required placeholder="Repeat password">
                        </div>
                        <small id="pwMatch" class="text-muted"></small>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Phone Number</label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-phone icon"></i>
                            <input type="tel" class="form-control" name="phone" placeholder="+91 XXXXX XXXXX">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Referral Code (Optional)</label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-ticket icon"></i>
                            <input type="text" class="form-control" name="referral" placeholder="FOODIES50">
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label small fw-bold">Register As <span class="text-danger">*</span></label>
                        <div class="input-icon-group">
                            <i class="fa-solid fa-users icon"></i>
                            <select class="form-select form-control" name="role" required>
                                <option value="CUSTOMER">Customer</option>
                                <option value="RESTAURANT_OWNER">Restaurant Owner</option>
                                <option value="DELIVERY_PARTNER">Delivery Partner (Rider)</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label small" for="terms">
                                I agree to the <a href="#" class="text-danger">Terms of Service</a> and <a href="#" class="text-danger">Privacy Policy</a>
                            </label>
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary-custom w-100 py-3 fw-bold fs-6 rounded-3">
                            <i class="fa-solid fa-user-plus me-2"></i>Create My Account
                        </button>
                    </div>
                </div>
            </form>

            <p class="text-center text-muted mt-4 mb-0">Already have an account? <a href="login.jsp" class="text-danger fw-bold text-decoration-none">Login</a></p>
        </div>
    </div>
</div>

<script>
// Password strength meter
document.getElementById('password').addEventListener('input', function() {
    const pw = this.value;
    let strength = 0;
    if (pw.length >= 8) strength++;
    if (/[A-Z]/.test(pw)) strength++;
    if (/[0-9]/.test(pw)) strength++;
    if (/[^A-Za-z0-9]/.test(pw)) strength++;
    const bar = document.getElementById('pwStrengthBar');
    const colors = ['#dc3545','#fd7e14','#ffc107','#28a745'];
    bar.style.width = (strength * 25) + '%';
    bar.style.background = colors[strength - 1] || '#eee';
});

// Password match check
document.getElementById('confirmPw').addEventListener('input', function() {
    const pw = document.getElementById('password').value;
    const el = document.getElementById('pwMatch');
    if (this.value === pw) { el.textContent = '&#10003; Passwords match'; el.className = 'text-success small'; }
    else { el.textContent = '&#10007; Passwords do not match'; el.className = 'text-danger small'; }
});
</script>

<jsp:include page="includes/footer.jsp" />
