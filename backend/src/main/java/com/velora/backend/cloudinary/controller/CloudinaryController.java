package com.velora.backend.cloudinary.controller;

import com.velora.backend.cloudinary.service.CloudinaryService;

import com.velora.backend.common.response.ApiResponse;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/cloudinary")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CloudinaryController {

    private final CloudinaryService cloudinaryService;

    @PostMapping("/upload")
    public ApiResponse<Map> uploadFile(
            @RequestParam("file")
            MultipartFile file,

            @RequestParam(
                    value = "folder",
                    required = false,
                    defaultValue = "velora"
            )
            String folder
    ) {

        return ApiResponse.ok(
                "Archivo subido correctamente",
                cloudinaryService.uploadFile(
                        file,
                        folder
                )
        );
    }
}