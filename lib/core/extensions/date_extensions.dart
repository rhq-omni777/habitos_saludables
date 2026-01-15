extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final today = DateTime.now();
    return year == today.year &&
        month == today.month &&
        day == today.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Get day name
  String get dayName {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  /// Get formatted date as "DD/MM/YYYY"
  String get formattedDate {
    return '$day/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Get formatted time as "HH:MM"
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Get days difference
  int daysDifference(DateTime other) {
    return difference(other).inDays.abs();
  }
}
