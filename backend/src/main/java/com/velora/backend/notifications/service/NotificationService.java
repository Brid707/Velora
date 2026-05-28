package com.velora.backend.notifications.service;

import com.velora.backend.notifications.dto.NotificationResponse;

import com.velora.backend.notifications.entity.NotificationEntity;
import com.velora.backend.notifications.repository.NotificationRepository;

import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    private final UserRepository userRepository;

    public void createNotification(
            UserEntity receiver,
            String type,
            String message,
            String senderUsername,
            String senderProfileImage,
            String postId
    ) {

        NotificationEntity notification =
                NotificationEntity.builder()
                        .receiver(receiver)
                        .type(type)
                        .message(message)
                        .senderUsername(senderUsername)
                        .senderProfileImage(senderProfileImage)
                        .postId(postId)
                        .build();

        notificationRepository.save(notification);
    }

    public List<NotificationResponse>
    getNotifications(
            String userEmail
    ) {

        UserEntity user =
                userRepository.findByEmail(
                        userEmail
                ).orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );

        return notificationRepository
                .findByReceiverIdOrderByCreatedAtDesc(
                        user.getId()
                )
                .stream()
                .map(NotificationResponse::fromEntity)
                .toList();
    }
}