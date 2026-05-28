package com.velora.backend.notifications.entity;

import com.velora.backend.users.entity.UserEntity;

import jakarta.persistence.*;

import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String type;

    @Column(length = 500)
    private String message;

    @Builder.Default
    private Boolean read = false;

    private String senderUsername;

    private String senderProfileImage;

    private String postId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id")
    private UserEntity receiver;

    @Builder.Default
    private LocalDateTime createdAt =
            LocalDateTime.now();
}