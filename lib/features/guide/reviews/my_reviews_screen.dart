import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/review_data.dart';
import 'package:local_lead/models/review_model.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  String _filter = 'all';

  List<Review> get _filtered {
    if (_filter == 'all') return guideReviews;
    final rating = int.parse(_filter);
    return guideReviews
        .where((r) => r.rating == rating)
        .toList();
  }

  double get _averageRating {
    if (guideReviews.isEmpty) return 0;
    final sum =
    guideReviews.fold(0.0, (sum, r) => sum + r.rating);
    return sum / guideReviews.length;
  }

  int _countForRating(int rating) =>
      guideReviews.where((r) => r.rating == rating).length;

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
                      'My Reviews',
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
                  // Stats card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Average rating
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.baseline,
                                  textBaseline:
                                  TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _averageRating
                                          .toStringAsFixed(1),
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: isTablet ? 44 : 40,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'out of 5',
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: isTablet ? 14 : 13,
                                        color:
                                        AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(5, (i) {
                                    return FaIcon(
                                        FontAwesomeIcons.solidStar,
                                        size: isTablet ? 18 : 16,
                                        color: i < _averageRating.floor()
                                        ? const Color(0xFFFBBF24)
                                        : AppColors.border,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${guideReviews.length} total reviews',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 13 : 12,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),

                            // Excellent badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius:
                                BorderRadius.circular(100),
                                border: Border.all(
                                    color: const Color(0xFFBBF7D0)),
                              ),
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.arrowTrendUp,
                                    size: 12,
                                    color: Color(0xFF16A34A),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Excellent',
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize: isTablet ? 13 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Rating distribution bars
                        ...List.generate(5, (i) {
                          final rating = 5 - i;
                          final count = _countForRating(rating);
                          final percentage = guideReviews.isEmpty
                              ? 0.0
                              : count / guideReviews.length;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                // Rating label
                                SizedBox(
                                  width: 32,
                                  child: Row(
                                    children: [
                                      Text(
                                        '$rating',
                                        style: TextStyle(
                                          fontFamily: AppFonts.family,
                                          fontSize:
                                          isTablet ? 13 : 12,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const FaIcon(
                                        FontAwesomeIcons.solidStar,
                                        size: 10,
                                        color: Color(0xFFFBBF24),
                                      ),
                                    ],
                                  ),
                                ),

                                // Progress bar
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor:
                                      AppColors.secondary,
                                      valueColor:
                                      const AlwaysStoppedAnimation(
                                        AppColors.accent,
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),

                                // Count
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    '$count',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: AppFonts.family,
                                      fontSize: isTablet ? 13 : 12,
                                      color: AppColors.mutedForeground,
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
                  const SizedBox(height: 20),

                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All Reviews',
                          isSelected: _filter == 'all',
                          onTap: () =>
                              setState(() => _filter = 'all'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label:
                          '5 Stars (${_countForRating(5)})',
                          isSelected: _filter == '5',
                          onTap: () =>
                              setState(() => _filter = '5'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label:
                          '4 Stars (${_countForRating(4)})',
                          isSelected: _filter == '4',
                          onTap: () =>
                              setState(() => _filter = '4'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label:
                          '3 Stars (${_countForRating(3)})',
                          isSelected: _filter == '3',
                          onTap: () =>
                              setState(() => _filter = '3'),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reviews list
                  if (_filtered.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 48,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.solidStar,
                            size: 40,
                            color: AppColors.border,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No reviews found',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _ReviewCard(
                          review: _filtered[index],
                          isTablet: isTablet,
                        );
                      },
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

// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTablet;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 14 : 13,
            fontWeight:
            isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.accentForeground
                : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// Review Card Widget
class _ReviewCard extends StatelessWidget {
  final Review review;
  final bool isTablet;

  const _ReviewCard({
    required this.review,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User photo
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  review.userPhoto,
                  width: isTablet ? 52 : 46,
                  height: isTablet ? 52 : 46,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: isTablet ? 52 : 46,
                    height: isTablet ? 52 : 46,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        if (review.verified) ...[
                          const SizedBox(width: 6),
                          const FaIcon(
                            FontAwesomeIcons.shieldHalved,
                            size: 13,
                            color: AppColors.accent,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      review.date,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 13 : 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.solidStar,
                      size: 11,
                      color: Color(0xFFFBBF24),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(0),
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 13 : 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Tour type badge
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
              review.tourType,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 12 : 11,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryForeground,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Comment
          Text(
            review.comment,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}