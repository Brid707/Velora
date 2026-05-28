package com.velora.backend.follows.controller;

import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.follows.service.FollowService;
import com.velora.backend.users.dto.UserResponse;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/follows")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FollowController {

    private final FollowService followService;

    @PostMapping("/{userId}")
    public ApiResponse<String> toggleFollow(
            @PathVariable String userId,
            Principal principal
    ) {
        followService.toggleFollow(
                principal.getName(),
                userId
        );

        return ApiResponse.ok(
                "Follow actualizado",
                "OK"
        );
    }

    @GetMapping("/{userId}/followers")
    public ApiResponse<List<UserResponse>> getFollowers(
            @PathVariable String userId
    ) {
        return ApiResponse.ok(
                "Seguidores obtenidos",
                followService.getFollowers(userId)
        );
    }

    @GetMapping("/{userId}/following")
    public ApiResponse<List<UserResponse>> getFollowing(
            @PathVariable String userId
    ) {
        return ApiResponse.ok(
                "Seguidos obtenidos",
                followService.getFollowing(userId)
        );
    }
}