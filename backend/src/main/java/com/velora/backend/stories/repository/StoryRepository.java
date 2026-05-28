package com.velora.backend.stories.repository;

import com.velora.backend.stories.entity.StoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface StoryRepository
        extends JpaRepository<StoryEntity, String> {

    List<StoryEntity>
    findByExpiresAtAfterOrderByCreatedAtDesc(
            LocalDateTime now
    );
}