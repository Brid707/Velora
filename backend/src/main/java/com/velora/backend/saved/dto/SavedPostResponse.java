package com.velora.backend.saved.dto;

import com.velora.backend.posts.dto.PostResponse;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class SavedPostResponse {
    private List<PostResponse> posts;
}