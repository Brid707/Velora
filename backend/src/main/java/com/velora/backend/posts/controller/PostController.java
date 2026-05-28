package com.velora.backend.posts.controller;

import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.posts.dto.CreatePostRequest;
import com.velora.backend.posts.dto.PostResponse;
import com.velora.backend.posts.service.PostService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PostController {

    private final PostService postService;

    @PostMapping
    public ApiResponse<PostResponse> createPost(
            @RequestBody CreatePostRequest request
    ) {
        return ApiResponse.ok(
                "Publicación creada",
                postService.createPost(request)
        );
    }

    @GetMapping("/feed")
    public ApiResponse<List<PostResponse>> getFeed(
            Principal principal
    ) {
        String email = principal != null
                ? principal.getName()
                : null;

        return ApiResponse.ok(
                "Feed obtenido",
                postService.getFeed(email)
        );
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<PostResponse>> getUserPosts(
            @PathVariable String userId
    ) {
        return ApiResponse.ok(
                "Publicaciones del usuario obtenidas",
                postService.getUserPosts(userId)
        );
    }
}