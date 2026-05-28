package com.velora.backend.posts.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreatePostRequest {

    private String userId;
    private String mediaUrl;
    private String imageUrl;
    private String caption;
}