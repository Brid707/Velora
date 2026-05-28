package com.velora.backend.messages.controller;

import com.velora.backend.common.response.ApiResponse;
import com.velora.backend.messages.dto.CreateMessageRequest;
import com.velora.backend.messages.dto.MessageResponse;
import com.velora.backend.messages.service.MessageService;
import com.velora.backend.users.dto.UserResponse;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/messages")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class MessageController {

    private final MessageService messageService;

    @PostMapping
    public ApiResponse<MessageResponse> sendMessage(
            @RequestBody CreateMessageRequest request,
            Principal principal
    ) {
        return ApiResponse.ok(
                "Mensaje enviado",
                messageService.sendMessage(principal.getName(), request)
        );
    }

    @GetMapping
    public ApiResponse<List<UserResponse>> getConversations(
            Principal principal
    ) {
        return ApiResponse.ok(
                "Conversaciones obtenidas",
                messageService.getConversations(principal.getName())
        );
    }

    @GetMapping("/{userId}")
    public ApiResponse<List<MessageResponse>> getMessages(
            @PathVariable String userId,
            Principal principal
    ) {
        return ApiResponse.ok(
                "Mensajes obtenidos",
                messageService.getConversation(principal.getName(), userId)
        );
    }
}