import 'package:flutter/material.dart';

class DateTimeRangeUtil {
  static DateTimeRange? getTimeRangeFromDateRange(String timeRange) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime start = today;
    DateTime end = today;

    switch (timeRange) {
      case '今日':
        end = today
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;
      case '昨天':
        start = today.subtract(const Duration(days: 1));
        end = today.subtract(const Duration(seconds: 1));
        break;
      case '過去七天':
        start = today.subtract(const Duration(days: 7));
        end = today
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;
      case '過去一個月':
        start = today.subtract(const Duration(days: 30));
        end = today
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;
      case '過去半年':
        start = today.subtract(const Duration(days: 182));
        end = today
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;
      case '過去一年':
        start = today.subtract(const Duration(days: 365));
        end = today
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;
      case '自訂時間範圍':
        // Handle custom time range selection
        // This could open a dialog or another widget to let the user pick a custom range
        // You need to ensure that start and end are assigned values when the custom range is selected
        break;
      default:
        // If the time range is not recognized, you can return null or set a default range
        return null;
    }

    return DateTimeRange(start: start, end: end);
  }
}
