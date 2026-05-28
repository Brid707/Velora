package com.velora.backend.saved.repository;

import com.velora.backend.saved.entity.SavedPostEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SavedPostRepository
        extends JpaRepository<SavedPostEntity, String> {

    Optional<SavedPostEntity> findByUserIdAndPostId(
            String userId,
            String postId
    );

    List<SavedPostEntity> findByUserId(
            String userId
    );
}