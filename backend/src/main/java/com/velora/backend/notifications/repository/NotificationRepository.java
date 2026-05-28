package com.velora.backend.notifications.repository;

import com.velora.backend.notifications.entity.NotificationEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository
        extends JpaRepository<NotificationEntity, String> {

    List<NotificationEntity>
    findByReceiverIdOrderByCreatedAtDesc(
            String receiverId
    );
}