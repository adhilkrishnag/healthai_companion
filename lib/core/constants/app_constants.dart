/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'HealthAI Companion';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String userBoxName = 'user_box';
  static const String vitalsBoxName = 'vitals_box';
  static const String journalBoxName = 'journal_box';
  static const String insightsBoxName = 'insights_box';
  static const String remindersBoxName = 'reminders_box';
  static const String settingsBoxName = 'settings_box';
  static const String cacheBoxName = 'cache_box';
  
  // Encryption
  static const String encryptionKeyName = 'healthai_encryption_key';
  
  // Cache Duration
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const Duration aiResponseCacheDuration = Duration(hours: 12);
  
  // Pagination
  static const int defaultPageSize = 50;
  static const int searchResultsLimit = 20;
  
  // Performance
  static const Duration searchDebounceTime = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxJournalLength = 10000;
  static const int maxQueryLength = 500;
  
  // Health Metrics Ranges
  static const double minWeight = 20.0; // kg
  static const double maxWeight = 300.0; // kg
  static const int minSteps = 0;
  static const int maxSteps = 100000;
  static const double minSleepHours = 0.0;
  static const double maxSleepHours = 24.0;
  static const int minMoodScore = 1;
  static const int maxMoodScore = 10;
  static const double minWaterIntake = 0.0; // liters
  static const double maxWaterIntake = 10.0; // liters
}
