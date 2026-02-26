/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// App name
  static const String appName = 'Antripe Contacts';

  /// SharedPreferences keys
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String recentContactIdsKey = 'recent_contact_ids';
  static const String localContactsKey = 'local_contacts';

  /// Maximum number of recent contacts to store
  static const int maxRecentContacts = 20;

  /// Search debounce duration
  static const Duration searchDebounceDuration = Duration(milliseconds: 300);

  /// Animation durations
  static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
}
