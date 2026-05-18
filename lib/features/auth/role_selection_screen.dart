import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:provider/provider.dart';
import 'package:local_lead/core/providers/user_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 48 : 24,
                isTablet ? 64 : 48,
                isTablet ? 48 : 24,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Row(
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
                  SizedBox(height: isTablet ? 48 : 32),
                  // Welcome text
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 32 : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose how you'd like to continue",
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 18 : 16,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 24,
                ),
                child: Column(
                  children: [
                    SizedBox(height: isTablet ? 48 : 32),

                    // Traveller Card
                    _RoleCard(
                      icon: FontAwesomeIcons.person,
                      title: 'Continue as Traveler',
                      description:
                      'Find and book local guides for your next adventure',
                      iconBgColor: AppColors.accent.withAlpha(25),
                      isTablet: isTablet,
                      onTap: () {
                        context.read<UserProvider>().setRole(UserRole.traveller);
                        context.go('/explore');
                      },
                    ),
                    SizedBox(height: isTablet ? 24 : 16),

                    // Guide Card
                    _RoleCard(
                      icon: FontAwesomeIcons.briefcase,
                      title: 'Continue as Guide',
                      description:
                      'Share your expertise and earn by guiding travelers',
                      iconBgColor: AppColors.secondary,
                      isTablet: isTablet,
                      onTap: () {
                        context.read<UserProvider>().setRole(UserRole.guide);
                        context.go('/guide-bookings');
                      },
                    ),

                    // Divider
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 32 : 24,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 16 : 14,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                        ],
                      ),
                    ),

                    // Google Button
                    _SocialButton(
                      label: 'Continue with Google',
                      isTablet: isTablet,
                      onTap: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),

                    // Facebook Button
                    _SocialButton(
                      label: 'Continue with Facebook',
                      isTablet: isTablet,
                      onTap: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        size: 20,
                        color: Color(0xFF1877F2),
                      ),
                    ),
                    SizedBox(height: isTablet ? 32 : 24),

                    // Footer
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 12,
                          color: AppColors.mutedForeground,
                        ),
                        children: const [
                          TextSpan(
                              text: "By continuing, you agree to LocalLead's "),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(color: AppColors.accent),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: AppColors.accent),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 48 : 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Role Card Widget
class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconBgColor;
  final bool isTablet;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconBgColor,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: isTablet ? 64 : 56,
              height: isTablet ? 64 : 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: AppColors.accent,
                  size: isTablet ? 28 : 24,
                ),
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 15 : 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: isTablet ? 18 : 14,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

// Social Button Widget
class _SocialButton extends StatelessWidget {
  final String label;
  final bool isTablet;
  final VoidCallback onTap;
  final Widget icon;

  const _SocialButton({
    required this.label,
    required this.isTablet,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 56 : 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}