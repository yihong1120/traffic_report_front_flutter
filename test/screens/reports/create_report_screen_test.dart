    test('_pickMedia adds media files when picked', () {
      final state = CreateReportPageState();
      // We will use a mock method to simulate picking media files
      state.pickMedia = mockPickMediaMethod;
      state._pickMedia();

      expect(state._mediaFiles.isNotEmpty, isTrue);
    });

    test('_removeMedia removes correct media file', () {
      final state = CreateReportPageState();
      // Add a mock file to the state
      state._mediaFiles.add(mockMediaFile);
      state._removeMedia(mockMediaFile);

      expect(state._mediaFiles.contains(mockMediaFile), isFalse);
    });

    test('_submitReport shows SnackBar when no video present', () {
      final state = CreateReportPageState();
      // Ensure _mediaFiles is empty to represent no video condition
      state._mediaFiles.clear();
      // Spy on ScaffoldMessenger to capture SnackBar
      final messenger = spyOnScaffoldMessenger();

      state._submitReport();

      expect(messenger.snackBars, contains(matches('Please include at least one video file.')));
    });
  });
}import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/create_report_screen.dart';

void main() {
  group('CreateReportPageState', () {
    test('_buildReportForm returns ReportForm with correct properties', () {
      final state = CreateReportPageState();

      final result = state._buildReportForm();

      expect(result, isA<ReportForm>());
      expect(result.formKey, equals(state._formKey));
      expect(result.violation, equals(state._violation));
      expect(result.dateController, equals(state._dateController));
      expect(result.timeController, equals(state._timeController));
      expect(result.violations, equals(state._violations));
    });

    test('_buildSubmitButton returns ElevatedButton with correct child and onPressed', () {
      final state = CreateReportPageState();

      final result = state._buildSubmitButton();

      expect(result, isA<ElevatedButton>());
      expect(result.child, isA<Text>());
      expect((result.child as Text).data, equals('Submit Report'));
      expect(result.onPressed, equals(state._submitReport));
    });
  });
}
