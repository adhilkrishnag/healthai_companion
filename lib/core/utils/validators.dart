import '../constants/app_constants.dart';

/// Validation utilities for form fields
class Validators {
  Validators._();

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Required field validation
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  /// Weight validation
  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    if (weight < AppConstants.minWeight || weight > AppConstants.maxWeight) {
      return 'Weight must be between ${AppConstants.minWeight} and ${AppConstants.maxWeight} kg';
    }
    return null;
  }

  /// Steps validation
  static String? steps(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final steps = int.tryParse(value);
    if (steps == null) {
      return 'Please enter a valid number';
    }
    if (steps < AppConstants.minSteps || steps > AppConstants.maxSteps) {
      return 'Steps must be between ${AppConstants.minSteps} and ${AppConstants.maxSteps}';
    }
    return null;
  }

  /// Sleep hours validation
  static String? sleepHours(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final hours = double.tryParse(value);
    if (hours == null) {
      return 'Please enter a valid number';
    }
    if (hours < AppConstants.minSleepHours ||
        hours > AppConstants.maxSleepHours) {
      return 'Sleep hours must be between ${AppConstants.minSleepHours} and ${AppConstants.maxSleepHours}';
    }
    return null;
  }

  /// Water intake validation
  static String? waterIntake(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final liters = double.tryParse(value);
    if (liters == null) {
      return 'Please enter a valid number';
    }
    if (liters < AppConstants.minWaterIntake ||
        liters > AppConstants.maxWaterIntake) {
      return 'Water intake must be between ${AppConstants.minWaterIntake} and ${AppConstants.maxWaterIntake} L';
    }
    return null;
  }

  /// Mood score validation
  static String? moodScore(int? value) {
    if (value == null) {
      return 'Please select your mood';
    }
    if (value < AppConstants.minMoodScore ||
        value > AppConstants.maxMoodScore) {
      return 'Mood must be between ${AppConstants.minMoodScore} and ${AppConstants.maxMoodScore}';
    }
    return null;
  }

  /// AI query validation
  static String? aiQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your question';
    }
    if (value.length > AppConstants.maxQueryLength) {
      return 'Query is too long (max ${AppConstants.maxQueryLength} characters)';
    }
    return null;
  }

  /// Journal entry validation
  static String? journalEntry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Journal entry cannot be empty';
    }
    if (value.length > AppConstants.maxJournalLength) {
      return 'Entry is too long (max ${AppConstants.maxJournalLength} characters)';
    }
    return null;
  }

  /// Age validation
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }
    if (age < 1 || age > 150) {
      return 'Please enter a valid age';
    }
    return null;
  }

  /// Phone number validation (basic)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (!RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
