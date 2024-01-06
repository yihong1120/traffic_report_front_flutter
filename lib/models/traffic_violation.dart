import 'package:flutter/material.dart';
import 'media_file.dart';

class TrafficViolation {
  int? id; // 添加 id 属性
  String? title; // 添加 title 属性
  DateTime? date;
  TimeOfDay? time;
  String? licensePlate;
  String? violation;
  String? status;
  String? location;
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
    this.licensePlate,
    this.violation,
    this.status,
    this.location,
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
      'licensePlate': licensePlate,
      'violation': violation,
      'status': status,
      'location': location,
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
      licensePlate: json['licensePlate'] as String?,
      violation: json['violation'] as String?,
      status: json['status'] as String?,
      location: json['location'] as String?,
      officer: json['officer'] as String?,
      mediaFiles: json['mediaFiles'] != null
        ? (json['mediaFiles'] as List).map((e) => MediaFile.fromJson(e)).toList()
        : [],
    );
  }

  static TimeOfDay? _parseTime(String timeStr) {
    final parts = timeStr.split(':').map(int.parse).toList();
    return parts.length == 2 ? TimeOfDay(hour: parts[0], minute: parts[1]) : null;
  }
}