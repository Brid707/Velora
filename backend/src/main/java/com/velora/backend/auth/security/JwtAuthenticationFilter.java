package com.velora.backend.auth.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.crypto.SecretKey;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String SECRET =
            "velora_super_secret_key_for_jwt_authentication_2026_segura_segura";

    private SecretKey getKey() {
        return Keys.hmacShaKeyFor(
                SECRET.getBytes(StandardCharsets.UTF_8)
        );
    }

    @Override
    protected boolean shouldNotFilter(
            HttpServletRequest request
    ) {
        String path = request.getServletPath();
        String method = request.getMethod();

        if (path == null) return false;

        // Rutas públicas
        if (path.startsWith("/api/auth/") || path.equals("/api/auth")) return true;
        if (path.startsWith("/api/cloudinary/") || path.equals("/api/cloudinary")) return true;
        if (path.equals("/api/health") || path.equals("/health")) return true;
        if (path.startsWith("/swagger-ui/") || path.equals("/swagger-ui")) return true;
        if (path.startsWith("/v3/api-docs/") || path.equals("/v3/api-docs")) return true;

        // Lecturas públicas
        if (method.equals(HttpMethod.GET.name())) {
            return path.startsWith("/api/posts")
                    || path.startsWith("/api/reels")
                    || path.startsWith("/api/stories")
                    || path.startsWith("/api/users")
                    || path.startsWith("/api/recommendation")
                    || path.startsWith("/api/recommendations");
        }

        // Demo: permitir acciones sin bloquear por JWT
        return path.startsWith("/api/posts")
                || path.startsWith("/api/stories")
                || path.startsWith("/api/reels")
                || path.startsWith("/api/comments")
                || path.startsWith("/api/likes")
                || path.startsWith("/api/reposts")
                || path.startsWith("/api/saved")
                || path.startsWith("/api/follows")
                || path.startsWith("/api/messages")
                || path.startsWith("/api/notifications")
                || path.startsWith("/api/users");
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        final String authHeader =
                request.getHeader("Authorization");

        if (authHeader == null ||
                !authHeader.startsWith("Bearer ")) {

            filterChain.doFilter(request, response);
            return;
        }

        try {
            final String token =
                    authHeader.substring(7);

            Claims claims = Jwts.parser()
                    .verifyWith(getKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            String email = claims.getSubject();

            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                            email,
                            null,
                            List.of(new SimpleGrantedAuthority("USER"))
                    );

            SecurityContextHolder
                    .getContext()
                    .setAuthentication(authentication);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Token inválido");
            return;
        }

        filterChain.doFilter(request, response);
    }
}