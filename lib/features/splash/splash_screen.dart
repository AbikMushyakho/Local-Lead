import 'package:flutter/material.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/core/utils/helpers.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 48 : 24,
                isTablet ? 64 : 48,
                isTablet ? 48 : 24,
                isTablet ? 32 : 24,
              ),
              child: Row(
                children: [
                  Container(
                    width: isTablet ? 56 : 40,
                    height: isTablet ? 56 : 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.accentForeground,
                      size: isTablet ? 32 : 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LocalLead',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 32 : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Hero section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isTablet ? 48 : 24),

                    // Title
                    Text(
                      'Discover Your City with Local Guides',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 40 : 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),

                    // Subtitle
                    Text(
                      'Connect with verified local experts for authentic, personalized experiences',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    SizedBox(height: isTablet ? 56 : 40),

                    // Features
                    _FeatureItem(
                      icon: Icons.shield,
                      title: 'Verified Guides',
                      description:
                      'All guides are background-checked and certified',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: isTablet ? 32 : 24),
                    _FeatureItem(
                      icon: Icons.star,
                      title: 'Top Rated',
                      description: 'Browse reviews from real travelers',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: isTablet ? 32 : 24),
                    _FeatureItem(
                      icon: Icons.location_on,
                      title: 'Local Experts',
                      description: 'Discover hidden gems only locals know',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: isTablet ? 56 : 40),
                  ],
                ),
              ),
            ),

            // CTA Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 48 : 24,
                0,
                isTablet ? 48 : 24,
                isTablet ? 48 : 32,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 64 : 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.accentForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 20 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 14 : 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isTablet;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isTablet ? 64 : 48,
          height: isTablet ? 64 : 48,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.accent,
            size: isTablet ? 32 : 24,
          ),
        ),
        SizedBox(width: isTablet ? 20 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 20 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: isTablet ? 6 : 4),
              Text(
                description,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 16 : 13,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}