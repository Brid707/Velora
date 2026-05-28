package com.velora.backend.users.dto;

import com.velora.backend.posts.dto.PostResponse;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class ProfileResponse {

    private UserResponse user;

    private List<PostResponse> posts;
}