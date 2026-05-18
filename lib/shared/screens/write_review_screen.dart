import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/guides_data.dart';
import 'package:local_lead/models/guide_model.dart';

class WriteReviewScreen extends StatefulWidget {
  final String guideId;
  final String bookingId;

  const WriteReviewScreen({
    super.key,
    required this.guideId,
    required this.bookingId,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  late Guide guide;
  int _rating = 0;
  int _hoveredRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    guide = guides.firstWhere(
          (g) => g.id == widget.guideId,
      orElse: () => guides.first,
    );
    _reviewController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 5:
        return 'Outstanding!';
      case 4:
        return 'Great!';
      case 3:
        return 'Good';
      case 2:
        return 'Fair';
      case 1:
        return 'Poor';
      default:
        return '';
    }
  }

  bool get _canSubmit =>
      _rating > 0 &&
          _reviewController.text.trim().length >= 10 &&
          !_isSubmitting;

  void _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (_reviewController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please write at least 10 characters')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate submission delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
      context.go('/my-bookings');
    }
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
                      'Write a Review',
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
                24,
                isTablet ? 32 : 20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guide info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            guide.photo,
                            width: isTablet ? 64 : 56,
                            height: isTablet ? 64 : 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: isTablet ? 64 : 56,
                              height: isTablet ? 64 : 56,
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
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.name,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 17 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                guide.specialty,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 14 : 13,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rating card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'How was your experience?',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 17 : 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final star = index + 1;
                            final isActive =
                                star <= (_hoveredRating > 0
                                    ? _hoveredRating
                                    : _rating);
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _rating = star),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  size: isTablet ? 48 : 40,
                                  color: isActive
                                      ? const Color(0xFFFBBF24)
                                      : AppColors.border,
                                ),
                              ),
                            );
                          }),
                        ),

                        // Rating label
                        if (_rating > 0) ...[
                          const SizedBox(height: 12),
                          Text(
                            _ratingLabel,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 15 : 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Review text card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share your experience',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 16 : 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _reviewController,
                          maxLines: 5,
                          maxLength: 500,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            color: AppColors.primary,
                          ),
                          decoration: InputDecoration(
                            hintText:
                            'Tell others about your tour experience. What did you enjoy? What made it special?',
                            hintStyle: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 14 : 13,
                              color: AppColors.mutedForeground,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: AppColors.accent),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Minimum 10 characters',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 13 : 12,
                                color: _reviewController.text.trim().length < 10 &&
                              _reviewController.text.isNotEmpty
                              ? AppColors.destructive
                                : AppColors.mutedForeground,
                              ),
                            ),
                            Text(
                              '${_reviewController.text.length}/500',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 13 : 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  GestureDetector(
                    onTap: _canSubmit ? _submit : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _canSubmit
                            ? AppColors.accent
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.paperPlane,
                              size: 16,
                              color: _canSubmit
                                  ? AppColors.accentForeground
                                  : AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Submit Review',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 16 : 15,
                                fontWeight: FontWeight.w600,
                                color: _canSubmit
                                    ? AppColors.accentForeground
                                    : AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Guidelines card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review Guidelines',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3A5F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...[
                          'Be honest and constructive',
                          'Focus on your experience with the guide',
                          'Avoid inappropriate or offensive language',
                          'Include specific details about what you enjoyed',
                        ].map(
                              (guideline) => Padding(
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
                                    guideline,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}