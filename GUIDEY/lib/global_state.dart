class GlobalState {
  static final GlobalState _instance = GlobalState._internal();
  String _track = '';

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();

  String get track => _track;
  set track(String value) {
    _track = value;
  }

  void clearTrack() {
    _track = '';
  }
}