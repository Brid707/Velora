package com.velora.backend.saved.controller;

import com.velora.backend.posts.dto.PostResponse;
import java.util.List;
import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.saved.service.SavedPostService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/saved")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class SavedPostController {

    private final SavedPostService savedPostService;

    @PostMapping("/{postId}")
    public ApiResponse<String> toggleSave(
            @PathVariable String postId,
            Principal principal
    ) {

        savedPostService.toggleSave(
                principal.getName(),
                postId
        );

        return ApiResponse.ok(
                "Guardado actualizado",
                "OK"
        );
    }
    @GetMapping
    public ApiResponse<List<PostResponse>> getSavedPosts(
        Principal principal
) {
    return ApiResponse.ok(
            "Guardados obtenidos",
            savedPostService.getSavedPosts(principal.getName())
    );}
}