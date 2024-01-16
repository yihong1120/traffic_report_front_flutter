import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/components/report_form.dart';
import 'package:traffic_report_front_flutter/models/traffic_violation.dart';

void main() {
  group('ReportForm', () {
    late GlobalKey<FormState> formKey;
    late TrafficViolation violation;
    late TextEditingController dateController;
    late TextEditingController timeController;
    late List<String> violations;

    setUp(() {
      formKey = GlobalKey<FormState>();
      violation = TrafficViolation(
        date: DateTime.now(),
        time: TimeOfDay.now(),
        violation: 'Speeding',
        licensePlate: 'ABC123',
        location: 'Main Street',
        officer: 'Officer Doe',
        status: 'Reported',
      );
      dateController = TextEditingController();
      timeController = TextEditingController();
      violations = ['Speeding', 'Parking', 'Red Light'];
    });

    Widget createTestableWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('Form fields should update and validate correctly',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(createTestableWidget(ReportForm(
        formKey: formKey,
        violation: violation,
        dateController: dateController,
        timeController: timeController,
        violations: violations,
        onDateSaved: (DateTime? date) {},
        onTimeSaved: (TimeOfDay? time) {},
        onLicensePlateSaved: (String? licensePlate) {},
        onLocationSaved: (String? location) {},
        onOfficerSaved: (String? officer) {},
        onStatusChanged: (String? status) {},
      )));

      // Test the License Plate field
      await tester.enterText(find.byType(TextFormField).at(0), 'XYZ789');
      expect(find.text('XYZ789'), findsOneWidget);

      // Test the Date field
      await tester.tap(find.byType(TextFormField).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(dateController.text.isNotEmpty, true);

      // Test the Time field
      await tester.tap(find.byType(TextFormField).at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(timeController.text.isNotEmpty, true);

      // Test the Violation dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Parking').last);
      await tester.pumpAndSettle();
      expect(violation.violation, 'Parking');

      // Test the Status dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Resolved').last);
      await tester.pumpAndSettle();
      expect(violation.status, 'Resolved');

      // Test the Location field
      await tester.enterText(find.byType(TextFormField).at(3), 'New Street');
      expect(find.text('New Street'), findsOneWidget);

      // Test the Officer field
      await tester.enterText(find.byType(TextFormField).at(4), 'Officer Smith');
      expect(find.text('Officer Smith'), findsOneWidget);

      // Validate the form
      expect(formKey.currentState!.validate(), true);
    });
  });
}
