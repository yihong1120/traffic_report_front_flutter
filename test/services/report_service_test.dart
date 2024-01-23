import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:traffic_report_front_flutter/services/report_service.dart';
import 'package:traffic_report_front_flutter/models/traffic_violation.dart';
import 'package:flutter/material.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ReportService', () {
    late ReportService service;
    late MockClient client;

    setUp(() {
      client = MockClient();
      service = ReportService(client: client);
    });

    test(
      'createReport should return true when the http call completes successfully',
      () async {
        when(client.send(isA<http.BaseRequest>() as http.BaseRequest))
            .thenAnswer((_) async =>
                http.StreamedResponse(Stream.value(utf8.encode('')), 200));

        final violation = TrafficViolation(
          id: 1,
          title: 'Parking Violation',
          date: DateTime.parse('2024-01-15'),
          time: const TimeOfDay(hour: 14, minute: 0),
          license_plate: 'ABC123',
          violation: '紅線停車',
          status: 'Pending',
          address: 'Main St and 1st Ave',
          officer: 'Officer123',
          mediaFiles: [], // Assuming no media files for simplicity
        );
        final mediaFiles = [XFile('path/to/file')]; // Mocked file paths

        expect(await service.createReport(violation, mediaFiles), isTrue);
      },
    );

    test(
      'getReports should return a list of TrafficViolation when the http call completes successfully',
      () async {
        when(client.get(any)).thenAnswer((_) async => http.Response(
            jsonEncode([
              {
                'id': 1,
                'title': 'Parking Violation',
                'date': '2024-01-15',
                'time': '14:00',
                'license_plate': 'ABC123',
                'violation': '紅線停車',
                'status': 'Pending',
                'address': 'Main St and 1st Ave',
                'officer': 'Officer123',
                'mediaFiles': [],
              },
              // Add more violation reports if needed
            ]),
            200));

        final reports = await service.getReports();
        expect(reports, isNotEmpty);
        expect(reports.first, isA<TrafficViolation>());
      },
    );

    test(
      'getViolation should return a TrafficViolation when the http call completes successfully',
      () async {
        const int recordId = 1;
        when(client.get(any)).thenAnswer((_) async => http.Response(
            jsonEncode({
              'id': recordId,
              'title': 'Parking Violation',
              'date': '2024-01-15',
              'time': '14:00',
              'license_plate': 'ABC123',
              'violation': '紅線停車',
              'status': 'Pending',
              'address': 'Main St and 1st Ave',
              'officer': 'Officer123',
              'mediaFiles': [],
            }),
            200));

        final violation = await service.getViolation(recordId);
        expect(violation, isA<TrafficViolation>());
        expect(violation.id, recordId);
      },
    );

    test(
      'updateReport should return true when the http call completes successfully',
      () async {
        when(client.send(isA<http.BaseRequest>() as http.BaseRequest))
            .thenAnswer((_) async =>
                http.StreamedResponse(Stream.value(utf8.encode('')), 200));

        final violation = TrafficViolation(
          id: 1,
          title: 'Updated Parking Violation',
          date: DateTime.parse('2024-01-15'),
          time: const TimeOfDay(hour: 14, minute: 0),
          license_plate: 'ABC123',
          violation: '紅線停車',
          status: 'Approved',
          address: 'Main St and 1st Ave',
          officer: 'Officer123',
          mediaFiles: [], // Assuming no media files for simplicity
        );
        final localMediaFiles = [XFile('path/to/file')]; // Mocked file paths
        final remoteMediaFiles = ['http://example.com/file'];

        expect(
            await service.updateReport(violation,
                localMediaFiles: localMediaFiles,
                remoteMediaFiles: remoteMediaFiles),
            isTrue);
      },
    );

    // Add more tests for error cases and other scenarios...
  });
}
