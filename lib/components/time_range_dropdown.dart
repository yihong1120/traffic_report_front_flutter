import 'package:flutter/material.dart';

class TimeRangeDropdown extends StatelessWidget {
  final String selectedTimeRange;
  final List<String> timeRangeOptions; // Add this line
  final ValueChanged<String?> onTimeRangeChanged;

  const TimeRangeDropdown({
    super.key,
    required this.selectedTimeRange,
    required this.timeRangeOptions, // Add this line
    required this.onTimeRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedTimeRange,
      onChanged: onTimeRangeChanged,
      items: timeRangeOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
