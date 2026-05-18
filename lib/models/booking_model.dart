enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  // Guide info
  final String guideId;
  final String guideName;
  final String guidePhoto;
  final String guideSpecialty;

  // Booking details
  final String date;
  final String startTime;
  final String endTime;
  final int duration;
  final int groupSize;

  // Traveller input
  final String meetingPoint;
  final String? specialRequests;

  // Payment
  final double total;
  final String cardNumber;
  final String bookingRef;

  // Status
  final BookingStatus status;

  // Traveller info (for guide view)
  final String? travelerName;
  final String? travelerPhoto;
  final String? travelerEmail;
  final String? travelerPhone;

  const Booking({
    required this.guideId,
    required this.guideName,
    required this.guidePhoto,
    required this.guideSpecialty,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.groupSize,
    required this.meetingPoint,
    this.specialRequests,
    required this.total,
    required this.cardNumber,
    required this.bookingRef,
    this.status = BookingStatus.upcoming,
    this.travelerName,
    this.travelerPhoto,
    this.travelerEmail,
    this.travelerPhone,
  });

  // Copy with for status updates
  Booking copyWith({
    BookingStatus? status,
    String? meetingPoint,
    String? specialRequests,
    String? travelerName,
    String? travelerPhoto,
    String? travelerEmail,
    String? travelerPhone,
  }) {
    return Booking(
      guideId: guideId,
      guideName: guideName,
      guidePhoto: guidePhoto,
      guideSpecialty: guideSpecialty,
      date: date,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      groupSize: groupSize,
      meetingPoint: meetingPoint ?? this.meetingPoint,
      specialRequests: specialRequests ?? this.specialRequests,
      total: total,
      cardNumber: cardNumber,
      bookingRef: bookingRef,
      status: status ?? this.status,
      travelerName: travelerName ?? this.travelerName,
      travelerPhoto: travelerPhoto ?? this.travelerPhoto,
      travelerEmail: travelerEmail ?? this.travelerEmail,
      travelerPhone: travelerPhone ?? this.travelerPhone,
    );
  }

  // Helper — check if booking can be completed
  // Only allowed if current datetime is past booking end time
  bool get canComplete {
    try {
      // Parse date e.g. 'March 30, 2026'
      const months = {
        'January': 1, 'February': 2, 'March': 3, 'April': 4,
        'May': 5, 'June': 6, 'July': 7, 'August': 8,
        'September': 9, 'October': 10, 'November': 11, 'December': 12,
      };
      final dateParts = date.split(' ');
      final month = months[dateParts[0]] ?? 1;
      final day = int.parse(dateParts[1].replaceAll(',', ''));
      final year = int.parse(dateParts[2]);

      // Parse end time e.g. '11:00 AM'
      final timeParts = endTime.split(' ');
      final hourMinute = timeParts[0].split(':');
      var hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final isPm = timeParts[1] == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      final bookingEndDateTime = DateTime(year, month, day, hour, minute);
      return DateTime.now().isAfter(bookingEndDateTime);
    } catch (_) {
      return false;
    }
  }

  // Helper — earnings after platform fee
  double get earnings => total * 0.9;

  // Helper — is upcoming
  bool get isUpcoming => status == BookingStatus.upcoming;

  // Helper — is completed
  bool get isCompleted => status == BookingStatus.completed;

  // Helper — is cancelled
  bool get isCancelled => status == BookingStatus.cancelled;
}