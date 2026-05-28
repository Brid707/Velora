package com.velora.backend.likes.repository;

import com.velora.backend.likes.entity.LikeEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LikeRepository
        extends JpaRepository<LikeEntity, String> {

    Optional<LikeEntity> findByUserIdAndPostId(
            String userId,
            String postId
    );
}