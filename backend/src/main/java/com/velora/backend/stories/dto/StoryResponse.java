package com.velora.backend.stories.dto;

import com.velora.backend.stories.entity.StoryEntity;
import com.velora.backend.users.dto.UserResponse;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class StoryResponse {

    private String id;
    private UserResponse user;
    private String mediaUrl;
    private String mediaType;
    private Boolean viewed;
    private LocalDateTime createdAt;

    public static StoryResponse fromEntity(
            StoryEntity story
    ) {

        return StoryResponse.builder()
                .id(story.getId())
                .user(
                        UserResponse.fromEntity(
                                story.getUser()
                        )
                )
                .mediaUrl(story.getMediaUrl())
                .mediaType(story.getMediaType())
                .viewed(false)
                .createdAt(story.getCreatedAt())
                .build();
    }
}
