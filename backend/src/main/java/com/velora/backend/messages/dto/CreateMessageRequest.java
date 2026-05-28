package com.velora.backend.messages.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateMessageRequest {

    private String receiverId;
    private String content;
}