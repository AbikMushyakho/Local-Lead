import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/models/guide_model.dart';

class GuideCard extends StatelessWidget {
  final Guide guide;

  const GuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return GestureDetector(
      onTap: () => context.push('/guide-profile/${guide.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Guide Photo
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      guide.photo,
                      width: isTablet ? 90 : 80,
                      height: isTablet ? 90 : 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: isTablet ? 90 : 80,
                        height: isTablet ? 90 : 80,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  ),
                  // Online indicator
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: isTablet ? 16 : 12),

              // Guide Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            guide.name,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 18 : 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 12,
                              color: Color(0xFFFBBF24),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              guide.rating.toString(),
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Specialty
                    Text(
                      guide.specialty,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 14 : 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Distance and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: 11,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              guide.distance,
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 13 : 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$${guide.hourlyRate.toInt()}',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                              TextSpan(
                                text: '/hour',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 12 : 11,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Review count
                    Text(
                      '${guide.reviewCount} reviews',
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
        ),
      ),
    );
  }
}