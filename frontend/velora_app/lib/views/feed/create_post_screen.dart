import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/api_service.dart';
import '../../core/services/session_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController captionController = TextEditingController();

  XFile? selectedFile;
  bool uploading = false;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  Future<void> pickFromCamera() async {
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() => selectedFile = file);
    }
  }

  Future<void> pickFromGallery() async {
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() => selectedFile = file);
    }
  }

  Future<void> uploadPost() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una imagen')));
      return;
    }

    final userId = await SessionService.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sesión no válida')));
      return;
    }

    try {
      setState(() => uploading = true);

      final uploadResponse = await ApiService.postMultipart(
        'cloudinary/upload',
        selectedFile!.path,
        'file',
        fields: {'folder': 'velora/posts'},
      );

      final mediaUrl = uploadResponse['data']['secureUrl'];

      await ApiService.post('posts', {
        'userId': userId,
        'mediaUrl': mediaUrl,
        'imageUrl': mediaUrl,
        'caption': captionController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Publicación creada')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al publicar: $e')));
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva publicación'),
        actions: [
          TextButton(
            onPressed: uploading ? null : uploadPost,
            child: uploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Publicar',
                    style: AppTextStyles.bodyBold(color: AppColors.accent),
                  ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppGradients.darkBackgroundGradient
              : AppGradients.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            children: [
              GestureDetector(
                onTap: pickFromGallery,
                child: Container(
                  height: 360,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: selectedFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 56,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Selecciona una imagen',
                              style: AppTextStyles.bodyBold(
                                color: isDark
                                    ? AppColors.textDark
                                    : AppColors.textLight,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          child: Image.file(
                            File(selectedFile!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickFromCamera,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Cámara'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickFromGallery,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Galería'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: captionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escribe una descripción...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
