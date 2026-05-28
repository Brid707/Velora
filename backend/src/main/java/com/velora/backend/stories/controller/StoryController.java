package com.velora.backend.stories.controller;

import com.velora.backend.common.response.ApiResponse;

import com.velora.backend.stories.dto.CreateStoryRequest;
import com.velora.backend.stories.dto.StoryResponse;

import com.velora.backend.stories.service.StoryService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stories")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class StoryController {

    private final StoryService storyService;

    @PostMapping
    public ApiResponse<StoryResponse> createStory(
            @RequestBody CreateStoryRequest request
    ) {

        return ApiResponse.ok(
                "Historia creada",
                storyService.createStory(request)
        );
    }

    @GetMapping("/feed")
    public ApiResponse<List<StoryResponse>>
    getStoriesFeed() {

        return ApiResponse.ok(
                "Historias obtenidas",
                storyService.getFeedStories()
        );
    }
}