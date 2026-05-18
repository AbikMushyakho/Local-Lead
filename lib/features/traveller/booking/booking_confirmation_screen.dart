import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/models/booking_model.dart';


class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    // Animated success icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: isTablet ? 120 : 100,
                              height: isTablet ? 120 : 100,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withAlpha(40),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            width: isTablet ? 96 : 80,
                            height: isTablet ? 96 : 80,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.circleCheck,
                                size: isTablet ? 48 : 40,
                                color: AppColors.accentForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 32 : 24),

                    // Success message
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Booking Confirmed!',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 28 : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your tour with ${booking.guideName} has been successfully booked',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 20),

                    // Payment success badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.shieldHalved,
                            size: 16,
                            color: Color(0xFF16A34A),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Payment Successful',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 15 : 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 20),

                    // Booking details card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Guide info
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(12),
                                child: Image.network(
                                  booking.guidePhoto,
                                  width: isTablet ? 72 : 64,
                                  height: isTablet ? 72 : 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(
                                        width: isTablet ? 72 : 64,
                                        height: isTablet ? 72 : 64,
                                        decoration: const BoxDecoration(
                                          color: AppColors.secondary,
                                        ),
                                        child: const Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.user,
                                            color:
                                            AppColors.mutedForeground,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.guideName,
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: isTablet ? 18 : 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      booking.guideSpecialty,
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: isTablet ? 14 : 13,
                                        color:
                                        AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: AppColors.border),
                          ),

                          // Booking details
                          _DetailRow(
                            icon: FontAwesomeIcons.calendarDays,
                            label: 'Date',
                            value: booking.date,
                            isTablet: isTablet,
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: FontAwesomeIcons.clock,
                            label: 'Time',
                            value:
                            '${booking.startTime} → ${booking.endTime} · ${booking.duration} hr${booking.duration > 1 ? 's' : ''}',
                            isTablet: isTablet,
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: FontAwesomeIcons.userGroup,
                            label: 'Group Size',
                            value:
                            '${booking.groupSize} ${booking.groupSize == 1 ? 'person' : 'people'}',
                            isTablet: isTablet,
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: FontAwesomeIcons.creditCard,
                            label: 'Payment',
                            value: booking.cardNumber,
                            isTablet: isTablet,
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: FontAwesomeIcons.dollarSign,
                            label: 'Total Paid',
                            value:
                            '\$${booking.total.toStringAsFixed(2)}',
                            isTablet: isTablet,
                            valueColor: AppColors.accent,
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: FontAwesomeIcons.locationDot,
                            label: 'Meeting Point',
                            value: booking.meetingPoint,
                            isTablet: isTablet,
                          ),
                          if (booking.specialRequests != null) ...[
                            const SizedBox(height: 16),
                            _DetailRow(
                              icon: FontAwesomeIcons.commentDots,
                              label: 'Special Requests',
                              value: booking.specialRequests!,
                              isTablet: isTablet,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),

                    // Booking reference
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Booking Reference',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 13 : 12,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${booking.bookingRef}',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),

                    // Info message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accent.withAlpha(50),
                        ),
                      ),
                      child: Text(
                        'A confirmation has been saved. Your guide will contact you 24 hours before the tour.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),

                    // Cancellation reminder
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFBFDBFE)),
                      ),
                      child: Text(
                        'Reminder: Free cancellation up to 48 hours before the tour. See our cancellation policy for details.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 13 : 12,
                          color: const Color(0xFF1E3A5F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 48 : 24,
                0,
                isTablet ? 48 : 24,
                isTablet ? 32 : 24,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56 : 48,
                    child: OutlinedButton(
                      onPressed: () => context.go('/my-bookings'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View My Bookings',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 16 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56 : 48,
                    child: ElevatedButton(
                      onPressed: () => context.go('/explore'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.accentForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 16 : 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isTablet;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isTablet,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: isTablet ? 18 : 16,
          color: AppColors.accent,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 13 : 12,
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: isTablet ? 15 : 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}