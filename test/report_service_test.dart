import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:traffic_report_front_flutter/services/report_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('createReport', () {
    final client = MockClient();
    final reportService = ReportService();

    test('returns true when the http call completes successfully', () async {
      when(client.send(any)).thenAnswer((_) async => http.Response('OK', 200));

      expect(await reportService.createReport(TrafficViolation(), []), isTrue);
    });

    test('returns false when the http call completes with an error', () async {
      when(client.send(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(await reportService.createReport(TrafficViolation(), []), isFalse);
    });

    test('returns false when an exception is thrown', () async {
      when(client.send(any)).thenThrow(Exception());

      expect(await reportService.createReport(TrafficViolation(), []), isFalse);
    });

    test('returns false when the media files list is empty', () async {
      when(client.send(any)).thenAnswer((_) async => http.Response('OK', 200));

      expect(await reportService.createReport(TrafficViolation(), []), isFalse);
    });

    test('returns false when the traffic violation object is null', () async {
      when(client.send(any)).thenAnswer((_) async => http.Response('OK', 200));

      expect(await reportService.createReport(null, ['file1', 'file2']), isFalse);
    });
  });
}
