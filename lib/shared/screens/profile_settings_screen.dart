import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:provider/provider.dart';
import 'package:local_lead/core/providers/user_provider.dart';


class ProfileSettingsScreen extends StatefulWidget {

  const ProfileSettingsScreen({
    super.key,
  });

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _marketingEmails = false;

  bool get _isGuide => context.read<UserProvider>().isGuide;

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
                      'Settings',
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

          // Scrollable content
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
                  // Account section
                  _SectionLabel(label: 'ACCOUNT', isTablet: isTablet),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.user,
                        label: 'Personal Information',
                        sublabel: _isGuide
                            ? 'Update your name, photo, and bio'
                            : 'Update your name and photo',
                        onTap: () => context.push('/edit-personal-info'),
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _SettingsItem(
                        icon: FontAwesomeIcons.envelope,
                        label: 'Contact Information',
                        sublabel: 'Email, phone number, and location',
                        onTap: () => context.push('/edit-contact'),
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _SettingsItem(
                        icon: FontAwesomeIcons.lock,
                        label: 'Change Password',
                        sublabel: 'Update your password',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Professional section (guide only)
                  if (_isGuide) ...[
                    _SectionLabel(
                        label: 'PROFESSIONAL', isTablet: isTablet),
                    _SettingsCard(
                      children: [
                        _SettingsItem(
                          icon: FontAwesomeIcons.briefcase,
                          label: 'Professional Information',
                          sublabel:
                          'Pricing, services, languages, certifications',
                          onTap: () => context.push('/edit-professional-info'),
                          isTablet: isTablet,
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: FontAwesomeIcons.calendarDays,
                          label: 'Availability',
                          sublabel: 'Set your available hours',
                          onTap: () => context.push('/edit-availability'),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Notifications section
                  _SectionLabel(
                      label: 'NOTIFICATIONS', isTablet: isTablet),
                  _SettingsCard(
                    children: [
                      _ToggleItem(
                        icon: FontAwesomeIcons.bell,
                        label: 'Push Notifications',
                        sublabel: 'Get notified about bookings',
                        value: _pushNotifications,
                        onChanged: (val) =>
                            setState(() => _pushNotifications = val),
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _ToggleItem(
                        icon: FontAwesomeIcons.envelope,
                        label: 'Email Notifications',
                        sublabel: 'Receive updates via email',
                        value: _emailNotifications,
                        onChanged: (val) =>
                            setState(() => _emailNotifications = val),
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _ToggleItem(
                        icon: FontAwesomeIcons.mobileScreen,
                        label: 'SMS Notifications',
                        sublabel: 'Get text messages for bookings',
                        value: _smsNotifications,
                        onChanged: (val) =>
                            setState(() => _smsNotifications = val),
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _ToggleItem(
                        icon: FontAwesomeIcons.bullhorn,
                        label: 'Marketing Emails',
                        sublabel: 'Offers and recommendations',
                        value: _marketingEmails,
                        onChanged: (val) =>
                            setState(() => _marketingEmails = val),
                        isTablet: isTablet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Payment section
                  _SectionLabel(label: 'PAYMENT', isTablet: isTablet),
                  _SettingsCard(
                    children: [

                      if (_isGuide) ...[
                        _Divider(),
                        _SettingsItem(
                          icon: FontAwesomeIcons.dollarSign,
                          label: 'Payout Settings',
                          sublabel: 'Bank account and payout schedule',
                          onTap: () => context.push('/payout-settings'),
                          isTablet: isTablet,
                        ),
                      ] else ...[
                        _SettingsItem(
                          icon: FontAwesomeIcons.creditCard,
                          label: 'Payment Methods',
                          sublabel: 'Manage cards and payment options',
                          onTap: () => context.push('/payment-methods'),
                          isTablet: isTablet,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Preferences section
                  _SectionLabel(
                      label: 'PREFERENCES', isTablet: isTablet),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.globe,
                        label: 'Language',
                        sublabel: 'English',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _SettingsItem(
                        icon: FontAwesomeIcons.dollarSign,
                        label: 'Currency',
                        sublabel: 'USD (\$)',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Support & Legal section
                  _SectionLabel(
                      label: 'SUPPORT & LEGAL', isTablet: isTablet),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.circleQuestion,
                        label: 'Help Center',
                        sublabel: 'FAQs and support',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _SettingsItem(
                        icon: FontAwesomeIcons.fileLines,
                        label: 'Terms of Service',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _SettingsItem(
                        icon: FontAwesomeIcons.fileLines,
                        label: 'Privacy Policy',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                      _Divider(),
                      _SettingsItem(
                        icon: FontAwesomeIcons.shieldHalved,
                        label: 'Safety & Trust',
                        sublabel: 'Report issues and safety tips',
                        onTap: () {},
                        isTablet: isTablet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Account Actions section
                  _SectionLabel(
                      label: 'ACCOUNT ACTIONS', isTablet: isTablet),
                  _SettingsCard(
                    children: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.triangleExclamation,
                        label: 'Delete Account',
                        onTap: () => _showDeleteDialog(context),
                        isTablet: isTablet,
                        labelColor: AppColors.destructive,
                        iconColor: AppColors.destructive,
                        showChevron: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
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
              context.go('/splash');
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
}

// Section Label Widget
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isTablet;

  const _SectionLabel({required this.label, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: isTablet ? 13 : 12,
          fontWeight: FontWeight.w600,
          color: AppColors.mutedForeground,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// Settings Card Widget
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// Settings Item Widget
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sublabel;
  final VoidCallback onTap;
  final bool isTablet;
  final Color? labelColor;
  final Color? iconColor;
  final bool showChevron;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.onTap,
    required this.isTablet,
    this.labelColor,
    this.iconColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 16 : 14,
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: isTablet ? 18 : 16,
              color: iconColor ?? AppColors.accent,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 15 : 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor ?? AppColors.primary,
                    ),
                  ),
                  if (sublabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sublabel!,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 13 : 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              const FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 13,
                color: AppColors.mutedForeground,
              ),
          ],
        ),
      ),
    );
  }
}

// Toggle Item Widget
class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isTablet;

  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.onChanged,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: isTablet ? 14 : 12,
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: isTablet ? 18 : 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 15 : 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 13 : 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

// Divider Widget
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}