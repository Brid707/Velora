package com.velora.backend.reposts.repository;

import com.velora.backend.reposts.entity.RepostEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RepostRepository extends JpaRepository<RepostEntity, String> {

    Optional<RepostEntity> findByUserIdAndPostId(
            String userId,
            String postId
    );

    List<RepostEntity> findAllByOrderByCreatedAtDesc();

    List<RepostEntity> findByUserIdOrderByCreatedAtDesc(
            String userId
    );
}