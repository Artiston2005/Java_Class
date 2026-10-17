package com.foodapp.filter;

import com.foodapp.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/profile", "/checkout", "/track", "/favorites", 
    "/admin/*", "/admin", 
    "/restaurant-admin", "/restaurant-menu",
    "/rider-dashboard"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        
        String path = req.getServletPath();

        // 1. Check if user is logged in
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Role-based access control (RBAC)
        String role = user.getRole();
        
        if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins Only");
            return;
        }
        
        if ((path.startsWith("/restaurant-admin") || path.startsWith("/restaurant-menu")) && !"RESTAURANT_OWNER".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Restaurant Owners Only");
            return;
        }
        
        if (path.startsWith("/rider-dashboard") && !"DELIVERY_PARTNER".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Delivery Partners Only");
            return;
        }

        // Passed all checks
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
