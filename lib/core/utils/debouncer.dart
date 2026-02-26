import 'dart:async';

/// Utility class to debounce function calls
///
/// Useful for search input to avoid excessive API calls.
class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  /// Call the action after the debounce duration
  ///
  /// If called again before the duration expires, the previous call is cancelled.
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancel any pending debounced action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer and cancel any pending action
  void dispose() {
    _timer?.cancel();
  }
}
