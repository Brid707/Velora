package com.velora.backend.messages.repository;

import com.velora.backend.messages.entity.MessageEntity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MessageRepository extends JpaRepository<MessageEntity, String> {

    @Query("""
        SELECT m
        FROM MessageEntity m
        WHERE
            (m.sender.id = :userA AND m.receiver.id = :userB)
            OR
            (m.sender.id = :userB AND m.receiver.id = :userA)
        ORDER BY m.createdAt DESC
    """)
    List<MessageEntity> getConversation(
            @Param("userA") String userA,
            @Param("userB") String userB
    );

    List<MessageEntity> findBySenderIdOrReceiverIdOrderByCreatedAtDesc(
            String senderId,
            String receiverId
    );
}