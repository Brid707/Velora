package com.velora.backend.reels.entity;

import com.velora.backend.users.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "reels")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReelEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String videoUrl;

    @Column(length = 700)
    private String caption;

    @Builder.Default
    private Integer likesCount = 0;

    @Builder.Default
    private Integer commentsCount = 0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
