import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:traffic_report_front_flutter/services/map_service.dart';

void main() {
  testWidgets('loadMarkers returns the correct data', (WidgetTester tester) async {
    // Create a mock HTTP client
    final client = MockClient((request) async {
      // Mock the response for the HTTP request
      final response = http.Response(
        '[{"lat": 37.7749, "lng": -122.4194, "license_plate": "ABC123", "violation": "Speeding", "traffic_violation_id": 1}]',
        200,
      );
      return response;
    });

    // Create an instance of the MapService class with the mock client
    final mapService = MapService(client: client);

    // Call the loadMarkers method
    final markers = await mapService.loadMarkers();

    // Verify that the correct data is returned
    expect(markers.length, 1);
    expect(markers.first.position.latitude, 37.7749);
    expect(markers.first.position.longitude, -122.4194);
    expect(markers.first.infoWindow.title, 'ABC123-Speeding');
    expect(markers.first.markerId.value, '1');
  });
}
