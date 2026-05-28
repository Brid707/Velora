package com.velora.backend.reposts.service;

import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.posts.repository.PostRepository;

import com.velora.backend.reposts.dto.CreateRepostRequest;
import com.velora.backend.reposts.entity.RepostEntity;
import com.velora.backend.reposts.repository.RepostRepository;

import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RepostService {

    private final RepostRepository repostRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    public void toggleRepost(
            String userEmail,
            String postId,
            CreateRepostRequest request
    ) {
        UserEntity user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        PostEntity post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post no encontrado"));

        var existing = repostRepository.findByUserIdAndPostId(
                user.getId(),
                postId
        );

        if (existing.isPresent()) {
            repostRepository.delete(existing.get());
            post.setRepostsCount(Math.max(0, post.getRepostsCount() - 1));
        } else {
            RepostEntity repost = RepostEntity.builder()
                    .user(user)
                    .post(post)
                    .comment(request.getComment())
                    .build();

            repostRepository.save(repost);
            post.setRepostsCount(post.getRepostsCount() + 1);
        }

        postRepository.save(post);
    }
}