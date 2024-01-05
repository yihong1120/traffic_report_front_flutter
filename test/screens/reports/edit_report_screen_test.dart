import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/edit_report_screen.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('EditReportPageState', () {
    test('_buildMainContent returns Scaffold with correct children', () {
      final state = EditReportPageState();
      final context = MockBuildContext();

      final result = state._buildMainContent();

      expect(result, isA<Scaffold>());
      expect(find.byType(ReportForm), findsOneWidget);
      expect(find.byType(MediaPreview), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });
  });
}
