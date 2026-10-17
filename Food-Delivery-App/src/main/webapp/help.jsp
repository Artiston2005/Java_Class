<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="includes/header.jsp" />
<div class="container py-5" style="min-height: 70vh;">
    <div class="row justify-content-center">
        <div class="col-md-8 text-center">
            <i class="fa-solid fa-life-ring fa-3x text-danger mb-4"></i>
            <h2 class="fw-bold mb-4">Help Center</h2>
            <div class="card border-0 shadow-sm p-5 text-start">
                <p>Welcome to the Help Center. Have you tried turning your food off and on again?</p>
                <p><b>Frequently Asked Questions:</b></p>
                <div class="accordion" id="helpAcc">
                    <div class="accordion-item mb-2 border-0 shadow-sm rounded">
                        <h2 class="accordion-header"><button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#q1">Where is my food?</button></h2>
                        <div id="q1" class="accordion-collapse collapse" data-bs-parent="#helpAcc"><div class="accordion-body">Probably in traffic. Or the delivery guy is taking a scenic route to "find himself". Please be patient.</div></div>
                    </div>
                    <div class="accordion-item mb-2 border-0 shadow-sm rounded">
                        <h2 class="accordion-header"><button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#q2">Can I get a refund?</button></h2>
                        <div id="q2" class="accordion-collapse collapse" data-bs-parent="#helpAcc"><div class="accordion-body">No. We spent it on our AI Existence Fees.</div></div>
                    </div>
                </div>
                <a href="home" class="btn btn-outline-dark rounded-pill mt-4"><i class="fa-solid fa-arrow-left me-2"></i>I don't need help anymore</a>
            </div>
        </div>
    </div>
</div>
<jsp:include page="includes/footer.jsp" />
