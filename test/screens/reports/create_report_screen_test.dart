import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/create_report_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('CreateReportPageState', () {
    testWidgets('_buildReportForm returns expected widget', (WidgetTester tester) async {
      final CreateReportPageState state = CreateReportPageState();

      final form = state._buildReportForm();

      expect(form, isNotNull);
      expect(form, isInstanceOf<ReportForm>());
    });

    testWidgets('Fields update TrafficViolation instance correctly', (WidgetTester tester) async {
      await tester.pumpWidget(Provider<CreateReportPageState>(
        create: (_) => CreateReportPageState(),
        child: MaterialApp(home: CreateReportPage()),
      ));

      await tester.enterText(find.byKey(Key('licensePlateField')), 'ABC123');
      await tester.enterText(find.byKey(Key('locationField')), 'Test Location');

      expect(find.text('ABC123'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('Validation logic works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(Provider<CreateReportPageState>(
        create: (_) => CreateReportPageState(),
        child: MaterialApp(home: CreateReportPage()),
      ));

      await tester.enterText(find.byKey(Key('licensePlateField')), '');
      await tester.enterText(find.byKey(Key('locationField')), '');

      expect(find.text('License plate cannot be empty'), findsOneWidget);
      expect(find.text('Location cannot be empty'), findsOneWidget);
    });

    testWidgets('Submit Report button works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(Provider<CreateReportPageState>(
        create: (_) => CreateReportPageState(),
        child: MaterialApp(home: CreateReportPage()),
      ));

      await tester.tap(find.byKey(Key('submitReportButton')));

      expect(find.text('Report submitted successfully'), findsOneWidget);
    });
  });
}
