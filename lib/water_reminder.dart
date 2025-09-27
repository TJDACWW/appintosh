class WaterReminder {
  int _glassCount = 0;
  int _dailyTarget = 8;
  Duration _reminderInterval = const Duration(hours: 2);
  DateTime? _lastReminderTime;
  bool _testMode = false;
  
  static const Duration _testInterval = Duration(seconds: 5);

  int get glassCount => _glassCount;
  int get dailyTarget => _dailyTarget;
  Duration get reminderInterval => _testMode ? _testInterval : _reminderInterval;
  bool get isTargetReached => _glassCount >= _dailyTarget;
  bool get testMode => _testMode;

  void enableTestMode() {
    _testMode = true;
    print('Test mode enabled (reminder interval forced to ${_formatDuration(_testInterval)})');
  }

  void disableTestMode() {
    _testMode = false;
    print('Test mode disabled (using normal reminder interval of ${_formatDuration(_reminderInterval)})');
  }
  
  // Setters
  set dailyTarget(int value) {
    if (value <= 0) {
      throw ArgumentError('Daily target must be greater than 0');
    }
    _dailyTarget = value;
    print('Daily target set to $_dailyTarget glasses');
  }
  
  void setReminderInterval({int hours = 0, int minutes = 0, int seconds = 0}) {
    if (hours <= 0 && minutes <= 0 && seconds <= 0) {
      throw ArgumentError('Interval must be greater than 0');
    }
    _reminderInterval = Duration(hours: hours, minutes: minutes, seconds: seconds);
    print('Reminder interval set to ${_formatDuration(_reminderInterval)}${_testMode ? ' (Note: Test mode is enabled, using ${_formatDuration(_testInterval)} instead)' : ''}');
  }
  
  void drink() {
    _glassCount++;
    
    if (_glassCount == _dailyTarget) {
      print('Congratulations! You reached your daily target of $_dailyTarget glasses! 🎉');
    } else if (_glassCount > _dailyTarget) {
      print('You drank $_glassCount glasses of water (${_glassCount - _dailyTarget} over your target of $_dailyTarget) 💪');
    } else {
      print('You drank $_glassCount glass${_glassCount == 1 ? '' : 'es'} of water (Target: $_dailyTarget)');
    }
  }
  
  void reset() {
    _glassCount = 0;
    _lastReminderTime = null;
    print('Water count reset to 0');
  }
  
  bool checkReminder() {
    if (isTargetReached) {
      return false;
    }

    final now = DateTime.now();
    if (_lastReminderTime == null || now.difference(_lastReminderTime!) >= _reminderInterval) {
      print('Time to drink water! You\'ve had $_glassCount out of $_dailyTarget glasses today.');
      _lastReminderTime = now;
      return true;
    }
    return false;
  }
  
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final parts = <String>[];
    
    if (hours > 0) {
      parts.add('$hours hour${hours == 1 ? '' : 's'}');
    }
    if (minutes > 0) {
      parts.add('$minutes minute${minutes == 1 ? '' : 's'}');
    }
    if (seconds > 0) {
      parts.add('$seconds second${seconds == 1 ? '' : 's'}');
    }
    
    return parts.join(' and ');
  }
}