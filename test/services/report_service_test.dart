import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:test/fake.dart;
import 'package:logger/logger.dart';
import 'package:traffic_report_front_flutter/services/report_service.dart';
import 'package:traffic_report_front_flutter/models/traffic_violation.dart;

class MockMultipartRequest extends http.MultipartRequest {
  MockMultipartRequest(String method, Uri url) : super(method, url);
}

class MockMultipartFile extends http.MultipartFile {
  MockMultipartFile(String field, String filename, http.MediaType contentType, List<int> bytes)
      : super.fromBytes(field, bytes, filename: filename, contentType: contentType);
}

class MockResponse extends http.StreamedResponse {
  MockResponse(http.BaseRequest request, int statusCode) : super(request);
  
  @override
  int get statusCode => statusCode;
}

class MockLogger extends Logger {
  @override
  void d(dynamic message) {
    // Do nothing in the mock logger
  }
  
  test('Update Report Failure Test', () async {
    // Mock the necessary dependencies
    final mockRequest = MockMultipartRequest('PUT', Uri.parse('http://127.0.0.1:8000/reports/1/'));
    final mockResponse = MockResponse(mockRequest, 400);
    final mockLogger = MockLogger();
  
    // Mock the local media files
    final localMediaFiles = [
      XFile('path/to/file1.jpg'),
      XFile('path/to/file2.jpg'),
    ];
  
    // Mock the remote media files
    final remoteMediaFiles = ['http://example.com/file1.jpg', 'http://example.com/file2.jpg'];
  
    // Call the updateReport method
    final result = await reportService.updateReport(
      TrafficViolation(id: 1),
      localMediaFiles: localMediaFiles,
      remoteMediaFiles: remoteMediaFiles,
    );
  
    // Assert the expected behavior and outcomes
    expect(result, false);
    // Mock the local media files
  final localMediaFiles = [
    XFile('path/to/file1.jpg'),
    XFile('path/to/file2.jpg'),
  ];

  // Mock the remote media files
  final remoteMediaFiles = ['http://example.com/file1.jpg', 'http://example.com/file2.jpg'];

  // Call the updateReport method
  final result = await reportService.updateReport(
    TrafficViolation(id: 1),
    localMediaFiles: localMediaFiles,
    remoteMediaFiles: remoteMediaFiles,
  );

  // Assert the expected behavior and outcomes
  expect(result, false);
})
}

void main() {
  group('ReportService Tests', () {
    late ReportService reportService;

    setUp(() {
      reportService = ReportService();
    });

    test('Update Report Test', () async {
      // Mock the necessary dependencies
      final mockRequest = MockMultipartRequest('PUT', Uri.parse('http://127.0.0.1:8000/reports/1/'));
      final mockResponse = MockResponse(mockRequest, 200);
      final mockLogger = MockLogger();

      // Mock the local media files
      final localMediaFiles = [
        XFile('path/to/file1.jpg'),
        XFile('path/to/file2.jpg'),
      ];

      // Mock the remote media files
      final remoteMediaFiles = ['http://example.com/file1.jpg', 'http://example.com/file2.jpg'];

      // Call the updateReport method
      final result = await reportService.updateReport(
        TrafficViolation(id: 1),
        localMediaFiles: localMediaFiles,
        remoteMediaFiles: remoteMediaFiles,
      );

      // Assert the expected behavior and outcomes
      expect(result, true);
    });

    // Add more test cases to cover different scenarios and edge cases
    // ...

  });
}
  test('Update Report Failure Test', () async {
    // Mock the necessary dependencies
    final mockRequest = MockMultipartRequest('PUT', Uri.parse('http://127.0.0.1:8000/reports/1/'));
    final mockResponse = MockResponse(mockRequest, 400);
    final mockLogger = MockLogger();

    // Mock the local media files
    final localMediaFiles = [
      XFile('path/to/file1.jpg'),
      XFile('path/to/file2.jpg'),
    ];

    // Mock the remote media files
    final remoteMediaFiles = ['http://example.com/file1.jpg', 'http://example.com/file2.jpg'];

    // Call the updateReport method
    final result = await reportService.updateReport(
      TrafficViolation(id: 1),
      localMediaFiles: localMediaFiles,
      remoteMediaFiles: remoteMediaFiles,
    );

    // Assert the expected behavior and outcomes
    expect(result, false);
  })
