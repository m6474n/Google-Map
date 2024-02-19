class StateManager {
  static final StateManager _state = StateManager._internal();

  bool state = false;

  factory StateManager() {
    return _state;
  }

  StateManager._internal();
}
