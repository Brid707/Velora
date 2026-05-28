package com.velora.backend.comments.service;

import com.velora.backend.comments.dto.CommentResponse;
import com.velora.backend.comments.dto.CreateCommentRequest;
import com.velora.backend.comments.entity.CommentEntity;
import com.velora.backend.comments.repository.CommentRepository;
import com.velora.backend.notifications.service.NotificationService;
import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.posts.repository.PostRepository;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final PostRepository postRepository;
    private final NotificationService notificationService;

    public CommentResponse createComment(
            String userEmail,
            String postId,
            CreateCommentRequest request
    ) {
        UserEntity user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        PostEntity post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post no encontrado"));

        CommentEntity comment = CommentEntity.builder()
                .content(request.getContent())
                .user(user)
                .post(post)
                .build();

        CommentEntity savedComment = commentRepository.save(comment);

        post.setCommentsCount(
                commentRepository.findByPostIdOrderByCreatedAtDesc(postId).size()
        );
        postRepository.save(post);

        if (!post.getUser().getId().equals(user.getId())) {
            notificationService.createNotification(
                    post.getUser(),
                    "COMMENT",
                    user.getUsername() + " comentó tu publicación",
                    user.getUsername(),
                    user.getProfileImageUrl(),
                    post.getId()
            );
        }

        return CommentResponse.fromEntity(savedComment);
    }

    public List<CommentResponse> getComments(String postId) {
        return commentRepository
                .findByPostIdOrderByCreatedAtDesc(postId)
                .stream()
                .map(CommentResponse::fromEntity)
                .toList();
    }
}