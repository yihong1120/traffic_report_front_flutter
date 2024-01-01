import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:traffic_report_front_flutter/services/report_service.dart';
import 'package:image_picker/image_picker.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  ReportService service;
  MockClient client;
  TrafficViolation violation;
  List<XFile> mediaFiles;

  setUp(() {
    client = MockClient();
    service = ReportService(client);
    violation = TrafficViolation(id: 1, description: 'Test violation', location: 'Test location');
    mediaFiles = [XFile('test_path')];
  });

  test('updateReport returns true when the API call is successful', () async {
    when(client.send(any)).thenAnswer((_) async => http.StreamedResponse(http.ByteStream.fromBytes([200]), 200));
    expect(await service.updateReport(violation, mediaFiles), isTrue);
  });

  test('updateReport returns false when the API call fails', () async {
    when(client.send(any)).thenAnswer((_) async => http.StreamedResponse(http.ByteStream.fromBytes([400]), 400));
    expect(await service.updateReport(violation, mediaFiles), isFalse);
  });
}
