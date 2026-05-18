import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/models/booking_model.dart';

class GuideBookingsScreen extends StatefulWidget {
  const GuideBookingsScreen({super.key});

  @override
  State<GuideBookingsScreen> createState() => _GuideBookingsScreenState();
}

class _GuideBookingsScreenState extends State<GuideBookingsScreen> {
  String _activeTab = 'upcoming';

  List<Booking> _bookings = [
    Booking(
      guideId: '1',
      guideName: 'Maria Santos',
      guidePhoto:
      'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
      guideSpecialty: 'Food & Culture',
      date: 'March 30, 2026',
      startTime: '9:00 AM',
      endTime: '12:00 PM',
      duration: 3,
      groupSize: 2,
      meetingPoint: 'Downtown Plaza, Main Entrance',
      specialRequests: 'Interested in vegetarian food options',
      total: 135,
      cardNumber: '4532 **** **** 1234',
      bookingRef: 'LL-2026-0001',
      status: BookingStatus.upcoming,
      travelerName: 'Alex Thompson',
      travelerPhoto:
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      travelerEmail: 'alex.thompson@email.com',
      travelerPhone: '+1 555-0123',
    ),
    Booking(
      guideId: '1',
      guideName: 'Maria Santos',
      guidePhoto:
      'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
      guideSpecialty: 'Food & Culture',
      date: 'April 2, 2026',
      startTime: '2:00 PM',
      endTime: '5:00 PM',
      duration: 3,
      groupSize: 1,
      meetingPoint: 'City Center Hotel Lobby',
      total: 135,
      cardNumber: '4532 **** **** 5678',
      bookingRef: 'LL-2026-0002',
      status: BookingStatus.upcoming,
      travelerName: 'Sarah Johnson',
      travelerPhoto:
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      travelerEmail: 'sarah.j@email.com',
      travelerPhone: '+1 555-0456',
    ),
    Booking(
      guideId: '1',
      guideName: 'Maria Santos',
      guidePhoto:
      'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
      guideSpecialty: 'Food & Culture',
      date: 'March 25, 2026',
      startTime: '10:00 AM',
      endTime: '1:00 PM',
      duration: 3,
      groupSize: 3,
      meetingPoint: 'Central Park North Gate',
      total: 135,
      cardNumber: '4532 **** **** 9012',
      bookingRef: 'LL-2026-0003',
      status: BookingStatus.completed,
      travelerName: 'Michael Chen',
      travelerPhoto:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      travelerEmail: 'm.chen@email.com',
    ),
    Booking(
      guideId: '1',
      guideName: 'Maria Santos',
      guidePhoto:
      'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
      guideSpecialty: 'Food & Culture',
      date: 'March 22, 2026',
      startTime: '5:00 PM',
      endTime: '8:00 PM',
      duration: 3,
      groupSize: 2,
      meetingPoint: 'Harbor View Restaurant',
      total: 135,
      cardNumber: '4532 **** **** 3456',
      bookingRef: 'LL-2026-0004',
      status: BookingStatus.completed,
      travelerName: 'Emma Wilson',
      travelerPhoto:
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      travelerEmail: 'emma.w@email.com',
    ),
    Booking(
      guideId: '1',
      guideName: 'Maria Santos',
      guidePhoto:
      'https://images.unsplash.com/photo-1664101606938-e664f5852fac?w=400',
      guideSpecialty: 'Food & Culture',
      date: 'March 20, 2026',
      startTime: '9:00 AM',
      endTime: '12:00 PM',
      duration: 3,
      groupSize: 1,
      meetingPoint: 'Museum District',
      total: 135,
      cardNumber: '4532 **** **** 7890',
      bookingRef: 'LL-2026-0005',
      status: BookingStatus.cancelled,
      travelerName: 'David Martinez',
      travelerPhoto:
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      travelerEmail: 'd.martinez@email.com',
    ),
  ];

  List<Booking> get _upcoming =>
      _bookings.where((b) => b.isUpcoming).toList();

  List<Booking> get _past =>
      _bookings.where((b) => b.isCompleted || b.isCancelled).toList();

  List<Booking> get _displayed =>
      _activeTab == 'upcoming' ? _upcoming : _past;

  int get _completedCount => _bookings.where((b) => b.isCompleted).length;

  void _completeTour(Booking booking) {
    if (!booking.canComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tour can only be completed after ${booking.endTime} on ${booking.date}',
          ),
          backgroundColor: const Color(0xFFEA580C),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Complete Tour',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Mark the tour with ${booking.travelerName} as completed?',
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
              setState(() {
                final index = _bookings.indexOf(booking);
                _bookings[index] =
                    booking.copyWith(status: BookingStatus.completed);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tour marked as completed!'),
                  backgroundColor: Color(0xFF16A34A),
                ),
              );
            },
            child: const Text(
              'Complete',
              style: TextStyle(
                fontFamily: AppFonts.family,
                color: Color(0xFF16A34A),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.card,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      16,
                      isTablet ? 32 : 24,
                      4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Bookings',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Manage your upcoming and past tours',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats banner
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      12,
                      isTablet ? 32 : 24,
                      16,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.accent, Color(0xFFD4623A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            value: _upcoming.length.toString(),
                            label: 'Upcoming',
                            isTablet: isTablet,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withAlpha(60),
                        ),
                        Expanded(
                          child: _StatItem(
                            value: _completedCount.toString(),
                            label: 'Completed',
                            isTablet: isTablet,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withAlpha(60),
                        ),
                        Expanded(
                          child: _StatItem(
                            value: _bookings.length.toString(),
                            label: 'Total Tours',
                            isTablet: isTablet,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      0,
                      isTablet ? 32 : 24,
                      0,
                    ),
                    child: Row(
                      children: [
                        _Tab(
                          label: 'Upcoming',
                          count: _upcoming.length,
                          isActive: _activeTab == 'upcoming',
                          onTap: () =>
                              setState(() => _activeTab = 'upcoming'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(width: 24),
                        _Tab(
                          label: 'Past',
                          count: _past.length,
                          isActive: _activeTab == 'past',
                          onTap: () =>
                              setState(() => _activeTab = 'past'),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                ],
              ),
            ),
          ),

          // Bookings list
          Expanded(
            child: _displayed.isEmpty
                ? _EmptyState(
              activeTab: _activeTab,
              isTablet: isTablet,
            )
                : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                20,
                isTablet ? 32 : 20,
                32,
              ),
              itemCount: _displayed.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _GuideBookingCard(
                  booking: _displayed[index],
                  isTablet: isTablet,
                  onComplete: () =>
                      _completeTour(_displayed[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Stat Item Widget
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isTablet;

  const _StatItem({
    required this.value,
    required this.label,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 28 : 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 13 : 11,
            color: Colors.white.withAlpha(220),
          ),
        ),
      ],
    );
  }
}

// Tab Widget
class _Tab extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  final bool isTablet;

  const _Tab({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '$label ($count)',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 15 : 14,
                fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? AppColors.accent
                    : AppColors.mutedForeground,
              ),
            ),
          ),
          Container(
            height: 2,
            width: 80,
            color: isActive ? AppColors.accent : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

// Guide Booking Card Widget
class _GuideBookingCard extends StatelessWidget {
  final Booking booking;
  final bool isTablet;
  final VoidCallback onComplete;

  const _GuideBookingCard({
    required this.booking,
    required this.isTablet,
    required this.onComplete,
  });

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return const Color(0xFF2563EB);
      case BookingStatus.completed:
        return const Color(0xFF16A34A);
      case BookingStatus.cancelled:
        return AppColors.destructive;
    }
  }

  Color get _statusBgColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return const Color(0xFFEFF6FF);
      case BookingStatus.completed:
        return const Color(0xFFF0FDF4);
      case BookingStatus.cancelled:
        return const Color(0xFFFFF1F2);
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Traveler info header
          Container(
            padding: EdgeInsets.all(isTablet ? 16 : 14),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(80),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    booking.travelerPhoto ?? '',
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.travelerName ?? 'Traveller',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 17 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Traveller',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 13 : 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBgColor,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: _statusColor.withAlpha(60),
                    ),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 13 : 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Booking details
          Padding(
            padding: EdgeInsets.all(isTablet ? 16 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  icon: FontAwesomeIcons.calendarDays,
                  value: booking.date,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: FontAwesomeIcons.clock,
                  value:
                  '${booking.startTime} → ${booking.endTime} · ${booking.duration} hr${booking.duration > 1 ? 's' : ''}',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: FontAwesomeIcons.userGroup,
                  value:
                  '${booking.groupSize} ${booking.groupSize == 1 ? 'person' : 'people'}',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: FontAwesomeIcons.locationDot,
                  value: booking.meetingPoint,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: FontAwesomeIcons.dollarSign,
                  value:
                  'Earning: \$${booking.earnings.toStringAsFixed(0)} (after 10% fee)',
                  isTablet: isTablet,
                  valueColor: const Color(0xFF16A34A),
                ),

                // Special requests
                if (booking.specialRequests != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border:
                      Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Requests:',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.specialRequests!,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 13 : 12,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Contact info for upcoming
                if (booking.isUpcoming &&
                    (booking.travelerEmail != null ||
                        booking.travelerPhone != null)) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border:
                      Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      children: [
                        if (booking.travelerEmail != null)
                          _ContactRow(
                            icon: FontAwesomeIcons.envelope,
                            value: booking.travelerEmail!,
                            isTablet: isTablet,
                          ),
                        if (booking.travelerEmail != null &&
                            booking.travelerPhone != null)
                          const SizedBox(height: 6),
                        if (booking.travelerPhone != null)
                          _ContactRow(
                            icon: FontAwesomeIcons.phone,
                            value: booking.travelerPhone!,
                            isTablet: isTablet,
                          ),
                      ],
                    ),
                  ),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.border),
                ),

                // Action buttons
                _ActionButtons(
                  booking: booking,
                  isTablet: isTablet,
                  onComplete: onComplete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool isTablet;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.value,
    required this.isTablet,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(
          icon,
          size: isTablet ? 15 : 14,
          color: AppColors.accent,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: valueColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
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
        FaIcon(
          icon,
          size: isTablet ? 13 : 12,
          color: const Color(0xFF1D4ED8),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 13 : 12,
            color: const Color(0xFF1E3A5F),
          ),
        ),
      ],
    );
  }
}

// Action Buttons Widget
class _ActionButtons extends StatelessWidget {
  final Booking booking;
  final bool isTablet;
  final VoidCallback onComplete;

  const _ActionButtons({
    required this.booking,
    required this.isTablet,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return Row(
          children: [
            Expanded(
              child: _FilledButton(
                icon: FontAwesomeIcons.message,
                label: 'Message',
                onTap: () =>
                    context.push('/message/${booking.bookingRef}'),
                isTablet: isTablet,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _OutlineButton(
                icon: FontAwesomeIcons.circleCheck,
                label: 'Complete Tour',
                onTap: onComplete,
                isTablet: isTablet,
                color: const Color(0xFF16A34A),
              ),
            ),
          ],
        );

      case BookingStatus.completed:
        return _OutlineButton(
          icon: FontAwesomeIcons.dollarSign,
          label: 'View Payment',
          onTap: () => context.go('/guide-earnings'),
          isTablet: isTablet,
          fullWidth: true,
        );

      case BookingStatus.cancelled:
        return Center(
          child: Text(
            'This booking was cancelled',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 13,
              color: AppColors.mutedForeground,
            ),
          ),
        );
    }
  }
}

// Filled Button Widget
class _FilledButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isTablet;

  const _FilledButton({
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
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 12 : 10,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 13, color: AppColors.accentForeground),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Outline Button Widget
class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isTablet;
  final bool fullWidth;
  final Color? color;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isTablet,
    this.fullWidth = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 12 : 10,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: color?.withAlpha(80) ?? AppColors.border,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 13, color: buttonColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w500,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final String activeTab;
  final bool isTablet;

  const _EmptyState({
    required this.activeTab,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.calendarDays,
              size: isTablet ? 64 : 56,
              color: AppColors.border,
            ),
            const SizedBox(height: 16),
            Text(
              'No $activeTab bookings',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activeTab == 'upcoming'
                  ? "You don't have any upcoming tours scheduled"
                  : "You haven't completed any tours yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 14 : 13,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}