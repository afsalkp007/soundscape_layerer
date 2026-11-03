import 'package:flutter_test/flutter_test.dart';
import 'package:soundscape_layerer/services/timer/sleep_timer_service.dart';

void main() {
  group('SleepTimerService Tests', () {
    late SleepTimerService service;

    setUp(() {
      service = SleepTimerService();
    });

    tearDown(() {
      service.dispose();
    });

    test('initial state has no active timer and 1.0 volume multiplier', () {
      expect(service.isActive, false);
      expect(service.totalDuration, Duration.zero);
      expect(service.remainingDuration, Duration.zero);
      expect(service.fadeMultiplier, 1.0);
    });

    test('startTimer activates timer and sets durations', () {
      service.startTimer(const Duration(minutes: 15));

      expect(service.isActive, true);
      expect(service.totalDuration, const Duration(minutes: 15));
      expect(service.remainingDuration, const Duration(minutes: 15));
      expect(service.formattedRemaining, '15:00');
    });

    test('cancelTimer resets state and restores multiplier', () {
      service.startTimer(const Duration(minutes: 30));
      expect(service.isActive, true);

      service.cancelTimer();
      expect(service.isActive, false);
      expect(service.remainingDuration, Duration.zero);
      expect(service.fadeMultiplier, 1.0);
    });

    test('formattedRemaining handles hours and minutes correctly', () {
      service.startTimer(const Duration(hours: 1, minutes: 25, seconds: 4));
      expect(service.formattedRemaining, '01:25:04');
    });
  });
}
