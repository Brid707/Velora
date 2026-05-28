package com.velora.backend.stories.service;

import com.velora.backend.stories.dto.CreateStoryRequest;
import com.velora.backend.stories.dto.StoryResponse;
import com.velora.backend.stories.entity.StoryEntity;
import com.velora.backend.stories.repository.StoryRepository;

import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StoryService {

    private final StoryRepository storyRepository;
    private final UserRepository userRepository;

    public StoryResponse createStory(
            CreateStoryRequest request
    ) {

        UserEntity user =
                userRepository.findById(
                        request.getUserId()
                ).orElseThrow(
                        () -> new RuntimeException(
                                "Usuario no encontrado"
                        )
                );

        StoryEntity story = StoryEntity.builder()
                .mediaUrl(request.getMediaUrl())
                .mediaType(request.getMediaType())
                .user(user)
                .build();

        return StoryResponse.fromEntity(
                storyRepository.save(story)
        );
    }

    public List<StoryResponse> getFeedStories() {

        return storyRepository
                .findByExpiresAtAfterOrderByCreatedAtDesc(
                        LocalDateTime.now()
                )
                .stream()
                .map(StoryResponse::fromEntity)
                .toList();
    }
}