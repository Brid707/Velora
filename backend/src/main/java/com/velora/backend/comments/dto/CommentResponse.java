package com.velora.backend.comments.dto;

import com.velora.backend.comments.entity.CommentEntity;

import com.velora.backend.users.dto.UserResponse;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class CommentResponse {

    private String id;
    private UserResponse user;
    private String content;
    private LocalDateTime createdAt;

    public static CommentResponse fromEntity(
            CommentEntity comment
    ) {

        return CommentResponse.builder()
                .id(comment.getId())
                .user(
                        UserResponse.fromEntity(
                                comment.getUser()
                        )
                )
                .content(comment.getContent())
                .createdAt(comment.getCreatedAt())
                .build();
    }
}
