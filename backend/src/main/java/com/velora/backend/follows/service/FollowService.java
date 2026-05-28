package com.velora.backend.follows.service;

import com.velora.backend.follows.entity.FollowEntity;
import com.velora.backend.follows.repository.FollowRepository;
import com.velora.backend.notifications.service.NotificationService;
import com.velora.backend.users.dto.UserResponse;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public void toggleFollow(
            String followerEmail,
            String followingId
    ) {
        UserEntity follower = userRepository.findByEmail(followerEmail)
                .orElseThrow(() -> new RuntimeException("Usuario follower no encontrado"));

        UserEntity following = userRepository.findById(followingId)
                .orElseThrow(() -> new RuntimeException("Usuario following no encontrado"));

        if (follower.getId().equals(followingId)) {
            throw new RuntimeException("No puedes seguirte a ti mismo");
        }

        var existing = followRepository.findByFollowerIdAndFollowingId(
                follower.getId(),
                followingId
        );

        if (existing.isPresent()) {
            followRepository.delete(existing.get());

            following.setFollowersCount(
                    Math.max(0, followRepository.findByFollowingId(following.getId()).size())
            );

            follower.setFollowingCount(
                    Math.max(0, followRepository.findByFollowerId(follower.getId()).size())
            );
        } else {
            FollowEntity follow = FollowEntity.builder()
                    .follower(follower)
                    .following(following)
                    .build();

            followRepository.save(follow);

            following.setFollowersCount(
                    followRepository.findByFollowingId(following.getId()).size()
            );

            follower.setFollowingCount(
                    followRepository.findByFollowerId(follower.getId()).size()
            );

            notificationService.createNotification(
                    following,
                    "FOLLOW",
                    follower.getUsername() + " comenzó a seguirte",
                    follower.getUsername(),
                    follower.getProfileImageUrl(),
                    null
            );
        }

        userRepository.save(follower);
        userRepository.save(following);
    }

    public List<UserResponse> getFollowers(String userId) {
        return followRepository.findByFollowingId(userId)
                .stream()
                .map(follow -> UserResponse.fromEntity(follow.getFollower()))
                .toList();
    }

    public List<UserResponse> getFollowing(String userId) {
        return followRepository.findByFollowerId(userId)
                .stream()
                .map(follow -> UserResponse.fromEntity(follow.getFollowing()))
                .toList();
    }
}