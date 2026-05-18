import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/user_data.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:local_lead/core/providers/user_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
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
              context.read<UserProvider>().logout();
              context.go('/splash');
            },
            child: const Text(
              'Log Out',
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
    final userProvider = context.watch<UserProvider>();
    final isGuide = userProvider.isGuide;
    final User user = isGuide ? currentGuide : currentUser;
    final Guide? guide = isGuide ? currentGuide : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header image / cover
                _HeaderCover(user: user, isGuide: isGuide),
                SizedBox(height: isTablet ? 64 : 56),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isTablet ? 32 : 24,
                    isTablet ? 16 : 12,
                    isTablet ? 32 : 24,
                    100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Profile info header
                      _ProfileInfoHeader(
                        user: user,
                        guide: guide,
                        isGuide: isGuide,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: isTablet ? 20 : 16),

                      // Guide stats
                      if (isGuide && guide != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                value: guide.totalTours.toString(),
                                label: 'Tours',
                                isTablet: isTablet,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                value: guide.reviewCount.toString(),
                                label: 'Reviews',
                                isTablet: isTablet,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                value: guide.rating.toString(),
                                label: 'Rating',
                                isTablet: isTablet,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                      ],

                      // About
                      if (user.bio != null) ...[
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle(
                                title: 'About',
                                isTablet: isTablet,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.bio!,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 15 : 13,
                                  color: AppColors.mutedForeground,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                      ],

                      // Contact Information
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _SectionTitle(
                                  title: 'Contact Information',
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _ContactRow(
                              icon: FontAwesomeIcons.envelope,
                              value: user.email,
                              isTablet: isTablet,
                            ),
                            const SizedBox(height: 10),
                            _ContactRow(
                              icon: FontAwesomeIcons.phone,
                              value: user.phone,
                              isTablet: isTablet,
                            ),
                            const SizedBox(height: 10),
                            _ContactRow(
                              icon: FontAwesomeIcons.locationDot,
                              value: user.location,
                              isTablet: isTablet,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),

                      // Guide professional details
                      if (isGuide && guide != null) ...[

                        // Languages
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.language,
                                    size: 18,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 8),
                                  _SectionTitle(
                                    title: 'Languages',
                                    isTablet: isTablet,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: guide.languages
                                    .map((lang) => _Badge(label: lang))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),

                        // Certifications
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.award,
                                    size: 18,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 8),
                                  _SectionTitle(
                                    title: 'Certifications',
                                    isTablet: isTablet,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...guide.certifications.map((cert) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: AppColors.accent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cert,
                                        style: TextStyle(
                                          fontFamily: AppFonts.family,
                                          fontSize: isTablet ? 14 : 13,
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
                        SizedBox(height: isTablet ? 16 : 12),

                        // Availability & Pricing
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.clock,
                                    size: 18,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 8),
                                  _SectionTitle(
                                    title: 'Availability & Pricing',
                                    isTablet: isTablet,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hourly Rate',
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize: isTablet ? 15 : 13,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '\$${guide.hourlyRate.toInt()}',
                                          style: TextStyle(
                                            fontFamily: AppFonts.family,
                                            fontSize: isTablet ? 22 : 20,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '/hour',
                                          style: TextStyle(
                                            fontFamily: AppFonts.family,
                                            fontSize: isTablet ? 13 : 12,
                                            color: AppColors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: AppColors.border),
                              const SizedBox(height: 12),
                              Text(
                                'Weekly Schedule',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 14 : 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...[
                                'monday',
                                'tuesday',
                                'wednesday',
                                'thursday',
                                'friday',
                                'saturday',
                                'sunday'
                              ].map((day) {
                                final slots =
                                    guide.weeklyAvailability[day] ?? [];
                                final isAvailable = slots.isNotEmpty;
                                final dayLabel =
                                    day[0].toUpperCase() + day.substring(1);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: isTablet ? 100 : 88,
                                        child: Text(
                                          dayLabel,
                                          style: TextStyle(
                                            fontFamily: AppFonts.family,
                                            fontSize: isTablet ? 14 : 13,
                                            fontWeight: FontWeight.w500,
                                            color: isAvailable
                                                ? AppColors.primary
                                                : AppColors.mutedForeground,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: isAvailable
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: slots.map((slot) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.accent
                                                            .withAlpha(15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                          color: AppColors.accent
                                                              .withAlpha(60),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        slot.formatted,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppFonts.family,
                                                          fontSize:
                                                              isTablet ? 13 : 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors.accent,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              )
                                            : Text(
                                                'Unavailable',
                                                style: TextStyle(
                                                  fontFamily: AppFonts.family,
                                                  fontSize: isTablet ? 13 : 12,
                                                  color: AppColors.border,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        // Photo Gallery
                        if (guide.gallery.isNotEmpty) ...[
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.images,
                                      size: 18,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(width: 8),
                                    _SectionTitle(
                                      title: 'Photo Gallery',
                                      isTablet: isTablet,
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        '${guide.gallery.length} photos',
                                        style: TextStyle(
                                          fontFamily: AppFonts.family,
                                          fontSize: isTablet ? 13 : 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _PhotoGallery(
                                  photos: guide.gallery,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 16 : 12),
                        ],

                        // Tour Memories
                        if (guide.tourPhotos.isNotEmpty) ...[
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.camera,
                                      size: 18,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(width: 8),
                                    _SectionTitle(
                                      title: 'Tour Memories',
                                      isTablet: isTablet,
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        '${guide.tourPhotos.length} photos',
                                        style: TextStyle(
                                          fontFamily: AppFonts.family,
                                          fontSize: isTablet ? 13 : 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Highlights from your previous tours',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 13 : 12,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _PhotoGallery(
                                  photos: guide.tourPhotos,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 16 : 12),
                        ],

                      ],

                      // Quick Actions
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(
                              title: 'Quick Actions',
                              isTablet: isTablet,
                            ),
                            const SizedBox(height: 8),
                            _ActionItem(
                              icon: FontAwesomeIcons.message,
                              label: 'Messages',
                              onTap: () => isGuide
                                  ? context.go('/guide-messages')
                                  : context.go('/messages'),
                              isTablet: isTablet,
                            ),
                            if (!isGuide) ...[
                              const Divider(
                                  color: AppColors.border, height: 1),
                              _ActionItem(
                                icon: FontAwesomeIcons.calendarCheck,
                                label: 'My Bookings',
                                onTap: () => context.go('/my-bookings'),
                                isTablet: isTablet,
                              ),
                            ],
                            if (isGuide) ...[
                              const Divider(
                                  color: AppColors.border, height: 1),
                              _ActionItem(
                                icon: FontAwesomeIcons.solidStar,
                                label: 'My Reviews',
                                onTap: () => context.push('/my-reviews'),
                                isTablet: isTablet,
                              ),
                              const Divider(
                                  color: AppColors.border, height: 1),
                              _ActionItem(
                                icon: FontAwesomeIcons.images,
                                label: 'Manage Photos',
                                onTap: () => context.push('/manage-photos'),
                                isTablet: isTablet,
                              ),
                            ],
                            const Divider(color: AppColors.border, height: 1),
                            _ActionItem(
                              icon: FontAwesomeIcons.gear,
                              label: 'Settings',
                              onTap: () => context.push('/profile-settings'),
                              isTablet: isTablet,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),

                      // Logout button
                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.rightFromBracket,
                                size: 16,
                                color: AppColors.destructive,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 16 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.destructive,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Settings button overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: isTablet ? 32 : 20,
            child: GestureDetector(
              onTap: () => context.push('/profile-settings'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.gear,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCover extends StatelessWidget {
  final User user;
  final bool isGuide;

  const _HeaderCover({required this.user, required this.isGuide});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover gradient
        Container(
          height: isTablet ? 160 : 130,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accent, Color(0xFFD4623A)],
            ),
          ),
        ),

        // Avatar overlapping bottom
        Positioned(
          bottom: -(isTablet ? 56.0 : 48.0),
          left: isTablet ? 32 : 20,
          child: Stack(
            children: [
              Container(
                width: isTablet ? 112 : 96,
                height: isTablet ? 112 : 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 4,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    user.photo,
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
              // Verified badge
              if (user.verified)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.shieldHalved,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Profile Info Header Widget
class _ProfileInfoHeader extends StatelessWidget {
  final User user;
  final Guide? guide;
  final bool isGuide;
  final bool isTablet;

  const _ProfileInfoHeader({
    required this.user,
    required this.guide,
    required this.isGuide,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + verified badge
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      if (user.verified) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.shieldHalved,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isGuide
                        ? '${guide!.specialty} Specialist'
                        : 'Traveller',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 15 : 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            // Rating badge for guide
            if (isGuide && guide != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.solidStar,
                      size: 14,
                      color: Color(0xFFFBBF24),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      guide!.rating.toString(),
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 15 : 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Stats row
        Row(
          children: [
            _StatChip(
              icon: FontAwesomeIcons.locationDot,
              label: user.location,
              isTablet: isTablet,
            ),
            SizedBox(width: isTablet ? 20 : 16),
            _StatChip(
              icon: FontAwesomeIcons.calendarDays,
              label: 'Since ${user.memberSince}',
              isTablet: isTablet,
            ),
            if (isGuide && guide != null) ...[
              SizedBox(width: isTablet ? 20 : 16),
              _StatChip(
                icon: FontAwesomeIcons.briefcase,
                label: guide!.experience,
                isTablet: isTablet,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// Stat Chip Widget
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isTablet;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: isTablet ? 14 : 12,
          color: AppColors.mutedForeground,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 14 : 12,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isTablet;

  const _StatCard({
    required this.value,
    required this.label,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 13 : 12,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// Section Card Widget
class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// Section Title Widget
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isTablet;

  const _SectionTitle({required this.title, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: isTablet ? 17 : 15,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }
}

// Contact Row Widget
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool isTablet;

  const _ContactRow({
    required this.icon,
    required this.value,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

// Badge Widget
class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryForeground,
        ),
      ),
    );
  }
}

// Action Item Widget
class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isTablet;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(icon, size: 16, color: AppColors.accent),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 15 : 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
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

// Photo Gallery Widget
class _PhotoGallery extends StatelessWidget {
  final List<String> photos;
  final bool isTablet;

  const _PhotoGallery({
    required this.photos,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isTablet ? 160 : 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullImage(context, photos, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photos[index],
                width: isTablet ? 200 : 160,
                height: isTablet ? 160 : 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: isTablet ? 200 : 160,
                  height: isTablet ? 160 : 130,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      color: AppColors.mutedForeground,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullImage(
      BuildContext context, List<String> photos, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(220),
      builder: (context) => _FullScreenGallery(
        photos: photos,
        initialIndex: initialIndex,
      ),
    );
  }
}

// Full Screen Gallery Widget
class _FullScreenGallery extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const _FullScreenGallery({
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.photos.length,
          onPageChanged: (index) =>
              setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            return InteractiveViewer(
              child: Center(
                child: Image.network(
                  widget.photos[index],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Close button
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          right: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(120),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        // Dot indicators
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.photos.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentIndex == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Colors.white
                      : Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}