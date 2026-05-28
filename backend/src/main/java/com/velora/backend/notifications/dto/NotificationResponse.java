package com.velora.backend.notifications.dto;

import com.velora.backend.notifications.entity.NotificationEntity;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class NotificationResponse {

    private String id;

    private String type;

    private String message;

    private Boolean read;

    private String senderUsername;

    private String senderProfileImage;

    private String postId;

    private LocalDateTime createdAt;

    public static NotificationResponse fromEntity(
            NotificationEntity notification
    ) {

        return NotificationResponse.builder()
                .id(notification.getId())
                .type(notification.getType())
                .message(notification.getMessage())
                .read(notification.getRead())
                .senderUsername(
                        notification.getSenderUsername()
                )
                .senderProfileImage(
                        notification.getSenderProfileImage()
                )
                .postId(notification.getPostId())
                .createdAt(notification.getCreatedAt())
                .build();
    }
}