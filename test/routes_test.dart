import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/routes.dart';

void main() {
  testWidgets('Navigates to /reports and correctly builds widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: reportsRoutes));
    await tester.tap(find.text('/reports'));
    await tester.pumpAndSettle();

    expect(find.byType(ReportListPage), findsOneWidget);
  });

  testWidgets('Navigates to /reports/create and correctly builds widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: reportsRoutes));
    await tester.tap(find.text('/reports/create'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateReportPage), findsOneWidget);
  });

  testWidgets('Navigates to /reports/details and correctly builds widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: reportsRoutes));
    await tester.tap(find.text('/reports/details'));
    await tester.pumpAndSettle();

    expect(find.byType(ReportDetailsPage), findsOneWidget);
  });

  testWidgets('Navigates to /reports/edit and correctly builds widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: reportsRoutes));
    await tester.tap(find.text('/reports/edit'));
    await tester.pumpAndSettle();

    expect(find.byType(ReportEditPage), findsOneWidget);
  });

  testWidgets('Navigates to non-existent route and shows error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: reportsRoutes));
    await tester.tap(find.text('/non-existent'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error), findsOneWidget);
  });
}
