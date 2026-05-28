package com.velora.backend.saved.service;

import com.velora.backend.posts.dto.PostResponse;
import java.util.List;
import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.posts.repository.PostRepository;

import com.velora.backend.saved.entity.SavedPostEntity;
import com.velora.backend.saved.repository.SavedPostRepository;

import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SavedPostService {

    private final SavedPostRepository savedPostRepository;

    private final PostRepository postRepository;

    private final UserRepository userRepository;

    public void toggleSave(
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

        var existing =
                savedPostRepository
                        .findByUserIdAndPostId(
                                user.getId(),
                                postId
                        );

        if (existing.isPresent()) {

            savedPostRepository.delete(
                    existing.get()
            );

            post.setSavedCount(
                    Math.max(
                            0,
                            post.getSavedCount() - 1
                    )
            );

        } else {

            SavedPostEntity saved =
                    SavedPostEntity.builder()
                            .user(user)
                            .post(post)
                            .build();

            savedPostRepository.save(saved);

            post.setSavedCount(
                    post.getSavedCount() + 1
            );
        }

        postRepository.save(post);
    }

    public List<PostResponse> getSavedPosts(String userEmail) {
    UserEntity user = userRepository.findByEmail(userEmail)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

    return savedPostRepository.findByUserId(user.getId())
            .stream()
            .map(saved -> PostResponse.fromEntity(saved.getPost()))
            .toList();
        }
}