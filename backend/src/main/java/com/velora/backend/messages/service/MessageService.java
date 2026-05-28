package com.velora.backend.messages.service;

import com.velora.backend.messages.dto.CreateMessageRequest;
import com.velora.backend.messages.dto.MessageResponse;
import com.velora.backend.messages.entity.MessageEntity;
import com.velora.backend.messages.repository.MessageRepository;
import com.velora.backend.users.dto.UserResponse;
import com.velora.backend.users.entity.UserEntity;
import com.velora.backend.users.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    public MessageResponse sendMessage(
            String senderEmail,
            CreateMessageRequest request
    ) {
        UserEntity sender = userRepository.findByEmail(senderEmail)
                .orElseThrow(() -> new RuntimeException("Sender no encontrado"));

        UserEntity receiver = userRepository.findById(request.getReceiverId())
                .orElseThrow(() -> new RuntimeException("Receiver no encontrado"));

        MessageEntity message = MessageEntity.builder()
                .sender(sender)
                .receiver(receiver)
                .content(request.getContent())
                .build();

        return MessageResponse.fromEntity(messageRepository.save(message));
    }

    public List<MessageResponse> getConversation(
            String userEmail,
            String otherUserId
    ) {
        UserEntity me = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        return messageRepository
                .getConversation(me.getId(), otherUserId)
                .stream()
                .map(MessageResponse::fromEntity)
                .toList();
    }

    public List<UserResponse> getConversations(String userEmail) {
        UserEntity me = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        List<MessageEntity> messages =
                messageRepository.findBySenderIdOrReceiverIdOrderByCreatedAtDesc(
                        me.getId(),
                        me.getId()
                );

        List<UserResponse> users = new ArrayList<>();
        List<String> addedIds = new ArrayList<>();

        for (MessageEntity message : messages) {
            UserEntity otherUser = message.getSender().getId().equals(me.getId())
                    ? message.getReceiver()
                    : message.getSender();

            if (!addedIds.contains(otherUser.getId())) {
                addedIds.add(otherUser.getId());
                users.add(UserResponse.fromEntity(otherUser));
            }
        }

        return users;
    }
}