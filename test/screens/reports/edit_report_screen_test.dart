import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/edit_report_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/components/report_form.dart';
import 'package:traffic_report_front_flutter/components/media_preview.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  final mockReportForm = MockReportForm();
  final mockMediaPreview = MockMediaPreview();
  final mockAddMediaButton = MockAddMediaButton();
  final mockSaveChangesButton = MockSaveChangesButton();
  group('EditReportPageState', () {
    test('_buildMainContent returns Scaffold with correct children', () {
      final state = EditReportPageState();
      final context = MockBuildContext();

      final result = state._buildMainContent();

      expect(result, isA<Scaffold>());
      expect(find.byType(ReportForm), findsOneWidget);
      expect(find.byType(ReportForm), findsOneWidget);
      expect(find.byType(MediaPreview), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Add Media'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Save Changes'), findsOneWidget);
    });

    test('_buildReportForm returns ReportForm with correct initial data', () {
      final state = EditReportPageState();
      final result = state._buildReportForm();

      expect(result, isA<ReportForm>());
    });

    test('_buildAddMediaButton returns ElevatedButton for adding media', () {
      final state = EditReportPageState();
      final result = state._buildAddMediaButton();

      expect(result, isA<ElevatedButton>());
      expect((result.child as Text).data, equals('Add Media'));
    });

    test('_buildSaveChangesButton returns ElevatedButton for saving changes', () {
      final state = EditReportPageState();
      final result = state._buildSaveChangesButton();

      expect(result, isA<ElevatedButton>());
      expect((result.child as Text).data, equals('Save Changes'));
    });
  });
}
