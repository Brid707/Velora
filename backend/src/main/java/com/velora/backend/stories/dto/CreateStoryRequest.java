package com.velora.backend.stories.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateStoryRequest {

    private String userId;
    private String mediaUrl;
    private String mediaType;
}