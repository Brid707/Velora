package com.velora.backend.cloudinary.service;

import com.cloudinary.Cloudinary;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CloudinaryService {

    private final Cloudinary cloudinary;

    public Map uploadFile(
            MultipartFile file,
            String folder
    ) {

        try {

            Map<String, Object> options =
                    new HashMap<>();

            options.put("folder", folder);

            return cloudinary.uploader().upload(
                    file.getBytes(),
                    options
            );

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error al subir archivo a Cloudinary"
            );
        }
    }
}