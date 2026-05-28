package com.velora.backend.reels.dto;

import com.velora.backend.reels.entity.ReelEntity;
import com.velora.backend.users.dto.UserResponse;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class ReelResponse {
    private String id;
    private UserResponse user;
    private String videoUrl;
    private String caption;
    private Integer likesCount;
    private Integer commentsCount;
    private Boolean likedByMe;
    private LocalDateTime createdAt;

    public static ReelResponse fromEntity(ReelEntity reel) {
        return ReelResponse.builder()
                .id(reel.getId())
                .user(UserResponse.fromEntity(reel.getUser()))
                .videoUrl(reel.getVideoUrl())
                .caption(reel.getCaption())
                .likesCount(reel.getLikesCount())
                .commentsCount(reel.getCommentsCount())
                .likedByMe(false)
                .createdAt(reel.getCreatedAt())
                .build();
    }
}