import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/models/booking_model.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
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
      specialRequests: 'Vegetarian food options please',
      total: 140,
      cardNumber: '4532 **** **** 1234',
      bookingRef: 'LL-2026-0001',
      status: BookingStatus.upcoming,
    ),
    Booking(
      guideId: '2',
      guideName: 'James Chen',
      guidePhoto:
      'https://images.unsplash.com/photo-1741242950155-2ac2eb91bd69?w=400',
      guideSpecialty: 'Architecture & History',
      date: 'March 15, 2026',
      startTime: '2:00 PM',
      endTime: '5:00 PM',
      duration: 3,
      groupSize: 1,
      meetingPoint: 'City Center Hotel Lobby',
      total: 125,
      cardNumber: '4532 **** **** 1234',
      bookingRef: 'LL-2026-0002',
      status: BookingStatus.completed,
    ),
    Booking(
      guideId: '3',
      guideName: 'Sofia Petrov',
      guidePhoto:
      'https://images.unsplash.com/photo-1697468575302-e50cbb0b6b35?w=400',
      guideSpecialty: 'Art & Photography',
      date: 'February 20, 2026',
      startTime: '7:00 AM',
      endTime: '10:00 AM',
      duration: 3,
      groupSize: 2,
      meetingPoint: 'Eiffel Tower East Entrance',
      total: 115,
      cardNumber: '4532 **** **** 1234',
      bookingRef: 'LL-2026-0003',
      status: BookingStatus.cancelled,
    ),
  ];

  List<Booking> get _upcoming =>
      _bookings.where((b) => b.isUpcoming).toList();

  List<Booking> get _past =>
      _bookings.where((b) => b.isCompleted || b.isCancelled).toList();

  List<Booking> get _displayed =>
      _activeTab == 'upcoming' ? _upcoming : _past;

  void _cancelBooking(String bookingRef) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Cancel Booking',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? Cancellation policy applies.',
          style: TextStyle(
            fontFamily: AppFonts.family,
            color: AppColors.mutedForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Booking',
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
                final index = _bookings
                    .indexWhere((b) => b.bookingRef == bookingRef);
                if (index != -1) {
                  _bookings[index] = _bookings[index]
                      .copyWith(status: BookingStatus.cancelled);
                }
              });
            },
            child: const Text(
              'Cancel Booking',
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
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      16,
                      isTablet ? 32 : 24,
                      0,
                    ),
                    child: Row(
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
                      ],
                    ),
                  ),

                  // Tabs
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 32 : 24,
                      12,
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
                return _BookingCard(
                  booking: _displayed[index],
                  isTablet: isTablet,
                  onCancel: () => _cancelBooking(
                      _displayed[index].bookingRef),
                );
              },
            ),
          ),
        ],
      ),
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

// Booking Card Widget
class _BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isTablet;
  final VoidCallback onCancel;

  const _BookingCard({
    required this.booking,
    required this.isTablet,
    required this.onCancel,
  });

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return const Color(0xFF16A34A);
      case BookingStatus.completed:
        return const Color(0xFF2563EB);
      case BookingStatus.cancelled:
        return AppColors.destructive;
    }
  }

  Color get _statusBgColor {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return const Color(0xFFF0FDF4);
      case BookingStatus.completed:
        return const Color(0xFFEFF6FF);
      case BookingStatus.cancelled:
        return const Color(0xFFFFF1F2);
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 'Confirmed';
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
          // Guide info header
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
                    booking.guidePhoto,
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
                        booking.guideName,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 17 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        booking.guideSpecialty,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
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
                if (booking.specialRequests != null) ...[
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: FontAwesomeIcons.commentDots,
                    value: booking.specialRequests!,
                    isTablet: isTablet,
                    valueColor: AppColors.mutedForeground,
                  ),
                ],
                const SizedBox(height: 10),
                _DetailRow(
                  icon: FontAwesomeIcons.dollarSign,
                  value: 'Total: \$${booking.total.toStringAsFixed(2)}',
                  isTablet: isTablet,
                  valueColor: AppColors.accent,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.border),
                ),

                // Action buttons
                _ActionButtons(
                  booking: booking,
                  isTablet: isTablet,
                  onCancel: onCancel,
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

// Action Buttons Widget
class _ActionButtons extends StatelessWidget {
  final Booking booking;
  final bool isTablet;
  final VoidCallback onCancel;

  const _ActionButtons({
    required this.booking,
    required this.isTablet,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return Row(
          children: [
            Expanded(
              child: _OutlineButton(
                icon: FontAwesomeIcons.user,
                label: 'View Guide',
                onTap: () => context
                    .push('/guide-profile/${booking.guideId}'),
                isTablet: isTablet,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _OutlineButton(
                icon: FontAwesomeIcons.message,
                label: 'Message',
                onTap: () => context
                    .push('/message/${booking.bookingRef}'),
                isTablet: isTablet,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onCancel,
              child: Container(
                width: isTablet ? 44 : 40,
                height: isTablet ? 44 : 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 14,
                    color: AppColors.destructive,
                  ),
                ),
              ),
            ),
          ],
        );

      case BookingStatus.completed:
        return Row(
          children: [
            Expanded(
              child: _OutlineButton(
                icon: FontAwesomeIcons.user,
                label: 'View Guide',
                onTap: () => context
                    .push('/guide-profile/${booking.guideId}'),
                isTablet: isTablet,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _FilledButton(
                label: 'Write Review',
                onTap: () {
                  context.push(
                    '/write-review',
                    extra: {
                      'guideId': booking.guideId,
                      'bookingId': booking.bookingRef,
                    },
                  );
                },
                isTablet: isTablet,
              ),
            ),
          ],
        );

      case BookingStatus.cancelled:
        return _OutlineButton(
          icon: FontAwesomeIcons.magnifyingGlass,
          label: 'Browse Guides',
          onTap: () => context.go('/explore'),
          isTablet: isTablet,
          fullWidth: true,
        );
    }
  }
}

// Outline Button Widget
class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isTablet;
  final bool fullWidth;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isTablet,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 12 : 10,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 13, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 14 : 12,
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

// Filled Button Widget
class _FilledButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isTablet;

  const _FilledButton({
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
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentForeground,
            ),
          ),
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
                  ? "You don't have any upcoming tours"
                  : "You haven't completed any tours yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 14 : 13,
                color: AppColors.mutedForeground,
              ),
            ),
            if (activeTab == 'upcoming') ...[
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go('/explore'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Browse Guides',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentForeground,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}