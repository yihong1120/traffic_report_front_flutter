import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/components/time_range_dropdown.dart';

void main() {
  testWidgets('onTimeRangeChanged callback is called when selected value changes', (WidgetTester tester) async {
    String selectedValue = '';
    void handleTimeRangeChanged(String? value) {
      selectedValue = value ?? '';
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimeRangeDropdown(
            selectedTimeRange: selectedValue,
            timeRangeOptions: ['Option 1', 'Option 2', 'Option 3'],
            onTimeRangeChanged: handleTimeRangeChanged,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Option 2'));
    await tester.pumpAndSettle();

    expect(selectedValue, 'Option 2');
  });
}
