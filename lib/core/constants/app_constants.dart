/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// App name
  static const String appName = 'Antripe Contacts';

  /// Asset paths
  static const String appBrand = 'assets/images/png/app_brand.png';
  static const String appLogo = 'assets/images/png/app_logo.png';

  /// Loading indicator size
  static const double loaderSize = 60.0;
  static const double loaderBorderRadius = 15.0;

  /// SharedPreferences keys
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String recentContactIdsKey = 'recent_contact_ids';
  static const String localContactsKey = 'local_contacts';

  /// Maximum number of recent contacts to store
  static const int maxRecentContacts = 20;

  /// Search debounce duration
  static const Duration searchDebounceDuration = Duration(milliseconds: 300);

  /// Animation durations
  static const Duration largeAnimationDuration = Duration(milliseconds: 1200);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
}
