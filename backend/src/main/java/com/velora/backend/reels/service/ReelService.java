package com.velora.backend.reels.service;

import com.velora.backend.reels.dto.CreateReelRequest;
import com.velora.backend.reels.dto.ReelResponse;
import com.velora.backend.reels.entity.ReelEntity;
import com.velora.backend.reels.repository.ReelRepository;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReelService {

    private final ReelRepository reelRepository;
    private final UserRepository userRepository;

    public ReelResponse createReel(CreateReelRequest request) {
        UserEntity user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        ReelEntity reel = ReelEntity.builder()
                .videoUrl(request.getVideoUrl())
                .caption(request.getCaption())
                .user(user)
                .build();

        return ReelResponse.fromEntity(reelRepository.save(reel));
    }

    public List<ReelResponse> getReels() {
        return reelRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(ReelResponse::fromEntity)
                .toList();
    }

    public ReelResponse toggleLike(String reelId) {
        ReelEntity reel = reelRepository.findById(reelId)
                .orElseThrow(() -> new RuntimeException("Reel no encontrado"));

        reel.setLikesCount(reel.getLikesCount() + 1);

        return ReelResponse.fromEntity(reelRepository.save(reel));
    }
}