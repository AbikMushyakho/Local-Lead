import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';
import 'package:local_lead/data/guides_data.dart';
import 'package:local_lead/models/guide_model.dart';
import 'package:local_lead/models/booking_model.dart';
import 'package:local_lead/models/payment_card_model.dart';
import 'package:local_lead/shared/widgets/payment_card_selector.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String guideId;

  const BookingDetailsScreen({super.key, required this.guideId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late Guide guide;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  AvailabilitySlot? _selectedSlot;
  TimeOfDay? _selectedStartTime;
  int _selectedHours = 1;
  int _groupSize = 1;
  final int _minGroup = 1;
  final int _maxGroup = 10;
  final TextEditingController _meetingPointController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();

  final List<PaymentCard> _cards = [
    const PaymentCard(
      id: '1',
      cardNumber: '4532 **** **** 1234',
      cardHolder: 'Alex Thompson',
      expiryDate: '12/25',
      type: CardType.visa,
      isDefault: true,
    ),
  ];
  PaymentCard? _selectedCard;

  @override
  void initState() {
    super.initState();
    guide = guides.firstWhere(
          (g) => g.id == widget.guideId,
      orElse: () => guides.first,
    );
    _selectedCard = _cards.firstWhere(
          (c) => c.isDefault,
      orElse: () => _cards.first,
    );
    // Auto select first available day
    _selectedDay = _findNextAvailableDay(DateTime.now());
    _focusedDay = _selectedDay;
    _autoSelectSlot();
  }
  @override
  void dispose() {
    _meetingPointController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }
  // Get day name from DateTime
  String _getDayName(DateTime date) {
    const days = [
      'monday', 'tuesday', 'wednesday',
      'thursday', 'friday', 'saturday', 'sunday'
    ];
    return days[date.weekday - 1];
  }

  // Check if a day is available
  bool _isDayAvailable(DateTime day) {
    final slots = guide.weeklyAvailability[_getDayName(day)] ?? [];
    return slots.isNotEmpty;
  }

  // Get slots for selected day
  List<AvailabilitySlot> get _slotsForSelectedDay {
    return guide.weeklyAvailability[_getDayName(_selectedDay)] ?? [];
  }

  // Find next available day from a given date
  DateTime _findNextAvailableDay(DateTime from) {
    DateTime day = from;
    for (int i = 0; i < 90; i++) {
      if (_isDayAvailable(day)) return day;
      day = day.add(const Duration(days: 1));
    }
    return from;
  }

  // Auto select first slot when day changes
  void _autoSelectSlot() {
    final slots = _slotsForSelectedDay;
    if (slots.isNotEmpty) {
      _selectedSlot = slots.first;
      _selectedStartTime = _parseTimeOfDay(slots.first.start);
      _selectedHours = 1;
    } else {
      _selectedSlot = null;
      _selectedStartTime = null;
    }
  }

  // Parse time string to TimeOfDay
  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Calculate max hours within selected slot
  int get _maxHours {
    if (_selectedSlot == null || _selectedStartTime == null) return 1;
    final slotEnd = _parseTimeOfDay(_selectedSlot!.end);
    final start = _selectedStartTime!;
    final remainingMinutes =
        (slotEnd.hour * 60 + slotEnd.minute) -
            (start.hour * 60 + start.minute);
    final maxH = (remainingMinutes / 60).floor();
    return maxH < 1 ? 1 : maxH;
  }

  // Calculate end time
  TimeOfDay get _endTime {
    if (_selectedStartTime == null) {
      return const TimeOfDay(hour: 10, minute: 0);
    }
    final totalMinutes =
        _selectedStartTime!.hour * 60 +
            _selectedStartTime!.minute +
            _selectedHours * 60;
    return TimeOfDay(
      hour: totalMinutes ~/ 60,
      minute: totalMinutes % 60,
    );
  }

  // Format TimeOfDay to string
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour =
    hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  // Formatted date
  String get _formattedDate {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_selectedDay.month - 1]} ${_selectedDay.day}, ${_selectedDay.year}';
  }

  // Price calculations
  double get _subtotal =>
      guide.hourlyRate * _selectedHours * _groupSize;

  double get _groupDiscount {
    if (_groupSize >= 5) return 0.15;
    if (_groupSize >= 3) return 0.10;
    return 0;
  }

  double get _discountAmount => _subtotal * _groupDiscount;
  double get _discountedSubtotal => _subtotal - _discountAmount;
  double get _serviceFee => 5.0;
  double get _total => _discountedSubtotal + _serviceFee;

  // Pick start time within slot
  Future<void> _pickStartTime() async {
    if (_selectedSlot == null) return;

    final slotStart = _parseTimeOfDay(_selectedSlot!.start);
    final slotEnd = _parseTimeOfDay(_selectedSlot!.end);

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? slotStart,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent,
              onPrimary: AppColors.accentForeground,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Validate picked time is within slot
      final pickedMinutes = picked.hour * 60 + picked.minute;
      final startMinutes = slotStart.hour * 60 + slotStart.minute;
      final endMinutes = slotEnd.hour * 60 + slotEnd.minute;

      if (pickedMinutes >= startMinutes && pickedMinutes < endMinutes) {
        setState(() {
          _selectedStartTime = picked;
          // Reset hours if current selection exceeds slot
          if (_selectedHours > _maxHours) {
            _selectedHours = _maxHours;
          }
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please select a time between ${_selectedSlot!.formatted}',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final slots = _slotsForSelectedDay;
    final isDayAvailable = slots.isNotEmpty;

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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        guide.photo,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 40,
                          height: 40,
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
                          Text(
                            guide.name,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            guide.specialty,
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
                        color: AppColors.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '\$${guide.hourlyRate.toInt()}/hr',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
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
                120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── 1. SELECT DATE ──────────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.calendarDays,
                    title: 'Select Date',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay:
                      DateTime.now().add(const Duration(days: 90)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      enabledDayPredicate: (day) =>
                          _isDayAvailable(day),
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!_isDayAvailable(selectedDay)) return;
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          _autoSelectSlot();
                        });
                      },
                      calendarStyle: CalendarStyle(
                        // Available days
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: AppColors.accentForeground,
                          fontWeight: FontWeight.w600,
                        ),
                        defaultTextStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          color: AppColors.primary,
                        ),
                        weekendTextStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          color: AppColors.mutedForeground,
                        ),
                        // Disabled (unavailable) days
                        disabledTextStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          color: AppColors.border,
                          decoration: TextDecoration.lineThrough,
                        ),
                        outsideTextStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          color: AppColors.border,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 17 : 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        leftChevronIcon: const FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        rightChevronIcon: const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedForeground,
                        ),
                        weekendStyle: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── 2. SLOT SELECTOR ────────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.clock,
                    title: 'Available Slots',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 12),

                  if (!isDayAvailable)
                  // Unavailable day banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.circleExclamation,
                            size: 16,
                            color: Color(0xFFEA580C),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${guide.name} is not available on this day. Please select another date.',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: isTablet ? 14 : 13,
                                color: const Color(0xFF9A3412),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                  // Slot cards
                    Column(
                      children: slots.map((slot) {
                        final isSelected = _selectedSlot == slot;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSlot = slot;
                              _selectedStartTime =
                                  _parseTimeOfDay(slot.start);
                              _selectedHours = 1;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent.withAlpha(10)
                                  : AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.clock,
                                      size: 14,
                                      color: isSelected
                                          ? AppColors.accent
                                          : AppColors.mutedForeground,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      slot.formatted,
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: isTablet ? 15 : 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? AppColors.accent
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  const FaIcon(
                                    FontAwesomeIcons.circleCheck,
                                    size: 16,
                                    color: AppColors.accent,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),

                  // ── 3. START TIME (within selected slot) ────────
                  if (isDayAvailable && _selectedSlot != null) ...[
                    _SectionTitle(
                      icon: FontAwesomeIcons.hourglassStart,
                      title: 'Start Time',
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Within slot: ${_selectedSlot!.formatted}',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 13 : 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickStartTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 16,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedStartTime != null
                                      ? _formatTimeOfDay(
                                      _selectedStartTime!)
                                      : 'Select start time',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 16 : 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const FaIcon(
                              FontAwesomeIcons.chevronRight,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── 4. DURATION ─────────────────────────────────
                    _SectionTitle(
                      icon: FontAwesomeIcons.hourglassHalf,
                      title: 'Duration',
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              // Minus
                              GestureDetector(
                                onTap: () {
                                  if (_selectedHours > 1) {
                                    setState(() => _selectedHours--);
                                  }
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: _selectedHours > 1
                                        ? AppColors.secondary
                                        : AppColors.border,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.minus,
                                      size: 12,
                                      color: _selectedHours > 1
                                          ? AppColors.primary
                                          : AppColors.mutedForeground,
                                    ),
                                  ),
                                ),
                              ),

                              // Hours display
                              Text(
                                '$_selectedHours hr${_selectedHours > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),

                              // Plus
                              GestureDetector(
                                onTap: () {
                                  if (_selectedHours < _maxHours) {
                                    setState(() => _selectedHours++);
                                  }
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color:
                                    _selectedHours < _maxHours
                                        ? AppColors.accent
                                        : AppColors.border,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.plus,
                                      size: 12,
                                      color:
                                      _selectedHours < _maxHours
                                          ? AppColors
                                          .accentForeground
                                          : AppColors
                                          .mutedForeground,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // End time display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'End time',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 13 : 12,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                Text(
                                  _formatTimeOfDay(_endTime),
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 14 : 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Minimum 1 hour · Maximum $_maxHours hours within this slot',
                      style: const TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── 5. GROUP SIZE ────────────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.userGroup,
                    title: 'Number of People',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_groupSize > _minGroup) {
                                  setState(() => _groupSize--);
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _groupSize > _minGroup
                                      ? AppColors.secondary
                                      : AppColors.border,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.minus,
                                    size: 12,
                                    color: _groupSize > _minGroup
                                        ? AppColors.primary
                                        : AppColors.mutedForeground,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '$_groupSize',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 28 : 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _groupSize == 1
                                      ? 'person'
                                      : 'people',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 14 : 13,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_groupSize < _maxGroup) {
                                  setState(() => _groupSize++);
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _groupSize < _maxGroup
                                      ? AppColors.accent
                                      : AppColors.border,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: 12,
                                    color: _groupSize < _maxGroup
                                        ? AppColors.accentForeground
                                        : AppColors.mutedForeground,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_groupSize >= 3) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFFBBF7D0)),
                            ),
                            child: Row(
                              children: [
                                const Text('🎉',
                                    style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 8),
                                Text(
                                  'Group discount: ${_groupSize >= 5 ? "15%" : "10%"} off!',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: isTablet ? 13 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF15803D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── 6. MEETING POINT ────────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.locationDot,
                    title: 'Meeting Point',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where should the guide meet you?',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 13 : 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _meetingPointController,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 15 : 14,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Hotel lobby, Airport Terminal 1...',
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 14 : 13,
                        color: AppColors.mutedForeground,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14,vertical:14),
                        child: FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 16,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

// ── 7. SPECIAL REQUESTS ──────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.commentDots,
                    title: 'Special Requests',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Optional — any preferences or requirements?',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 13 : 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _specialRequestsController,
                    maxLines: 3,
                    maxLength: 300,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isTablet ? 15 : 14,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Vegetarian food only, wheelchair access needed...',
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 14 : 13,
                        color: AppColors.mutedForeground,
                      ),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── 8. PRICE SUMMARY ─────────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.dollarSign,
                    title: 'Price Summary',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                          label:
                          '\$${guide.hourlyRate.toInt()}/hr × $_selectedHours hrs × $_groupSize ${_groupSize == 1 ? "person" : "people"}',
                          value: '\$${_subtotal.toInt()}',
                          isTablet: isTablet,
                        ),
                        if (_groupDiscount > 0) ...[
                          const SizedBox(height: 8),
                          _PriceRow(
                            label:
                            'Group discount (${(_groupDiscount * 100).toInt()}% off)',
                            value:
                            '-\$${_discountAmount.toStringAsFixed(2)}',
                            isTablet: isTablet,
                            isDiscount: true,
                          ),
                        ],
                        const SizedBox(height: 8),
                        _PriceRow(
                          label: 'Service fee',
                          value: '\$${_serviceFee.toInt()}',
                          isTablet: isTablet,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: AppColors.border),
                        ),
                        _PriceRow(
                          label: 'Total',
                          value: '\$${_total.toStringAsFixed(2)}',
                          isTablet: isTablet,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── 9. PAYMENT METHOD ────────────────────────────
                  _SectionTitle(
                    icon: FontAwesomeIcons.creditCard,
                    title: 'Payment Method',
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 12),
                  PaymentCardSelector(
                    selectedCard: _selectedCard,
                    cards: _cards,
                    onCardSelected: (card) =>
                        setState(() => _selectedCard = card),
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.push('/payment-methods'),
                    child: Text(
                      'Manage payment methods →',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 14 : 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── 10. CANCELLATION POLICY ───────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border:
                      Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.shieldHalved,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cancellation Policy',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 14 : 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E3A5F),
                                ),
                              ),
                              const SizedBox(height: 6),
                              _PolicyItem(
                                text:
                                'Full refund if cancelled 48+ hours before tour',
                                isTablet: isTablet,
                              ),
                              _PolicyItem(
                                text:
                                '50% refund if cancelled 24-48 hours before',
                                isTablet: isTablet,
                              ),
                              _PolicyItem(
                                text:
                                'No refund within 24 hours of tour',
                                isTablet: isTablet,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Button
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 32 : 20,
          12,
          isTablet ? 32 : 20,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formattedDate,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: isTablet ? 14 : 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    if (_selectedStartTime != null)
                      Text(
                        '${_formatTimeOfDay(_selectedStartTime!)} → ${_formatTimeOfDay(_endTime)} · $_selectedHours hrs',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: isTablet ? 14 : 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                  ],
                ),
                Text(
                  'Total: \$${_total.toInt()}',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: isTablet ? 56 : 52,
              child: ElevatedButton(
                onPressed: (_selectedCard == null ||
                    _selectedSlot == null ||
                    _selectedStartTime == null ||
                    _meetingPointController.text.trim().isEmpty)
                    ? null
                    : () {
                  final bookingRef =
                      'LL-2026-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';

                  final booking = Booking(
                    guideId: guide.id,
                    guideName: guide.name,
                    guidePhoto: guide.photo,
                    guideSpecialty: guide.specialty,
                    date: _formattedDate,
                    startTime: _formatTimeOfDay(_selectedStartTime!),
                    endTime: _formatTimeOfDay(_endTime),
                    duration: _selectedHours,
                    groupSize: _groupSize,
                    meetingPoint: _meetingPointController.text.trim(),
                    specialRequests: _specialRequestsController.text.trim().isEmpty
                        ? null
                        : _specialRequestsController.text.trim(),
                    total: _total,
                    cardNumber: _selectedCard!.cardNumber,
                    bookingRef: bookingRef,
                  );

                  context.push(
                    '/booking-confirmation',
                    extra: booking,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.accentForeground,
                  disabledBackgroundColor: AppColors.border,
                  disabledForegroundColor: AppColors.mutedForeground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedCard == null
                      ? 'Select a payment method'
                      : _selectedSlot == null
                      ? 'Select an available slot'
                      : _meetingPointController.text.trim().isEmpty
                      ? 'Enter a meeting point'
                      : 'Confirm & Pay \$${_total.toInt()}',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Title Widget
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isTablet;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Price Row Widget
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTablet;
  final bool isTotal;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isTablet,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: isTablet ? 15 : 13,
              fontWeight:
              isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal
                  ? AppColors.primary
                  : AppColors.mutedForeground,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: isTotal
                ? (isTablet ? 22 : 20)
                : (isTablet ? 15 : 13),
            fontWeight:
            isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isDiscount
                ? const Color(0xFF16A34A)
                : isTotal
                ? AppColors.accent
                : AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Policy Item Widget
class _PolicyItem extends StatelessWidget {
  final String text;
  final bool isTablet;

  const _PolicyItem({required this.text, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              text,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: isTablet ? 13 : 12,
                color: const Color(0xFF1E3A5F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}