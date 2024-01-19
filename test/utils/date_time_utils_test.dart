import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/utils/date_time_utils.dart';

void main() {
  testWidgets('formatTimeOfDay returns the correct formatted string', (WidgetTester tester) async {
    // Test case 1: TimeOfDay with hour = 9, minute = 30
    TimeOfDay time1 = TimeOfDay(hour: 9, minute: 30);
    String formattedTime1 = formatTimeOfDay(time1);
    expect(formattedTime1, '09:30');

    // Test case 2: TimeOfDay with hour = 12, minute = 0
    TimeOfDay time2 = TimeOfDay(hour: 12, minute: 0);
    String formattedTime2 = formatTimeOfDay(time2);
    expect(formattedTime2, '12:00');

    // Test case 3: TimeOfDay with hour = 23, minute = 45
    TimeOfDay time3 = TimeOfDay(hour: 23, minute: 45);
    String formattedTime3 = formatTimeOfDay(time3);
    expect(formattedTime3, '23:45');
  });
}
