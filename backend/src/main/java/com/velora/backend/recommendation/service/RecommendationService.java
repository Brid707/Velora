package com.velora.backend.recommendation.service;

import com.velora.backend.posts.dto.PostResponse;
import com.velora.backend.posts.service.PostService;
import com.velora.backend.users.dto.UserResponse;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RecommendationService {

    private final UserRepository userRepository;
    private final PostService postService;

    public List<UserResponse> recommendUsers(
            String userEmail
    ) {
        UserEntity me = userRepository
                .findByEmail(userEmail)
                .orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );

        return userRepository.findAll()
                .stream()
                .filter(user -> !user.getId().equals(me.getId()))
                .limit(10)
                .map(UserResponse::fromEntity)
                .toList();
    }

    public List<PostResponse> recommendPosts() {
        return postService.getFeed(null);
    }
}