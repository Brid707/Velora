package com.velora.backend.auth.dto;

import com.velora.backend.users.entity.UserEntity;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AuthResponse {

    private Boolean success;
    private String token;
    private UserEntity user;
}