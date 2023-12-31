import 'package:flutter/material.dart';

class TrafficViolation {
  DateTime? date;
  TimeOfDay? time;
  String? licensePlate;
  String? violation;
  String? status;
  String? location;
  String? officer;

  static const List<String> VIOLATIONS = [
    '紅線停車',
    '黃線臨車',
    '行駛人行道',
    '未停讓行人',
    '切換車道未打方向燈',
    '人行道停車',
    '騎樓停車',
    '闖紅燈',
    '逼車',
    '未禮讓直行車',
    '未依標線行駛',
    '其他',
  ];

  static const List<String> STATUS = [
    'Pending',
    'Approved',
    'Rejected',
  ];

  TrafficViolation({
    this.date,
    this.time,
    this.licensePlate,
    this.violation,
    this.status,
    this.location,
    this.officer,
  });

  // Convert a TrafficViolation into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null, // 简单的时间格式化
      'licensePlate': licensePlate,
      'violation': violation,
      'status': status,
      'location': location,
      'officer': officer,
    };
  }
}