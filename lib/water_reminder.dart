class WaterReminder {
  int _glassCount = 0;

  void drink() {
    _glassCount++;
    print('You drank $_glassCount glass${_glassCount == 1 ? '' : 'es'} of water');
  }

  void reset() {
    _glassCount = 0;
    print('Water count reset to 0');
  }

  int get glassCount => _glassCount;
}