package com.velora.backend.notifications.controller;

import com.velora.backend.common.response.ApiResponse;

import com.velora.backend.notifications.dto.NotificationResponse;

import com.velora.backend.notifications.service.NotificationService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public ApiResponse<List<NotificationResponse>>
    getNotifications(
            Principal principal
    ) {

        return ApiResponse.ok(
                "Notificaciones obtenidas",
                notificationService.getNotifications(
                        principal.getName()
                )
        );
    }
}