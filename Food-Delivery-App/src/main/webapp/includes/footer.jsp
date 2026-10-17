</div> <!-- End .main-content -->

<!-- Footer -->
<footer class="bg-dark text-white pt-5 pb-3 mt-5">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <h4 class="fw-bold mb-3"><i class="fa-solid fa-burger me-2 text-danger"></i>Foodies</h4>
                <p style="color: #adb5bd; font-size: 0.875rem;">Delivering happiness to your doorstep since 2024. Fast, fresh, and always on time.</p>
                <p style="color: #adb5bd; font-size: 0.875rem;" class="mb-1 mt-3">
                    <i class="fa-solid fa-location-dot text-danger me-2"></i>
                    <strong class="text-white">Foodies HQ</strong>
                </p>
                <p style="color: #adb5bd; font-size: 0.78rem; line-height: 1.8;">
                    LH - 44, Global Institute Of Technology,<br>
                    ITS, 1 &amp; 2, IT Park Rd, Sitapura Industrial Area,<br>
                    Sitapura, Jaipur, Rajasthan 302022
                </p>
                <div class="d-flex gap-3 mt-2">
                    <a href="#" class="text-muted fs-5"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="text-muted fs-5"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#" class="text-muted fs-5"><i class="fa-brands fa-facebook"></i></a>
                </div>
            </div>
            <div class="col-md-2">
                <h6 class="fw-bold mb-3 text-white">Company</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="about.jsp" style="color:#adb5bd;" class="text-decoration-none">About Us</a></li>
                    <li class="mb-2"><a href="careers.jsp" style="color:#adb5bd;" class="text-decoration-none">Careers</a></li>
                    <li class="mb-2"><a href="blog.jsp" style="color:#adb5bd;" class="text-decoration-none">Blog</a></li>
                </ul>
            </div>
            <div class="col-md-2">
                <h6 class="fw-bold mb-3 text-white">Support</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="help.jsp" style="color:#adb5bd;" class="text-decoration-none">Help Center</a></li>
                    <li class="mb-2"><a href="track" style="color:#adb5bd;" class="text-decoration-none">Track Order</a></li>
                    <li class="mb-2"><a href="contact.jsp" style="color:#adb5bd;" class="text-decoration-none">Contact Us</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h6 class="fw-bold mb-3 text-white">Download the App</h6>
                <a href="#" class="btn btn-outline-light btn-sm rounded-pill px-4 me-2 mb-2"><i class="fa-brands fa-apple me-2"></i>App Store</a>
                <a href="#" class="btn btn-outline-light btn-sm rounded-pill px-4 mb-2"><i class="fa-brands fa-google-play me-2"></i>Play Store</a>
                <p style="color:#adb5bd;" class="small mt-2">For a better experience, try our app!</p>
            </div>
        </div>
        <hr class="border-secondary">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
            <p style="color:#adb5bd;" class="small mb-0">&copy; 2026 Foodies Inc. All rights reserved.</p>
            <div class="d-flex gap-3">
                <a href="admin" style="color:#adb5bd;" class="text-decoration-none small">Admin</a>
                <a href="privacy.jsp" style="color:#adb5bd;" class="text-decoration-none small">Privacy</a>
                <a href="terms.jsp" style="color:#adb5bd;" class="text-decoration-none small">Terms</a>
            </div>
        </div>
    </div>
</footer>

<!-- AI Assistant Widget -->
<div id="aiChatWidget" class="position-fixed shadow-lg" style="bottom: 170px; left: 20px; width: 320px; z-index: 1050; border-radius: 16px; overflow: hidden; display: none; border: 1px solid #eee;">
    <div style="background: linear-gradient(135deg, #a29bfe, #6c5ce7);" class="text-white p-3 d-flex justify-content-between align-items-center">
        <span class="fw-bold"><i class="fa-solid fa-wand-magic-sparkles me-2"></i>Foodies AI</span>
        <button type="button" class="btn-close btn-close-white" onclick="toggleChat()"></button>
    </div>
    <div class="bg-white p-3" style="height: 260px; overflow-y: auto;" id="chatBody">
        <div class="mb-3">
            <div class="d-inline-block bg-light rounded-3 p-2 small" style="max-width:85%"> Hey! I'm your Foodies AI. Ask me anything  "best veg items", "cheapest burger", "how to track my order"?</div>
        </div>
    </div>
    <div class="bg-light p-2 border-top d-flex gap-2">
        <input type="text" id="chatInput" class="form-control form-control-sm rounded-pill border-0 shadow-none" placeholder="Ask me..." onkeydown="if(event.key==='Enter') sendChat()">
        <button class="btn btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width:34px;height:34px;background:#ff4757;color:white;flex-shrink:0;" onclick="sendChat()"><i class="fa-solid fa-paper-plane" style="font-size:12px;"></i></button>
    </div>
</div>

<style>
@keyframes gentle-float {
    0%, 100% { transform: translateY(0); box-shadow: 0 4px 12px rgba(108, 92, 231, 0.4); }
    50% { transform: translateY(-8px); box-shadow: 0 12px 24px rgba(108, 92, 231, 0.6); }
}
.ai-fab {
    animation: gentle-float 3s ease-in-out infinite;
    transition: all 0.3s ease;
}
.ai-fab.stopped {
    animation: none !important;
    transform: none !important;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
}
.ai-badge {
    position: fixed;
    left: 85px;
    bottom: 105px;
    background: white;
    color: #6c5ce7;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: bold;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    z-index: 1039;
    border: 2px solid #6c5ce7;
    pointer-events: none;
}
.ai-badge::before {
    content: '';
    position: absolute;
    left: -6px;
    top: 50%;
    transform: translateY(-50%);
    border-width: 6px 8px 6px 0;
    border-style: solid;
    border-color: transparent #6c5ce7 transparent transparent;
}
.ai-badge::after {
    content: '';
    position: absolute;
    left: -3px;
    top: 50%;
    transform: translateY(-50%);
    border-width: 4px 6px 4px 0;
    border-style: solid;
    border-color: transparent white transparent transparent;
}
</style>

<!-- AI FAB -->
<div class="ai-badge" id="aiBadgeMsg">Ask Foodies AI! <i class="fa-solid fa-wand-magic-sparkles"></i></div>
<button class="ai-fab position-fixed rounded-circle shadow-lg d-flex align-items-center justify-content-center border-0" style="left:20px;bottom:90px;width:65px;height:65px;background:linear-gradient(135deg, #a29bfe, #6c5ce7);color:white;z-index:1040;" onclick="toggleChat()" title="Chat with AI">
    <i class="fa-solid fa-robot" style="font-size: 1.6rem;"></i>
</button>

<script>
function toggleChat() {
    const w = document.getElementById('aiChatWidget');
    const fab = document.querySelector('.ai-fab');
    if (w.style.display === 'none') {
        w.style.display = 'block';
        fab.classList.add('stopped');
        document.getElementById('aiBadgeMsg').style.display='none';
    } else {
        w.style.display = 'none';
        fab.classList.remove('stopped');
    }
}

const aiReplies = {
    'veg': 'We have amazing veg options! Try Paneer Tikka, Veg Biryani, or Margherita Pizza. ',
    'burger': 'Our bestselling burger is the Double BBQ Smash Burger at &#8377;299! ',
    'track': 'You can track your order from the navbar &rarr; your name &rarr; Track Order! ',
    'delivery': 'Estimated delivery is 25-45 minutes depending on your location. ',
    'offer': 'Use code FOODIES50 for 50% off your first order! ',
    'default': "That's a great question! Head to our menu for the full selection. "
};

function sendChat() {
    const input = document.getElementById('chatInput');
    const msg = input.value.trim();
    if (!msg) return;
    
    const chatBody = document.getElementById('chatBody');
    chatBody.innerHTML += '<div class="mb-2 text-end"><div class="d-inline-block text-white rounded-3 p-2 small" style="background: linear-gradient(135deg, #a29bfe, #6c5ce7); max-width:85%;">' + msg + '</div></div>';
    input.value = '';
    
    const loadingId = 'loading-' + Date.now();
    chatBody.innerHTML += '<div class="mb-2" id="' + loadingId + '"><div class="d-inline-block bg-light rounded-3 p-2 small text-muted" style="max-width:85%"><i class="fa-solid fa-circle-notch fa-spin me-2"></i>Thinking...</div></div>';
    chatBody.scrollTop = chatBody.scrollHeight;

    fetch(window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) + '/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: msg })
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById(loadingId).remove();
        let replyHtml = data.reply.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>').replace(/\n/g, '<br>');
        chatBody.innerHTML += '<div class="mb-2"><div class="d-inline-block bg-light rounded-3 p-2 small" style="max-width:85%">' + replyHtml + '</div></div>';
        chatBody.scrollTop = chatBody.scrollHeight;
    })
    .catch(error => {
        document.getElementById(loadingId).remove();
        chatBody.innerHTML += '<div class="mb-2"><div class="d-inline-block bg-danger-subtle text-danger rounded-3 p-2 small" style="max-width:85%">Failed to connect to AI server. Check Tomcat console.</div></div>';
        chatBody.scrollTop = chatBody.scrollHeight;
    });
}
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
