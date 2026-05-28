package com.velora.backend.reels.controller;

import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.reels.dto.CreateReelRequest;
import com.velora.backend.reels.dto.ReelResponse;
import com.velora.backend.reels.service.ReelService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reels")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ReelController {

    private final ReelService reelService;

    @PostMapping
    public ApiResponse<ReelResponse> createReel(@RequestBody CreateReelRequest request) {
        return ApiResponse.ok("Reel creado", reelService.createReel(request));
    }

    @GetMapping
    public ApiResponse<List<ReelResponse>> getReels() {
        return ApiResponse.ok("Reels obtenidos", reelService.getReels());
    }

    @PostMapping("/{reelId}/like")
    public ApiResponse<ReelResponse> likeReel(@PathVariable String reelId) {
        return ApiResponse.ok("Like actualizado", reelService.toggleLike(reelId));
    }
}