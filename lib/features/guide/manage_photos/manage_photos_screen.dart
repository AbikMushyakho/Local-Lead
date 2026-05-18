import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/guides_data.dart';

class ManagePhotosScreen extends StatefulWidget {
  const ManagePhotosScreen({super.key});

  @override
  State<ManagePhotosScreen> createState() => _ManagePhotosScreenState();
}

class _ManagePhotosScreenState extends State<ManagePhotosScreen> {
  String _activeTab = 'gallery';

  // Start with guide's existing photos from data
  List<String> _galleryPhotos = List.from(guides.first.gallery);
  List<String> _tourPhotos = List.from(guides.first.tourPhotos);

  List<String> get _displayedPhotos =>
      _activeTab == 'gallery' ? _galleryPhotos : _tourPhotos;

  final ImagePicker _picker = ImagePicker();

  Future<void> _addPhoto(String type) async {
    // Show source selection dialog
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Photo Source',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Gallery option
            GestureDetector(
              onTap: () => Navigator.pop(context, ImageSource.gallery),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.images,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Choose from Gallery',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Camera option
            GestureDetector(
              onTap: () => Navigator.pop(context, ImageSource.camera),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.camera,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Take a Photo',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      if (source == ImageSource.gallery) {
        // Multiple selection from gallery
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 85,
        );
        if (images.isEmpty) return;

        setState(() {
          for (final image in images) {
            if (type == 'gallery') {
              _galleryPhotos.add(image.path);
            } else {
              _tourPhotos.add(image.path);
            }
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${images.length} photo${images.length > 1 ? 's' : ''} added successfully!',
              ),
            ),
          );
        }
      } else {
        // Single photo from camera
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (image == null) return;

        setState(() {
          if (type == 'gallery') {
            _galleryPhotos.add(image.path);
          } else {
            _tourPhotos.add(image.path);
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo added successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access photos. Please check permissions.'),
          ),
        );
      }
    }
  }
  void _deletePhoto(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Photo',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this photo?',
          style: TextStyle(
            fontFamily: AppFonts.family,
            color: AppColors.mutedForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.family,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (_activeTab == 'gallery') {
                  _galleryPhotos.remove(url);
                } else {
                  _tourPhotos.remove(url);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photo deleted')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: AppFonts.family,
                color: AppColors.destructive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.card,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Manage Photos',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 22 : 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                20,
                isTablet ? 32 : 20,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border:
                      Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photo Guidelines',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3A5F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...[
                          'Use high-quality, well-lit photos',
                          'Gallery: Showcase locations, food, culture or landmarks',
                          'Tour Memories: Share real photos from past tours',
                          'Keep photos professional and relevant to your tours',
                        ].map(
                              (tip) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    color: Color(0xFF1E3A5F),
                                    fontSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize: isTablet ? 13 : 12,
                                      color: const Color(0xFF1E3A5F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            icon: FontAwesomeIcons.images,
                            label: 'Photo Gallery',
                            count: _galleryPhotos.length,
                            isActive: _activeTab == 'gallery',
                            onTap: () => setState(
                                    () => _activeTab = 'gallery'),
                            isTablet: isTablet,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _TabButton(
                            icon: FontAwesomeIcons.camera,
                            label: 'Tour Memories',
                            count: _tourPhotos.length,
                            isActive: _activeTab == 'tour',
                            onTap: () =>
                                setState(() => _activeTab = 'tour'),
                            isTablet: isTablet,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section header with add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _activeTab == 'gallery'
                                ? 'Your Gallery Photos'
                                : 'Tour Memories',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 16 : 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            _activeTab == 'gallery'
                                ? 'Showcase your experiences you offer'
                                : 'Share highlights from your past tours',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 13 : 12,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _addPhoto(_activeTab),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.plus,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Add Photos',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 14 : 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Photos grid or empty state
                  _displayedPhotos.isEmpty
                      ? _EmptyState(
                    isGallery: _activeTab == 'gallery',
                    isTablet: isTablet,
                    onAdd: () => _addPhoto(_activeTab),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 4 : 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _displayedPhotos.length,
                    itemBuilder: (context, index) {
                      final url = _displayedPhotos[index];
                      return _PhotoTile(
                        url: url,
                        onDelete: () => _deletePhoto(url),
                        isTablet: isTablet,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Quick tips
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(120),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Tips',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...[
                          'Photos help travelers visualize their experience',
                          'Include a mix of locations, activities and group shots',
                          'Update regularly to keep your profile fresh',
                          'Tour photos with happy travelers build trust',
                        ].map(
                              (tip) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize: isTablet ? 12 : 11,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tab Button Widget
class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  final bool isTablet;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: isActive
                  ? AppColors.accent
                  : AppColors.mutedForeground,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 13 : 12,
                fontWeight: isActive
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isActive
                    ? AppColors.primary
                    : AppColors.mutedForeground,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accent.withAlpha(20)
                    : AppColors.border,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 12 : 11,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AppColors.accent
                      : AppColors.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String url;
  final VoidCallback onDelete;
  final bool isTablet;

  const _PhotoTile({
    required this.url,
    required this.onDelete,
    required this.isTablet,
  });

  bool get _isLocalFile => url.startsWith('/') || url.startsWith('file://');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Photo — local file or network
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _isLocalFile
              ? Image.file(
            File(url),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _errorPlaceholder(),
          )
              : Image.network(
            url,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _errorPlaceholder(),
          ),
        ),

        // Delete button
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.destructive,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.image,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}
// Empty State Widget
class _EmptyState extends StatelessWidget {
  final bool isGallery;
  final bool isTablet;
  final VoidCallback onAdd;

  const _EmptyState({
    required this.isGallery,
    required this.isTablet,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          FaIcon(
            isGallery
                ? FontAwesomeIcons.images
                : FontAwesomeIcons.camera,
            size: isTablet ? 56 : 48,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),
          Text(
            isGallery
                ? 'No gallery photos yet'
                : 'No tour photos yet',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 16 : 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isGallery
                ? 'Upload photos to showcase your tours and specialties'
                : 'Upload photos from your previous tours to show travelers what to expect',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 13 : 12,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.upload,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isGallery
                        ? 'Upload Your First Photos'
                        : 'Upload Tour Photos',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 14 : 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}