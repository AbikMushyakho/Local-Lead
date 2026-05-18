import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/core/providers/user_provider.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final isGuide = context.read<UserProvider>().isGuide;
    _emailController = TextEditingController(
      text: isGuide ? 'maria.santos@email.com' : 'alex.thompson@email.com',
    );
    _phoneController = TextEditingController(
      text: isGuide ? '+1 (555) 987-6543' : '+1 (555) 123-4567',
    );
    _locationController = TextEditingController(
      text: isGuide ? 'Barcelona, Spain' : 'San Francisco, CA',
    );
    _emailController.addListener(_onChanged);
    _phoneController.addListener(_onChanged);
    _locationController.addListener(_onChanged);
  }

  void _onChanged() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact information saved!')),
    );
    context.pop();
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
                          'Contact Information',
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
                children: [
                  // Form card
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _ContactField(
                          label: 'Email Address',
                          controller: _emailController,
                          hint: 'Enter your email',
                          icon: FontAwesomeIcons.envelope,
                          keyboardType: TextInputType.emailAddress,
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 16),
                        _ContactField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          hint: 'Enter your phone number',
                          icon: FontAwesomeIcons.phone,
                          keyboardType: TextInputType.phone,
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 16),
                        _ContactField(
                          label: 'Location',
                          controller: _locationController,
                          hint: 'Enter your location',
                          icon: FontAwesomeIcons.locationDot,
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleInfo,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                color: const Color(0xFF1E3A5F),
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Note: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  'Your email and phone number will be used for account verification and booking notifications. We\'ll never share your information with third parties.',
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

// Contact Field Widget
class _ContactField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool isTablet;

  const _ContactField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    required this.isTablet,
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
          keyboardType: keyboardType,
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
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical:14),
              child: FaIcon(
                icon,
                size: 16,
                color: AppColors.mutedForeground,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
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
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}