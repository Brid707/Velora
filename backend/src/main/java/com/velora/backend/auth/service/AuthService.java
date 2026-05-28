package com.velora.backend.auth.service;

import com.velora.backend.auth.dto.AuthResponse;
import com.velora.backend.auth.dto.LoginRequest;
import com.velora.backend.auth.dto.RegisterRequest;
import com.velora.backend.auth.security.JwtService;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("El correo ya está registrado");
        }

        if (userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new RuntimeException("El nombre de usuario ya está registrado");
        }

        UserEntity user = UserEntity.builder()
                .fullName(request.getFullName())
                .username(request.getUsername())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .bio("")
                .profileImageUrl("")
                .followersCount(0)
                .followingCount(0)
                .postsCount(0)
                .build();

        UserEntity savedUser = userRepository.save(user);
        String token = jwtService.generateToken(savedUser);

        return AuthResponse.builder()
                .success(true)
                .token(token)
                .user(savedUser)
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        UserEntity user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Credenciales incorrectas"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Credenciales incorrectas");
        }

        String token = jwtService.generateToken(user);

        return AuthResponse.builder()
                .success(true)
                .token(token)
                .user(user)
                .build();
    }
}