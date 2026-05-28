package com.velora.backend.follows.repository;

import com.velora.backend.follows.entity.FollowEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FollowRepository
        extends JpaRepository<FollowEntity, String> {

    Optional<FollowEntity> findByFollowerIdAndFollowingId(
            String followerId,
            String followingId
    );

    List<FollowEntity> findByFollowerId(
            String followerId
    );

    List<FollowEntity> findByFollowingId(
            String followingId
    );
}