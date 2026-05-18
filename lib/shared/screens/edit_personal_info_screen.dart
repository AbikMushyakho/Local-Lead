import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/core/providers/user_provider.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() =>
      _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final _firstNameController = TextEditingController(text: 'Alex');
  final _lastNameController = TextEditingController(text: 'Thompson');
  final _bioController = TextEditingController();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final isGuide = context.read<UserProvider>().isGuide;
    if (isGuide) {
      _firstNameController.text = 'Maria';
      _lastNameController.text = 'Santos';
      _bioController.text =
      'Born and raised in this beautiful city, I\'ve spent the last 8 years sharing my passion for local cuisine and hidden cultural gems with travelers from around the world.';
    }
    _firstNameController.addListener(_onChanged);
    _lastNameController.addListener(_onChanged);
    _bioController.addListener(_onChanged);
  }

  void _onChanged() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personal information saved!')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isGuide = context.watch<UserProvider>().isGuide;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          'Personal Information',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _hasChanges ? _save : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _hasChanges
                              ? AppColors.accent
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: _hasChanges
                                ? AppColors.accentForeground
                                : AppColors.mutedForeground,
                          ),
                        ),
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
                24,
                isTablet ? 32 : 20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo upload
                  _PhotoCard(isTablet: isTablet),
                  const SizedBox(height: 20),

                  // Name fields
                  _FormCard(
                    isTablet: isTablet,
                    children: [
                      _FormField(
                        label: 'First Name',
                        controller: _firstNameController,
                        hint: 'Enter your first name',
                        isTablet: isTablet,
                      ),
                      const SizedBox(height: 16),
                      _FormField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        hint: 'Enter your last name',
                        isTablet: isTablet,
                      ),
                    ],
                  ),

                  // Bio for guides only
                  if (isGuide) ...[
                    const SizedBox(height: 20),
                    _FormCard(
                      isTablet: isTablet,
                      children: [
                        _FormField(
                          label: 'Bio',
                          controller: _bioController,
                          hint: 'Tell travelers about yourself...',
                          isTablet: isTablet,
                          maxLines: 5,
                          maxLength: 500,
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_bioController.text.length} / 500 characters',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 13 : 12,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Photo Card Widget
class _PhotoCard extends StatelessWidget {
  final bool isTablet;

  const _PhotoCard({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: isTablet ? 120 : 100,
                height: isTablet ? 120 : 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.border,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.secondary,
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          color: AppColors.mutedForeground,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo upload coming soon!'),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.camera,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Click the camera icon to update your profile photo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// Form Card Widget
class _FormCard extends StatelessWidget {
  final List<Widget> children;
  final bool isTablet;

  const _FormCard({required this.children, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// Form Field Widget
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isTablet;
  final int maxLines;
  final int? maxLength;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.isTablet,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 14 : 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 15 : 14,
            color: AppColors.primary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 15 : 14,
              color: AppColors.mutedForeground,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}