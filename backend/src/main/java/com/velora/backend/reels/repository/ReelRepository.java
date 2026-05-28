package com.velora.backend.reels.repository;

import com.velora.backend.reels.entity.ReelEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReelRepository extends JpaRepository<ReelEntity, String> {
    List<ReelEntity> findAllByOrderByCreatedAtDesc();
}