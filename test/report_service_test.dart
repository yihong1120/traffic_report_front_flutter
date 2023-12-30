import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:traffic_report_front_flutter/services/report_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

class MockClient extends Mock implements http.Client {}
class MockReportService extends Mock implements ReportService {}

void main() {
  group('createReport', () {
    final client = MockClient();
    final reportService = MockReportService();

    test('returns true when the http call completes successfully', () async {
      when(reportService.createReport(any, any)).thenAnswer((_) async => true);
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('OK', 200));

      expect(await reportService.createReport(TrafficViolation(), []), isTrue);
    });

    test('returns false when the http call completes with an error', () async {
      when(reportService.createReport(any, any)).thenAnswer((_) async => false);
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(await reportService.createReport(TrafficViolation(), []), isFalse);
    });

    test('returns false when an exception is thrown', () async {
      when(reportService.createReport(any, any)).thenThrow(Exception());

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
