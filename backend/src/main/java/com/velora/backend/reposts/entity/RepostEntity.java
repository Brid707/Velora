package com.velora.backend.reposts.entity;

import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.users.entity.UserEntity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "reposts")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RepostEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(length = 500)
    private String comment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id")
    private PostEntity post;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}