package com.velora.backend.likes.controller;

import com.velora.backend.common.response.ApiResponse;

import com.velora.backend.likes.service.LikeService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/likes")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class LikeController {

    private final LikeService likeService;

    @PostMapping("/{postId}")
    public ApiResponse<String> toggleLike(
            @PathVariable String postId,
            Principal principal
    ) {

        likeService.toggleLike(
                principal.getName(),
                postId
        );

        return ApiResponse.ok(
                "Like actualizado",
                "OK"
        );
    }
}