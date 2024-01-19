import 'package:flutter/material.dart';
import 'media_file.dart';
// import 'package:traffic_report_front_flutter/utils/date_time_utils.dart';

class TrafficViolation {
  int? id; // 添加 id 属性
  String? title; // 添加 title 属性
  DateTime? date;
  TimeOfDay? time;
  String? license_plate;
  String? violation;
  String? status;
  String? address;
  String? officer;
  List<MediaFile> mediaFiles;

  static const List<String> violations = [
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

  // 將靜態常量列表重命名為 statusOptions
  static const List<String> statusOptions = [
    'Pending',
    'Approved',
    'Rejected',
  ];

  TrafficViolation({
    this.id,
    this.title,
    this.date,
    this.time,
    this.license_plate,
    this.violation,
    this.status,
    this.address,
    this.officer,
    this.mediaFiles = const [],
  });

  // Convert a TrafficViolation into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'license_plate': license_plate,
      'violation': violation,
      'status': status,
      'address': address,
      'officer': officer,
    };
  }

  // Create a TrafficViolation from a JSON map.
  factory TrafficViolation.fromJson(Map<String, dynamic> json) {
    return TrafficViolation(
      id: json['id'] as int?,
      title: json['title'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null ? _parseTime(json['time']) : null,
      license_plate: json['license_plate'] as String?,
      violation: json['violation'] as String?,
      status: json['status'] as String?,
      address: json['address'] as String?,
      officer: json['officer'] as String?,
      mediaFiles: json['mediaFiles'] != null
        ? (json['mediaFiles'] as List).map((e) => MediaFile.fromJson(e)).toList()
        : [],
    );
  }

  static TimeOfDay? _parseTime(String timeStr) {
    final parts = timeStr.split(':').map(int.parse).toList();
    // 确保字符串被正确地分割成小时和分钟
    if (parts.length >= 2) {
      return TimeOfDay(hour: parts[0], minute: parts[1]);
    }
    return null;
  }
}