package com.velora.backend.likes.service;

import com.velora.backend.likes.entity.LikeEntity;
import com.velora.backend.likes.repository.LikeRepository;

import com.velora.backend.notifications.service.NotificationService;

import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.posts.repository.PostRepository;

import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LikeService {

    private final LikeRepository likeRepository;

    private final PostRepository postRepository;

    private final UserRepository userRepository;

    private final NotificationService notificationService;

    public void toggleLike(
            String userEmail,
            String postId
    ) {

        UserEntity user =
                userRepository.findByEmail(
                        userEmail
                ).orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );

        PostEntity post =
                postRepository.findById(
                        postId
                ).orElseThrow(
                        () -> new RuntimeException(
                                "Post no encontrado"
                        )
                );

        var existingLike =
                likeRepository.findByUserIdAndPostId(
                        user.getId(),
                        postId
                );

        if (existingLike.isPresent()) {

            likeRepository.delete(
                    existingLike.get()
            );

            post.setLikesCount(
                    Math.max(
                            0,
                            post.getLikesCount() - 1
                    )
            );

        } else {

            LikeEntity like =
                    LikeEntity.builder()
                            .user(user)
                            .post(post)
                            .build();

            likeRepository.save(like);

            post.setLikesCount(
                    post.getLikesCount() + 1
            );

            if (!post.getUser().getId().equals(user.getId())) {

                notificationService.createNotification(
                        post.getUser(),
                        "LIKE",
                        user.getUsername() + " le dio like a tu publicación",
                        user.getUsername(),
                        user.getProfileImageUrl(),
                        post.getId()
                );
            }
        }

        postRepository.save(post);
    }
}