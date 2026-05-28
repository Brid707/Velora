package com.velora.backend.comments.controller;

import com.velora.backend.comments.dto.CommentResponse;
import com.velora.backend.comments.dto.CreateCommentRequest;

import com.velora.backend.comments.service.CommentService;

import com.velora.backend.common.response.ApiResponse;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import java.security.Principal;

import java.util.List;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/{postId}")
    public ApiResponse<CommentResponse>
    createComment(
            @PathVariable String postId,

            @RequestBody
            CreateCommentRequest request,

            Principal principal
    ) {

        return ApiResponse.ok(
                "Comentario creado",
                commentService.createComment(
                        principal.getName(),
                        postId,
                        request
                )
        );
    }

    @GetMapping("/{postId}")
    public ApiResponse<List<CommentResponse>>
    getComments(
            @PathVariable String postId
    ) {

        return ApiResponse.ok(
                "Comentarios obtenidos",
                commentService.getComments(postId)
        );
    }
}