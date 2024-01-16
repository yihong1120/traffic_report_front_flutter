import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/models/media_file.dart';
import 'package:traffic_report_front_flutter/models/traffic_violation.dart';

void main() {
  group('TrafficViolation', () {
    // 測試數據
    final testDate = DateTime(2024, 1, 16);
    const testTime = TimeOfDay(hour: 14, minute: 30);
    final testMediaFiles = [
      MediaFile(id: '1', url: 'https://example.com/image1.jpg'),
      MediaFile(id: '2', url: 'https://example.com/image2.jpg'),
    ];

    // 測試 TrafficViolation.fromJson
    test('fromJson returns correct instance', () {
      final json = {
        'id': 1,
        'title': '違規停車',
        'date': '2024-01-16',
        'time': '14:30',
        'licensePlate': 'ABC-1234',
        'violation': '紅線停車',
        'status': 'Pending',
        'location': '某街道',
        'officer': '警員A',
        'mediaFiles': [
          {'id': 1, 'url': 'https://example.com/image1.jpg'},
          {'id': 2, 'url': 'https://example.com/image2.jpg'},
        ],
      };

      final violation = TrafficViolation.fromJson(json);

      expect(violation.id, 1);
      expect(violation.title, '違規停車');
      expect(violation.date, testDate);
      expect(violation.time, testTime);
      expect(violation.licensePlate, 'ABC-1234');
      expect(violation.violation, '紅線停車');
      expect(violation.status, 'Pending');
      expect(violation.location, '某街道');
      expect(violation.officer, '警員A');
      expect(violation.mediaFiles.length, 2);
      expect(violation.mediaFiles, isA<List<MediaFile>>());
    });

    // 測試 TrafficViolation.toJson
    test('toJson returns correct map', () {
      final violation = TrafficViolation(
        id: 1,
        title: '違規停車',
        date: testDate,
        time: testTime,
        licensePlate: 'ABC-1234',
        violation: '紅線停車',
        status: 'Pending',
        location: '某街道',
        officer: '警員A',
        mediaFiles: testMediaFiles,
      );

      final json = violation.toJson();

      expect(json['id'], 1);
      expect(json['title'], '違規停車');
      expect(json['date'], '2024-01-16');
      expect(json['time'], '14:30');
      expect(json['licensePlate'], 'ABC-1234');
      expect(json['violation'], '紅線停車');
      expect(json['status'], 'Pending');
      expect(json['location'], '某街道');
      expect(json['officer'], '警員A');
      expect(json['mediaFiles'], isA<List<Map<String, dynamic>>>());
      expect(json['mediaFiles'].length, 2);
    });

    // 測試靜態列表 violations
    test('violations list contains predefined violations', () {
      expect(TrafficViolation.violations, contains('紅線停車'));
      expect(TrafficViolation.violations, contains('黃線臨車'));
      // ... 其他違規項目的測試
    });

    // 測試靜態列表 statusOptions
    test('statusOptions list contains predefined statuses', () {
      expect(TrafficViolation.statusOptions, contains('Pending'));
      expect(TrafficViolation.statusOptions, contains('Approved'));
      expect(TrafficViolation.statusOptions, contains('Rejected'));
    });
  });
}
