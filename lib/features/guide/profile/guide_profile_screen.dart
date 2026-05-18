import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/guides_data.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/data/review_data.dart';
import 'package:local_lead/models/review_model.dart';
class GuideProfileScreen extends StatelessWidget {
  final String guideId;

  const GuideProfileScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final guide = guides.firstWhere(
          (g) => g.id == guideId,
      orElse: () => guides.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image
                _HeaderImage(guide: guide),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isTablet ? 32 : 24,
                    isTablet ? 16 : 12,
                    isTablet ? 32 : 24,
                    120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Guide Info
                      _GuideInfoHeader(guide: guide, isTablet: isTablet),
                      SizedBox(height: isTablet ? 24 : 16),

                      // About
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(title: 'About', isTablet: isTablet),
                            const SizedBox(height: 8),
                            Text(
                              guide.bio,
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
                                    title: 'Languages', isTablet: isTablet),
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
                                    title: 'Certifications', isTablet: isTablet),


                            ],
                          ),
                          const SizedBox(height: 12),
                            ...guide.certifications.map((cert) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration:
                                    const BoxDecoration(
                                      color: AppColors.accent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    cert,
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize:
                                      isTablet ? 14 : 13,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),



                      // Availability & Pricing
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section header
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

                            // Hourly rate
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        text: '\$${guide.hourlyRate.toInt()}',
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

                            // Weekly schedule label
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

                            // Weekly availability rows
                            ...['monday', 'tuesday', 'wednesday', 'thursday',
                              'friday', 'saturday', 'sunday'].map((day) {
                              final slots = guide.weeklyAvailability[day] ?? [];
                              final isAvailable = slots.isNotEmpty;
                              final dayLabel = day[0].toUpperCase() + day.substring(1);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Day name
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

                                    // Slots or unavailable
                                    Expanded(
                                      child: isAvailable
                                          ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: slots.map((slot) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 4),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.accent.withAlpha(15),
                                                borderRadius: BorderRadius.circular(100),
                                                border: Border.all(
                                                  color: AppColors.accent.withAlpha(60),
                                                ),
                                              ),
                                              child: Text(
                                                slot.formatted,
                                                style: TextStyle(
                                                  fontFamily: AppFonts.family,
                                                  fontSize: isTablet ? 13 : 12,
                                                  fontWeight: FontWeight.w500,
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
                                'Highlights from previous tours with ${guide.name}',
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

                      // Reviews
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reviews (${guide.reviewCount})',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: guideReviews.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _ReviewCard(
                                review: guideReviews[index],
                                isTablet: isTablet,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: isTablet ? 32 : 24,
            child: GestureDetector(
              onTap: () => context.pop(),
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
                    FontAwesomeIcons.arrowLeft,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          // Fixed Book Now button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 24,
                12,
                isTablet ? 32 : 24,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: isTablet ? 64 : 56,
                child: ElevatedButton(
                  onPressed: () => context.push('/booking-details/${guide.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.accentForeground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Book Now · \$${guide.hourlyRate.toInt()}/hour',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                    ),
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

// Header Image Widget
class _HeaderImage extends StatelessWidget {
  final Guide guide;

  const _HeaderImage({required this.guide});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        children: [
          Image.network(
            guide.photo,
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.secondary,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.person,
                  size: 64,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
          ),
          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Guide Info Header Widget
class _GuideInfoHeader extends StatelessWidget {
  final Guide guide;
  final bool isTablet;

  const _GuideInfoHeader({required this.guide, required this.isTablet});

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
                  Text(
                    guide.name,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    guide.specialty,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    guide.rating.toString(),
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
            _StatItem(
              icon: FontAwesomeIcons.locationDot,
              label: guide.distance,
              isTablet: isTablet,
            ),
            SizedBox(width: isTablet ? 20 : 16),
            _StatItem(
              icon: FontAwesomeIcons.award,
              label: guide.experience,
              isTablet: isTablet,
            ),
            SizedBox(width: isTablet ? 20 : 16),
            _StatItem(
              icon: FontAwesomeIcons.message,
              label: '${guide.reviewCount} reviews',
              isTablet: isTablet,
            ),
          ],
        ),
      ],
    );
  }
}

// Stat Item Widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isTablet;

  const _StatItem({
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

// Badge Widget
class _Badge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Badge({
    required this.label,
    this.bgColor = AppColors.secondary,
    this.textColor = AppColors.secondaryForeground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

// Review Card Widget
class _ReviewCard extends StatelessWidget {
  final Review review;
  final bool isTablet;

  const _ReviewCard({required this.review, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User photo
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              review.userPhoto,
              width: isTablet ? 48 : 40,
              height: isTablet ? 48 : 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: isTablet ? 48 : 40,
                height: isTablet ? 48 : 40,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.user,
                    size: 16,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 15 : 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 13 : 11,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Star rating
                Row(
                  children: List.generate(5, (index) {
                    return FaIcon(
                      FontAwesomeIcons.solidStar,
                      size: 11,
                      color: index < review.rating
                          ? const Color(0xFFFBBF24)
                          : AppColors.border,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 14 : 12,
                    color: AppColors.mutedForeground,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        // Page view
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

        // Photo counter
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