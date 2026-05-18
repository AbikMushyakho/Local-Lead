import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_lead/core/constants/app_colors.dart';
import 'package:local_lead/core/constants/app_fonts.dart';

class TimeSlot {
  TimeOfDay start;
  TimeOfDay end;

  TimeSlot({required this.start, required this.end});
}

class DayAvailability {
  bool enabled;
  List<TimeSlot> slots;

  DayAvailability({required this.enabled, required this.slots});
}

class EditAvailabilityScreen extends StatefulWidget {
  const EditAvailabilityScreen({super.key});

  @override
  State<EditAvailabilityScreen> createState() =>
      _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  bool _hasChanges = false;

  final List<Map<String, dynamic>> _days = [
    {'key': 'monday', 'label': 'Monday'},
    {'key': 'tuesday', 'label': 'Tuesday'},
    {'key': 'wednesday', 'label': 'Wednesday'},
    {'key': 'thursday', 'label': 'Thursday'},
    {'key': 'friday', 'label': 'Friday'},
    {'key': 'saturday', 'label': 'Saturday'},
    {'key': 'sunday', 'label': 'Sunday'},
  ];

  late Map<String, DayAvailability> _availability;

  @override
  void initState() {
    super.initState();
    _availability = {
      'monday': DayAvailability(
        enabled: true,
        slots: [
          TimeSlot(
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 17, minute: 0))
        ],
      ),
      'tuesday': DayAvailability(
        enabled: true,
        slots: [
          TimeSlot(
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 17, minute: 0))
        ],
      ),
      'wednesday': DayAvailability(
        enabled: true,
        slots: [
          TimeSlot(
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 17, minute: 0))
        ],
      ),
      'thursday': DayAvailability(
        enabled: true,
        slots: [
          TimeSlot(
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 17, minute: 0))
        ],
      ),
      'friday': DayAvailability(
        enabled: true,
        slots: [
          TimeSlot(
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 17, minute: 0))
        ],
      ),
      'saturday': DayAvailability(
        enabled: true,
        slots: [
          TimeSlot(
              start: const TimeOfDay(hour: 10, minute: 0),
              end: const TimeOfDay(hour: 15, minute: 0))
        ],
      ),
      'sunday': DayAvailability(enabled: false, slots: []),
    };
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickTime(
      BuildContext context,
      String day,
      int slotIndex,
      bool isStart,
      ) async {
    final current = isStart
        ? _availability[day]!.slots[slotIndex].start
        : _availability[day]!.slots[slotIndex].end;

    final picked = await showTimePicker(
      context: context,
      initialTime: current,
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
      setState(() {
        if (isStart) {
          _availability[day]!.slots[slotIndex].start = picked;
        } else {
          _availability[day]!.slots[slotIndex].end = picked;
        }
        _hasChanges = true;
      });
    }
  }

  void _toggleDay(String day) {
    setState(() {
      _availability[day]!.enabled = !_availability[day]!.enabled;
      if (_availability[day]!.enabled &&
          _availability[day]!.slots.isEmpty) {
        _availability[day]!.slots.add(
          TimeSlot(
            start: const TimeOfDay(hour: 9, minute: 0),
            end: const TimeOfDay(hour: 17, minute: 0),
          ),
        );
      }
      _hasChanges = true;
    });
  }

  void _addSlot(String day) {
    setState(() {
      _availability[day]!.slots.add(
        TimeSlot(
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 17, minute: 0),
        ),
      );
      _hasChanges = true;
    });
  }

  void _removeSlot(String day, int index) {
    setState(() {
      _availability[day]!.slots.removeAt(index);
      _hasChanges = true;
    });
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Availability saved!')),
    );
    context.pop();
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          'Availability',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _hasChanges ? _save : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _hasChanges
                              ? AppColors.accent
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 15 : 14,
                            fontWeight: FontWeight.w600,
                            color: _hasChanges
                                ? AppColors.accentForeground
                                : AppColors.mutedForeground,
                          ),
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
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 32 : 20,
                24,
                isTablet ? 32 : 20,
                40,
              ),
              children: [
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
                        child: Text(
                          'Set your weekly availability. You can add multiple time slots for each day. Travelers will only be able to book during these times.',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: isTablet ? 14 : 13,
                            color: const Color(0xFF1E3A5F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Days
                ..._days.map((day) {
                  final key = day['key'] as String;
                  final label = day['label'] as String;
                  final dayData = _availability[key]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: dayData.enabled
                              ? AppColors.accent.withAlpha(80)
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Day toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: isTablet ? 16 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: dayData.enabled
                                      ? AppColors.primary
                                      : AppColors.mutedForeground,
                                ),
                              ),
                              Switch(
                                value: dayData.enabled,
                                onChanged: (_) => _toggleDay(key),
                                activeColor: AppColors.accent,
                              ),
                            ],
                          ),

                          // Time slots
                          if (dayData.enabled) ...[
                            const SizedBox(height: 12),
                            ...dayData.slots.asMap().entries.map((entry) {
                              final index = entry.key;
                              final slot = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.clock,
                                        size: 14,
                                        color: AppColors.accent,
                                      ),
                                      const SizedBox(width: 10),

                                      // Start time
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _pickTime(
                                              context, key, index, true),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.card,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppColors.border),
                                            ),
                                            child: Text(
                                              _formatTime(slot.start),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppFonts.family,
                                                fontSize: isTablet ? 15 : 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          'to',
                                          style: TextStyle(
                                            fontFamily: AppFonts.family,
                                            fontSize: isTablet ? 14 : 13,
                                            color: AppColors.mutedForeground,
                                          ),
                                        ),
                                      ),

                                      // End time
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _pickTime(
                                              context, key, index, false),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.card,
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppColors.border),
                                            ),
                                            child: Text(
                                              _formatTime(slot.end),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppFonts.family,
                                                fontSize: isTablet ? 15 : 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Remove slot button
                                      if (dayData.slots.length > 1) ...[
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () =>
                                              _removeSlot(key, index),
                                          child: const FaIcon(
                                            FontAwesomeIcons.xmark,
                                            size: 14,
                                            color: AppColors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }),

                            // Add time slot button
                            GestureDetector(
                              onTap: () => _addSlot(key),
                              child: Container(
                                width: double.infinity,
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.plus,
                                      size: 12,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Add Time Slot',
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: isTablet ? 14 : 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}