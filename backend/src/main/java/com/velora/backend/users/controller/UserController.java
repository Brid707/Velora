package com.velora.backend.users.controller;

import com.velora.backend.common.response.ApiResponse;

import com.velora.backend.posts.dto.PostResponse;
import com.velora.backend.posts.repository.PostRepository;

import com.velora.backend.users.dto.ProfileResponse;
import com.velora.backend.users.dto.UserResponse;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {

    private final UserRepository userRepository;
    private final PostRepository postRepository;

    @GetMapping("/search")
    public ApiResponse<List<UserResponse>> searchUsers(
            @RequestParam String query
    ) {
        List<UserResponse> users = userRepository
                .findByUsernameContainingIgnoreCase(query)
                .stream()
                .map(UserResponse::fromEntity)
                .toList();

        return ApiResponse.ok(
                "Usuarios encontrados",
                users
        );
    }

    @GetMapping("/me")
    public ApiResponse<ProfileResponse> me(
            Principal principal
    ) {
        UserEntity user = userRepository
                .findByEmail(principal.getName())
                .orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );

        List<PostResponse> posts = postRepository
                .findByUserIdOrderByCreatedAtDesc(user.getId())
                .stream()
                .map(PostResponse::fromEntity)
                .toList();

        ProfileResponse profile = ProfileResponse
                .builder()
                .user(UserResponse.fromEntity(user))
                .posts(posts)
                .build();

        return ApiResponse.ok(
                "Perfil obtenido",
                profile
        );
    }

    @GetMapping("/{userId}")
    public ApiResponse<ProfileResponse> getUserProfile(
            @PathVariable String userId
    ) {
        UserEntity user = userRepository
                .findById(userId)
                .orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );

        List<PostResponse> posts = postRepository
                .findByUserIdOrderByCreatedAtDesc(user.getId())
                .stream()
                .map(PostResponse::fromEntity)
                .toList();

        ProfileResponse profile = ProfileResponse
                .builder()
                .user(UserResponse.fromEntity(user))
                .posts(posts)
                .build();

        return ApiResponse.ok(
                "Perfil obtenido",
                profile
        );
    }
}