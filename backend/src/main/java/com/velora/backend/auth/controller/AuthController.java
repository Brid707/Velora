package com.velora.backend.auth.controller;

import com.velora.backend.auth.dto.AuthResponse;
import com.velora.backend.auth.dto.LoginRequest;
import com.velora.backend.auth.dto.RegisterRequest;
import com.velora.backend.auth.service.AuthService;
import com.velora.backend.common.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ApiResponse<AuthResponse> register(@RequestBody RegisterRequest request) {
        return ApiResponse.ok(
                "Usuario registrado correctamente",
                authService.register(request)
        );
    }

    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(@RequestBody LoginRequest request) {
        return ApiResponse.ok(
                "Inicio de sesión correcto",
                authService.login(request)
        );
    }
}