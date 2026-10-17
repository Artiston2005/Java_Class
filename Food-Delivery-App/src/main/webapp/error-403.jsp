<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<jsp:include page="includes/header.jsp" />

<div class="container text-center py-5" style="min-height: 70vh; display: flex; flex-direction: column; justify-content: center; align-items: center;">
    <h1 class="display-1 fw-bold text-danger"><i class="fa-solid fa-ban"></i> 403</h1>
    <h3 class="mb-4">Access Denied!</h3>
    <p class="text-muted mb-4">You don't have permission to view this page. You might be logged in with the wrong role.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary-custom px-4 py-2 rounded-pill fw-bold">
        <i class="fa-solid fa-house me-2"></i>Back to Home
    </a>
</div>

<jsp:include page="includes/footer.jsp" />
