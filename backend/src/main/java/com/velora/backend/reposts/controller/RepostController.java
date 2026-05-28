package com.velora.backend.reposts.controller;

import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.reposts.dto.CreateRepostRequest;
import com.velora.backend.reposts.service.RepostService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/reposts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class RepostController {

    private final RepostService repostService;

    @PostMapping("/{postId}")
    public ApiResponse<String> repost(
            @PathVariable String postId,
            @RequestBody CreateRepostRequest request,
            Principal principal
    ) {
        repostService.toggleRepost(
                principal.getName(),
                postId,
                request
        );

        return ApiResponse.ok("Repost actualizado", "OK");
    }
}