package com.velora.backend.recommendation.controller;

import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.posts.dto.PostResponse;
import com.velora.backend.recommendation.service.RecommendationService;
import com.velora.backend.users.dto.UserResponse;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/recommendations")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class RecommendationController {

    private final RecommendationService recommendationService;

    @GetMapping("/users")
    public ApiResponse<List<UserResponse>> recommendUsers(
            Principal principal
    ) {
        return ApiResponse.ok(
                "Usuarios recomendados",
                recommendationService.recommendUsers(principal.getName())
        );
    }

    @GetMapping("/posts")
    public ApiResponse<List<PostResponse>> recommendPosts() {
        return ApiResponse.ok(
                "Publicaciones recomendadas",
                recommendationService.recommendPosts()
        );
    }
}