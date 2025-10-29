package com.mfu.studybuddy.security;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.mfu.studybuddy.repository.UserRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class UserIdFilter extends OncePerRequestFilter {
    
    private static final Logger logger = LoggerFactory.getLogger(UserIdFilter.class);
    
    @Autowired
    private UserRepository userRepository;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        
        String requestUri = request.getRequestURI();
        logger.info("Filter processing URI: {}", requestUri);

        // Skip filter for H2 console and security endpoints
        if (requestUri.startsWith("/h2-console") || requestUri.startsWith("/security")) {
            logger.info("Skipping filter for URI: {}", requestUri);
            filterChain.doFilter(request, response);
            return;
        }

        if (requestUri.startsWith("/api")) {
            logger.info("Processing API request: {}", requestUri);
            String userId = request.getHeader("User-ID");
            
            logger.info("Processing request to: {} with User-ID header: {}", requestUri, userId);
            
            if (userId == null || userId.isEmpty()) {
                logger.warn("Missing User-ID header for request to: {}", requestUri);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Missing User-ID header");
                return;
            }
            
            try {
                Long id = Long.parseLong(userId);
                logger.debug("Parsed User-ID: {} for request to: {}", id, requestUri);
                
                boolean userExists = userRepository.existsById(id);
                
                if (!userExists) {
                    logger.warn("Invalid User-ID: {} - user not found in database for request to: {}", id, requestUri);
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("Invalid User-ID");
                    return;
                }
                
                // SET SPRING SECURITY CONTEXT - THIS IS THE KEY!
                UsernamePasswordAuthenticationToken authentication = 
                    new UsernamePasswordAuthenticationToken(
                        id.toString(), 
                        null, 
                        List.of(new SimpleGrantedAuthority("ROLE_USER"))
                    );
                SecurityContextHolder.getContext().setAuthentication(authentication);
                
                logger.info("Successfully authenticated User-ID: {} and set security context for request to: {}", id, requestUri);
                request.setAttribute("userId", id);
                
            } catch (NumberFormatException e) {
                logger.error("Invalid User-ID format: '{}' for request to: {} - {}", userId, requestUri, e.getMessage());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid User-ID format");
                return;
            }
        } else {
            logger.info("Non-API request, continuing filter chain: {}", requestUri);
        }
        
        filterChain.doFilter(request, response);
    }
}