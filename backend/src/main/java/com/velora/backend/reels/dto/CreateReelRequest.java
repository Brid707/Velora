package com.velora.backend.reels.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateReelRequest {
    private String userId;
    private String videoUrl;
    private String caption;
}