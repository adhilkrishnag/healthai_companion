import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// String extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Convert to initials (e.g., "John Doe" -> "JD")
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Format as "Today", "Yesterday", or date
  String get relativeDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (date.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE').format(this);
    }
    return DateFormat('MMM d, y').format(this);
  }

  /// Format time as "9:30 AM"
  String get formattedTime => DateFormat('h:mm a').format(this);

  /// Format date as "Jan 15"
  String get shortDate => DateFormat('MMM d').format(this);

  /// Format date as "January 15, 2024"
  String get longDate => DateFormat('MMMM d, y').format(this);

  /// Format as "Jan 15, 9:30 AM"
  String get dateTime => DateFormat('MMM d, h:mm a').format(this);

  /// Check if same day
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Get age in years
  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

/// Duration extensions
extension DurationExtensions on Duration {
  /// Format as "2h 30m"
  String get formatted {
    if (inHours > 0) {
      final minutes = inMinutes.remainder(60);
      return '${inHours}h ${minutes}m';
    }
    if (inMinutes > 0) {
      return '${inMinutes}m';
    }
    return '${inSeconds}s';
  }

  /// Format as "2 hours 30 minutes"
  String get formattedLong {
    if (inHours > 0) {
      final minutes = inMinutes.remainder(60);
      final hourLabel = inHours == 1 ? 'hour' : 'hours';
      final minLabel = minutes == 1 ? 'minute' : 'minutes';
      return '$inHours $hourLabel ${minutes > 0 ? '$minutes $minLabel' : ''}';
    }
    if (inMinutes > 0) {
      final label = inMinutes == 1 ? 'minute' : 'minutes';
      return '$inMinutes $label';
    }
    final label = inSeconds == 1 ? 'second' : 'seconds';
    return '$inSeconds $label';
  }
}

/// Number extensions
extension NumberExtensions on num {
  /// Format with thousands separator
  String get formatted => NumberFormat('#,###').format(this);

  /// Format as percentage
  String get percentage => '${(this * 100).toStringAsFixed(0)}%';

  /// Format as compact (e.g., 1.2K, 3.5M)
  String get compact => NumberFormat.compact().format(this);

  /// Format steps
  String get stepsFormatted {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}k';
    }
    return toStringAsFixed(0);
  }

  /// Format weight in kg
  String get weightFormatted => '${toStringAsFixed(1)} kg';

  /// Format water in liters
  String get waterFormatted => '${toStringAsFixed(1)} L';

  /// Format sleep hours
  String get sleepFormatted {
    final hours = floor();
    final minutes = ((this - hours) * 60).round();
    if (minutes > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${hours}h';
  }
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Safely get element at index
  T? safeElementAt(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Group by key
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    return fold<Map<K, List<T>>>({}, (map, element) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
      return map;
    });
  }
}

/// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if tablet
  bool get isTablet => screenWidth >= 600;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
