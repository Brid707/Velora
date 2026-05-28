import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/session_service.dart';

class CreateContentScreen extends StatefulWidget {
  final int initialTab;

  const CreateContentScreen({super.key, this.initialTab = 0});

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController captionController = TextEditingController();

  XFile? selectedFile;

  late int selectedTab;

  bool uploading = false;

  final List<String> tabs = ['Publicación', 'Historia', 'Reel'];

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  Future<void> pickImageCamera() async {
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  Future<void> pickImageGallery() async {
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  Future<void> pickVideoCamera() async {
    final file = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );

    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  Future<void> pickVideoGallery() async {
    final file = await picker.pickVideo(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  Future<void> uploadContent() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona un archivo')));
      return;
    }

    final userId = await SessionService.getUserId();

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sesión no válida')));
      return;
    }

    try {
      setState(() {
        uploading = true;
      });

      final folder = selectedTab == 0
          ? 'velora/posts'
          : selectedTab == 1
          ? 'velora/stories'
          : 'velora/reels';

      final uploadResponse = kIsWeb
          ? await ApiService.postMultipartBytes(
              'cloudinary/upload',
              await selectedFile!.readAsBytes(),
              selectedFile!.name,
              'file',
              fields: {'folder': folder},
            )
          : await ApiService.postMultipart(
              'cloudinary/upload',
              selectedFile!.path,
              'file',
              fields: {'folder': folder},
            );

      final data = uploadResponse['data'];

      final mediaUrl = data['secure_url'] ?? data['secureUrl'] ?? data['url'];

      if (mediaUrl == null || mediaUrl.toString().isEmpty) {
        throw Exception('Cloudinary no devolvió URL del archivo');
      }

      if (selectedTab == 0) {
        await ApiService.post('posts', {
          'userId': userId,
          'mediaUrl': mediaUrl,
          'imageUrl': mediaUrl,
          'caption': captionController.text.trim(),
        });
      } else if (selectedTab == 1) {
        await ApiService.post('stories', {
          'userId': userId,
          'mediaUrl': mediaUrl,
          'mediaType': 'image',
        });
      } else {
        await ApiService.post('reels', {
          'userId': userId,
          'videoUrl': mediaUrl,
          'caption': captionController.text.trim(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${tabs[selectedTab]} creado correctamente')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al subir: $e')));
    } finally {
      if (mounted) {
        setState(() {
          uploading = false;
        });
      }
    }
  }

  Widget buildPreview() {
    if (selectedFile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedTab == 2
                  ? Icons.videocam_outlined
                  : Icons.camera_alt_outlined,
              color: Colors.white,
              size: 72,
            ),
            const SizedBox(height: 12),
            Text(
              selectedTab == 0
                  ? 'Selecciona una publicación'
                  : selectedTab == 1
                  ? 'Selecciona una historia'
                  : 'Selecciona un reel',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (selectedTab == 2) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 90),
        ),
      );
    }

    if (kIsWeb) {
      return Image.network(
        selectedFile!.path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Image.file(
      File(selectedFile!.path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Future<void> openCamera() async {
    if (selectedTab == 2) {
      await pickVideoCamera();
    } else {
      await pickImageCamera();
    }
  }

  Future<void> openGallery() async {
    if (selectedTab == 2) {
      await pickVideoGallery();
    } else {
      await pickImageGallery();
    }
  }

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
      selectedFile = null;
      captionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = tabs[selectedTab];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: uploading
              ? null
              : () {
                  Navigator.pop(context, false);
                },
          icon: const Icon(Icons.close),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: uploading ? null : uploadContent,
            child: uploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Siguiente',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black, child: buildPreview()),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: Column(
                    children: [
                      _FloatingMediaButton(
                        icon: Icons.camera_alt_outlined,
                        onTap: openCamera,
                      ),
                      const SizedBox(height: 12),
                      _FloatingMediaButton(
                        icon: Icons.photo_library_outlined,
                        onTap: openGallery,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.soySauce,
            child: Column(
              children: [
                if (selectedTab != 1)
                  TextField(
                    controller: captionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Escribe una descripción...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (selectedTab == 1)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Las historias desaparecerán después de 24 horas.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: uploading ? null : openCamera,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Cámara'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: uploading ? null : openGallery,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Galería'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            height: 74,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (index) {
                final selected = selectedTab == index;

                return GestureDetector(
                  onTap: uploading
                      ? null
                      : () {
                          changeTab(index);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingMediaButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingMediaButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
