import 'package:local_lead/models/review_model.dart';
import 'package:local_lead/models/user_model.dart';

// Availability Slot
class AvailabilitySlot {
  final String start;
  final String end;

  const AvailabilitySlot({
    required this.start,
    required this.end,
  });

  String get formatted {
    return '${_formatTime(start)} – ${_formatTime(end)}';
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour =
        hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

// Guide extends User
class Guide extends User {
  final String specialty;
  final double rating;
  final int reviewCount;
  final int totalTours;
  final double hourlyRate;
  final String experience;
  final String distance;
  final List<String> languages;
  final List<String> certifications;
  final List<Review> reviews;
  final List<String> gallery;
  final List<String> tourPhotos;
  final Map<String, List<AvailabilitySlot>> weeklyAvailability;

  const Guide({
    // User fields
    required super.id,
    required super.name,
    required super.photo,
    required super.email,
    required super.phone,
    required super.location,
    required super.memberSince,
    super.bio,
    super.verified,

    // Guide specific
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.totalTours,
    required this.hourlyRate,
    required this.experience,
    required this.distance,
    required this.languages,
    this.certifications = const [],
    required this.reviews,
    this.gallery = const [],
    this.tourPhotos = const [],
    this.weeklyAvailability = const {},
  });

  // Get slots for a specific day
  List<AvailabilitySlot> getSlotsForDay(String day) {
    return weeklyAvailability[day.toLowerCase()] ?? [];
  }

  // Check if guide is available on a specific day
  bool isAvailableOnDay(String day) {
    final slots = weeklyAvailability[day.toLowerCase()];
    return slots != null && slots.isNotEmpty;
  }

  // Get all available days
  List<String> get availableDays {
    return weeklyAvailability.entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => e.key)
        .toList();
  }
}
