package com.velora.backend.posts.dto;

import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.users.dto.UserResponse;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class PostResponse {

    private String id;
    private UserResponse user;
    private String mediaUrl;
    private String caption;

    private Integer likesCount;
    private Integer commentsCount;
    private Integer repostsCount;
    private Integer savedCount;

    private Boolean likedByMe;
    private Boolean savedByMe;
    private Boolean repostedByMe;

    private Boolean repost;
    private String repostComment;
    private UserResponse repostedBy;

    private LocalDateTime createdAt;

    public static PostResponse fromEntity(PostEntity post) {
        return fromEntity(post, false, false, false);
    }

    public static PostResponse fromEntity(
            PostEntity post,
            Boolean likedByMe,
            Boolean savedByMe,
            Boolean repostedByMe
    ) {
        return PostResponse.builder()
                .id(post.getId())
                .user(UserResponse.fromEntity(post.getUser()))
                .mediaUrl(post.getMediaUrl())
                .caption(post.getCaption())
                .likesCount(post.getLikesCount())
                .commentsCount(post.getCommentsCount())
                .repostsCount(post.getRepostsCount())
                .savedCount(post.getSavedCount())
                .likedByMe(likedByMe)
                .savedByMe(savedByMe)
                .repostedByMe(repostedByMe)
                .repost(false)
                .repostComment(null)
                .repostedBy(null)
                .createdAt(post.getCreatedAt())
                .build();
    }

    public static PostResponse repostFromEntity(
            PostEntity post,
            String repostComment,
            UserResponse repostedBy,
            Boolean likedByMe,
            Boolean savedByMe,
            Boolean repostedByMe,
            LocalDateTime repostedAt
    ) {
        return PostResponse.builder()
                .id(post.getId())
                .user(UserResponse.fromEntity(post.getUser()))
                .mediaUrl(post.getMediaUrl())
                .caption(post.getCaption())
                .likesCount(post.getLikesCount())
                .commentsCount(post.getCommentsCount())
                .repostsCount(post.getRepostsCount())
                .savedCount(post.getSavedCount())
                .likedByMe(likedByMe)
                .savedByMe(savedByMe)
                .repostedByMe(repostedByMe)
                .repost(true)
                .repostComment(repostComment)
                .repostedBy(repostedBy)
                .createdAt(repostedAt)
                .build();
    }
}