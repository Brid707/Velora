package com.velora.backend.posts.service;

import com.velora.backend.likes.repository.LikeRepository;
import com.velora.backend.posts.dto.CreatePostRequest;
import com.velora.backend.posts.dto.PostResponse;
import com.velora.backend.posts.entity.PostEntity;
import com.velora.backend.posts.repository.PostRepository;
import com.velora.backend.reposts.entity.RepostEntity;
import com.velora.backend.reposts.repository.RepostRepository;
import com.velora.backend.saved.repository.SavedPostRepository;
import com.velora.backend.users.dto.UserResponse;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final LikeRepository likeRepository;
    private final SavedPostRepository savedPostRepository;
    private final RepostRepository repostRepository;

    public PostResponse createPost(CreatePostRequest request) {
        UserEntity user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        String mediaUrl = request.getMediaUrl() != null
                ? request.getMediaUrl()
                : request.getImageUrl();

        PostEntity post = PostEntity.builder()
                .caption(request.getCaption())
                .mediaUrl(mediaUrl)
                .user(user)
                .build();

        PostEntity saved = postRepository.save(post);

        user.setPostsCount(
                postRepository.findByUserIdOrderByCreatedAtDesc(user.getId()).size()
        );

        userRepository.save(user);

        return buildPostResponse(saved, user);
    }

    public List<PostResponse> getFeed(String userEmail) {
        UserEntity me = null;

        if (userEmail != null) {
            me = userRepository.findByEmail(userEmail).orElse(null);
        }

        List<PostResponse> feed = new ArrayList<>();

        for (PostEntity post : postRepository.findAllByOrderByCreatedAtDesc()) {
            feed.add(buildPostResponse(post, me));
        }

        for (RepostEntity repost : repostRepository.findAllByOrderByCreatedAtDesc()) {
            PostEntity originalPost = repost.getPost();

            feed.add(
                    PostResponse.repostFromEntity(
                            originalPost,
                            repost.getComment(),
                            UserResponse.fromEntity(repost.getUser()),
                            me != null && likeRepository
                                    .findByUserIdAndPostId(me.getId(), originalPost.getId())
                                    .isPresent(),
                            me != null && savedPostRepository
                                    .findByUserIdAndPostId(me.getId(), originalPost.getId())
                                    .isPresent(),
                            me != null && repostRepository
                                    .findByUserIdAndPostId(me.getId(), originalPost.getId())
                                    .isPresent(),
                            repost.getCreatedAt()
                    )
            );
        }

        return feed.stream()
                .sorted(Comparator.comparing(PostResponse::getCreatedAt).reversed())
                .toList();
    }

    public List<PostResponse> getUserPosts(String userId) {
        List<PostResponse> result = new ArrayList<>();

        for (PostEntity post : postRepository.findByUserIdOrderByCreatedAtDesc(userId)) {
            result.add(PostResponse.fromEntity(post));
        }

        for (RepostEntity repost : repostRepository.findByUserIdOrderByCreatedAtDesc(userId)) {
            result.add(
                    PostResponse.repostFromEntity(
                            repost.getPost(),
                            repost.getComment(),
                            UserResponse.fromEntity(repost.getUser()),
                            false,
                            false,
                            true,
                            repost.getCreatedAt()
                    )
            );
        }

        return result.stream()
                .sorted(Comparator.comparing(PostResponse::getCreatedAt).reversed())
                .toList();
    }

    private PostResponse buildPostResponse(PostEntity post, UserEntity me) {
        if (me == null) {
            return PostResponse.fromEntity(post);
        }

        return PostResponse.fromEntity(
                post,
                likeRepository.findByUserIdAndPostId(me.getId(), post.getId()).isPresent(),
                savedPostRepository.findByUserIdAndPostId(me.getId(), post.getId()).isPresent(),
                repostRepository.findByUserIdAndPostId(me.getId(), post.getId()).isPresent()
        );
    }
}