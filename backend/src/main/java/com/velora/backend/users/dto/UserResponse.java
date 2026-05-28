package com.velora.backend.users.dto;

import com.velora.backend.users.entity.UserEntity;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserResponse {

    private String id;
    private String fullName;
    private String username;
    private String email;
    private String bio;
    private String profileImageUrl;
    private Integer followersCount;
    private Integer followingCount;
    private Integer postsCount;

    public static UserResponse fromEntity(UserEntity user) {
        return UserResponse.builder()
                .id(user.getId())
                .fullName(user.getFullName())
                .username(user.getUsername())
                .email(user.getEmail())
                .bio(user.getBio())
                .profileImageUrl(user.getProfileImageUrl())
                .followersCount(user.getFollowersCount())
                .followingCount(user.getFollowingCount())
                .postsCount(user.getPostsCount())
                .build();
    }
}