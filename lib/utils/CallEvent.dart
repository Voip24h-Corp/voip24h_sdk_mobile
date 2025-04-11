enum CallEvent {
  AccountRegistrationStateChanged,
  Ring,
  Up,
  Paused,
  Resuming,
  Missed,
  Hangup,
  Error;
  // Released

  static final Map<String, CallEvent> _map = {
    for (var event in CallEvent.values) event.name: event,
  };

  static CallEvent? fromString(String value) {
    return _map[value];
  }
}
