package com.velora.backend.users.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.velora.backend.users.entity.UserEntity;

public interface UserRepository
        extends JpaRepository<UserEntity, String> {

    Optional<UserEntity> findByEmail(
            String email
    );

    Optional<UserEntity> findByUsername(
            String username
    );

    List<UserEntity> findByUsernameContainingIgnoreCase(
            String username
    );
}