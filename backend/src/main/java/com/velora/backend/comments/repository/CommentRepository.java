package com.velora.backend.comments.repository;

import com.velora.backend.comments.entity.CommentEntity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository
        extends JpaRepository<CommentEntity, String> {

    List<CommentEntity>
    findByPostIdOrderByCreatedAtDesc(
            String postId
    );
}
