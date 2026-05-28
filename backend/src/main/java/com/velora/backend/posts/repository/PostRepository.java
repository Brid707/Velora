package com.velora.backend.posts.repository;

import com.velora.backend.posts.entity.PostEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PostRepository extends JpaRepository<PostEntity, String> {

    List<PostEntity> findAllByOrderByCreatedAtDesc();

    List<PostEntity> findByUserIdOrderByCreatedAtDesc(
            String userId
    );
}