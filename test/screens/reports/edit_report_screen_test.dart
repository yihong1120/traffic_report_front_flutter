import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/edit_report_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('EditReportPageState', () {
    testWidgets('_buildMainContent returns expected widget', (WidgetTester tester) async {
      final EditReportPageState state = EditReportPageState();

      final mainContent = state._buildMainContent();

      expect(mainContent, isNotNull);
      expect(mainContent, isInstanceOf<Scaffold>());
    });

    testWidgets('Fields update TrafficViolation instance correctly', (WidgetTester tester) async {
      await tester.pumpWidget(Provider<EditReportPageState>(
        create: (_) => EditReportPageState(),
        child: MaterialApp(home: EditReportPage(recordId: 1)),
      ));

      await tester.enterText(find.byKey(Key('licensePlateField')), 'ABC123');
      await tester.enterText(find.byKey(Key('locationField')), 'Test Location');
      await tester.enterText(find.byKey(Key('officerField')), 'Officer Test');

      expect(find.text('ABC123'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('Officer Test'), findsOneWidget);
    });

    testWidgets('Validation logic works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(Provider<EditReportPageState>(
        create: (_) => EditReportPageState(),
        child: MaterialApp(home: EditReportPage(recordId: 1)),
      ));

      await tester.enterText(find.byKey(Key('licensePlateField')), '');
      await tester.enterText(find.byKey(Key('locationField')), '');

      expect(find.text('License plate cannot be empty'), findsOneWidget);
      expect(find.text('Location cannot be empty'), findsOneWidget);
    });

    testWidgets('Save Changes button works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(Provider<EditReportPageState>(
        create: (_) => EditReportPageState(),
        child: MaterialApp(home: EditReportPage(recordId: 1)),
      ));

      await tester.tap(find.byKey(Key('saveChangesButton')));

      expect(find.text('Report updated successfully'), findsOneWidget);
    });
  });
}
