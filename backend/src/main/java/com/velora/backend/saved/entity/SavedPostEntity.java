package com.velora.backend.saved.entity;

import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.users.entity.UserEntity;

import jakarta.persistence.*;

import lombok.*;

@Entity
@Table(name = "saved_posts")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SavedPostEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id")
    private PostEntity post;
}