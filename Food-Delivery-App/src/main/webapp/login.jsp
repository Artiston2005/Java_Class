<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/header.jsp" />

<style>
.login-card { border-radius: 24px; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.12); }
.login-left { background: linear-gradient(135deg, #ff4757, #ff6b6b, #fd79a8); min-height: 500px; display: flex; flex-direction: column; justify-content: center; padding: 3rem; }
.login-right { padding: 3rem; }
.input-icon-group { position: relative; }
.input-icon-group .form-control { padding-left: 44px; border-radius: 10px; border: 2px solid #eee; transition: border-color 0.2s; }
.input-icon-group .form-control:focus { border-color: #ff4757; box-shadow: none; }
.input-icon-group .icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #aaa; }
</style>

<div class="container py-5" style="min-height: 80vh; display: flex; align-items: center;">
    <div class="row login-card bg-white w-100 mx-0 g-0">
        <!-- Left Panel -->
        <div class="col-lg-5 login-left text-white d-none d-lg-flex">
            <div>
                <h1 class="display-5 fw-bold mb-3"><i class="fa-solid fa-burger me-2"></i>Foodies</h1>
                <p class="lead mb-4 opacity-90">Your favourite food, delivered in minutes.</p>
                <ul class="list-unstyled fs-6 opacity-80">
                    <li class="mb-3"><i class="fa-solid fa-circle-check me-3"></i>30-minute delivery guarantee</li>
                    <li class="mb-3"><i class="fa-solid fa-circle-check me-3"></i>50+ restaurants near you</li>
                    <li class="mb-3"><i class="fa-solid fa-circle-check me-3"></i>Exclusive offers &amp; cashback</li>
                    <li><i class="fa-solid fa-circle-check me-3"></i>Real-time GPS tracking</li>
                </ul>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="col-lg-7 login-right">
            <h3 class="fw-bold mb-1">Welcome back! </h3>
            <p class="text-muted mb-4">Login to order your favourite food</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger rounded-3 py-2 small"><i class="fa-solid fa-circle-xmark me-2"></i>${errorMessage}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger rounded-3 py-2 small"><i class="fa-solid fa-circle-xmark me-2"></i>Invalid username or password.</div>
            </c:if>

            <form action="login" method="POST">
                <div class="mb-4 input-icon-group">
                    <i class="fa-solid fa-user icon"></i>
                    <input type="text" class="form-control" name="username" placeholder="Username" required>
                </div>
                <div class="mb-4 input-icon-group">
                    <i class="fa-solid fa-lock icon"></i>
                    <input type="password" class="form-control" name="password" placeholder="Password" required>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label small" for="rememberMe">Remember me</label>
                    </div>
                    <a href="#" class="text-danger small text-decoration-none">Forgot password?</a>
                </div>
                <button type="submit" class="btn btn-primary-custom w-100 py-3 fw-bold fs-6 rounded-3">Login</button>
            </form>

            <div class="text-center my-4 position-relative">
                <hr><span class="position-absolute top-50 start-50 translate-middle bg-white px-3 text-muted small">or continue with</span>
            </div>

            <div class="d-flex gap-3 mb-4">
                <button class="btn btn-outline-secondary flex-fill rounded-3 py-2" onclick="alert('OAuth coming soon!')"><i class="fa-brands fa-google me-2 text-danger"></i>Google</button>
                <button class="btn btn-outline-secondary flex-fill rounded-3 py-2" onclick="alert('OAuth coming soon!')"><i class="fa-brands fa-facebook me-2 text-primary"></i>Facebook</button>
            </div>

            <p class="text-center text-muted mb-0">Don't have an account? <a href="register.jsp" class="text-danger fw-bold text-decoration-none">Sign Up Free</a></p>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
