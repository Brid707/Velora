package com.velora.backend.messages.dto;

import com.velora.backend.messages.entity.MessageEntity;

import com.velora.backend.users.dto.UserResponse;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class MessageResponse {

    private String id;

    private UserResponse sender;

    private UserResponse receiver;

    private String content;

    private LocalDateTime createdAt;

    public static MessageResponse fromEntity(
            MessageEntity message
    ) {

        return MessageResponse.builder()
                .id(message.getId())
                .sender(
                        UserResponse.fromEntity(
                                message.getSender()
                        )
                )
                .receiver(
                        UserResponse.fromEntity(
                                message.getReceiver()
                        )
                )
                .content(message.getContent())
                .createdAt(message.getCreatedAt())
                .build();
    }
}