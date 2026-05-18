import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

enum EarningStatus { pending, processing, paid }

class EarningItem {
  final String id;
  final String travelerName;
  final String travelerPhoto;
  final String date;
  final String time;
  final int duration;
  final double amount;
  final double serviceFee;
  final double netAmount;
  final EarningStatus status;
  final String? payoutDate;

  const EarningItem({
    required this.id,
    required this.travelerName,
    required this.travelerPhoto,
    required this.date,
    required this.time,
    required this.duration,
    required this.amount,
    required this.serviceFee,
    required this.netAmount,
    required this.status,
    this.payoutDate,
  });
}

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _activeTab = 'pending';

  final List<EarningItem> _earnings = const [
    EarningItem(
      id: '1',
      travelerName: 'Alex Thompson',
      travelerPhoto:
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      date: 'March 30, 2026',
      time: 'Morning · 9:00 AM',
      duration: 3,
      amount: 135,
      serviceFee: 13.5,
      netAmount: 121.5,
      status: EarningStatus.pending,
    ),
    EarningItem(
      id: '2',
      travelerName: 'Sarah Johnson',
      travelerPhoto:
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      date: 'March 28, 2026',
      time: 'Afternoon · 2:00 PM',
      duration: 3,
      amount: 135,
      serviceFee: 13.5,
      netAmount: 121.5,
      status: EarningStatus.processing,
      payoutDate: 'April 2, 2026',
    ),
    EarningItem(
      id: '3',
      travelerName: 'Michael Chen',
      travelerPhoto:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      date: 'March 25, 2026',
      time: 'Morning · 10:00 AM',
      duration: 3,
      amount: 135,
      serviceFee: 13.5,
      netAmount: 121.5,
      status: EarningStatus.paid,
      payoutDate: 'March 27, 2026',
    ),
    EarningItem(
      id: '4',
      travelerName: 'Emma Wilson',
      travelerPhoto:
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      date: 'March 22, 2026',
      time: 'Evening · 5:00 PM',
      duration: 3,
      amount: 135,
      serviceFee: 13.5,
      netAmount: 121.5,
      status: EarningStatus.paid,
      payoutDate: 'March 24, 2026',
    ),
  ];

  List<EarningItem> get _pending => _earnings
      .where((e) =>
  e.status == EarningStatus.pending ||
      e.status == EarningStatus.processing)
      .toList();

  List<EarningItem> get _completed =>
      _earnings.where((e) => e.status == EarningStatus.paid).toList();

  List<EarningItem> get _displayed =>
      _activeTab == 'pending' ? _pending : _completed;

  double get _totalPending =>
      _pending.fold(0, (sum, e) => sum + e.netAmount);

  double get _totalEarned =>
      _completed.fold(0, (sum, e) => sum + e.netAmount);

  double get _totalRevenue => _totalPending + _totalEarned;

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
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 32 : 24,
                  16,
                  isTablet ? 32 : 24,
                  16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Earnings',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/payout-settings'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Payout Settings',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
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
                20,
                isTablet ? 32 : 20,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary cards row
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: FontAwesomeIcons.dollarSign,
                          iconBgColor: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF16A34A),
                          amount: '\$${_totalEarned.toStringAsFixed(2)}',
                          label: 'Total Earned',
                          isTablet: isTablet,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: FontAwesomeIcons.clock,
                          iconBgColor: const Color(0xFFFEF9C3),
                          iconColor: const Color(0xFFCA8A04),
                          amount: '\$${_totalPending.toStringAsFixed(2)}',
                          label: 'Pending',
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Total revenue card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.accent, Color(0xFFD4623A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Revenue',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                color: Colors.white.withAlpha(220),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_totalRevenue.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 32 : 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.arrowTrendUp,
                                  size: 13,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'From ${_earnings.length} completed tours',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 13 : 12,
                                    color: Colors.white.withAlpha(220),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: isTablet ? 48 : 44,
                          height: isTablet ? 48 : 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.chartLine,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleInfo,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How payouts work',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 14 : 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E3A5F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Earnings are released 24-48 hours after tour completion and transferred to your bank account based on your payout schedule.',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 13 : 12,
                                  color: const Color(0xFF1E3A5F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tabs
                  Row(
                    children: [
                      _Tab(
                        label: 'Pending',
                        count: _pending.length,
                        isActive: _activeTab == 'pending',
                        onTap: () => setState(() => _activeTab = 'pending'),
                        isTablet: isTablet,
                      ),
                      const SizedBox(width: 24),
                      _Tab(
                        label: 'Completed',
                        count: _completed.length,
                        isActive: _activeTab == 'completed',
                        onTap: () =>
                            setState(() => _activeTab = 'completed'),
                        isTablet: isTablet,
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border),


                  // Earnings list
                  if (_displayed.isEmpty)
                    _EmptyState(
                      activeTab: _activeTab,
                      isTablet: isTablet,
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _displayed.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _EarningCard(
                          earning: _displayed[index],
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

// Summary Card Widget
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String amount;
  final String label;
  final bool isTablet;

  const _SummaryCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.amount,
    required this.label,
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(icon, size: 16, color: iconColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
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
            padding: const EdgeInsets.only(bottom: 8),
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

// Earning Card Widget
class _EarningCard extends StatelessWidget {
  final EarningItem earning;
  final bool isTablet;

  const _EarningCard({required this.earning, required this.isTablet});

  Color get _statusColor {
    switch (earning.status) {
      case EarningStatus.pending:
        return const Color(0xFFCA8A04);
      case EarningStatus.processing:
        return const Color(0xFF2563EB);
      case EarningStatus.paid:
        return const Color(0xFF16A34A);
    }
  }

  Color get _statusBgColor {
    switch (earning.status) {
      case EarningStatus.pending:
        return const Color(0xFFFEF9C3);
      case EarningStatus.processing:
        return const Color(0xFFEFF6FF);
      case EarningStatus.paid:
        return const Color(0xFFF0FDF4);
    }
  }

  String get _statusLabel {
    switch (earning.status) {
      case EarningStatus.pending:
        return 'Pending';
      case EarningStatus.processing:
        return 'Processing';
      case EarningStatus.paid:
        return 'Paid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Traveler photo
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              earning.travelerPhoto,
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earning.travelerName,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 15 : 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${earning.date} · ${earning.duration}h tour',
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
                          fontSize: isTablet ? 12 : 11,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price breakdown
                _PriceRow(
                  label: 'Tour fee:',
                  value: '\$${earning.amount.toStringAsFixed(0)}',
                  isTablet: isTablet,
                ),
                const SizedBox(height: 4),
                _PriceRow(
                  label: 'Service fee (10%):',
                  value: '-\$${earning.serviceFee.toStringAsFixed(2)}',
                  valueColor: AppColors.destructive,
                  isTablet: isTablet,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColors.border),
                ),
                _PriceRow(
                  label: 'You earn:',
                  value: '\$${earning.netAmount.toStringAsFixed(2)}',
                  valueColor: AppColors.accent,
                  isBold: true,
                  isTablet: isTablet,
                ),

                // Payout date
                if (earning.payoutDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FaIcon(
                        earning.status == EarningStatus.paid
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.clock,
                        size: 12,
                        color: const Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        earning.status == EarningStatus.paid
                            ? 'Paid on ${earning.payoutDate}'
                            : 'Expected payout: ${earning.payoutDate}',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 13 : 12,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Price Row Widget
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTablet;
  final Color? valueColor;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isTablet,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 13 : 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold ? AppColors.primary : AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 13 : 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: valueColor ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final String activeTab;
  final bool isTablet;

  const _EmptyState({required this.activeTab, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.dollarSign,
              size: isTablet ? 56 : 48,
              color: AppColors.border,
            ),
            const SizedBox(height: 16),
            Text(
              'No $activeTab earnings',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activeTab == 'pending'
                  ? 'Complete tours to start earning'
                  : 'Your completed payouts will appear here',
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