import 'package:flutter_test/flutter_test.dart';
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
    });

    test('_buildSubmitButton returns ElevatedButton with correct child and onPressed', () {
      final state = CreateReportPageState();

      final result = state._buildSubmitButton();

      expect(result, isA<ElevatedButton>());
      expect(result.child, isA<Text>());
      expect(result.child.data, equals('Submit Report'));
      expect(result.onPressed, equals(state._submitReport));
    });
  });
}
