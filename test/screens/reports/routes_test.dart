import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/reports/routes.dart';

void main() {
  testWidgets('"/reports" should return ReportListPage', (WidgetTester tester) async {
    final widget = reportsRoutes['/reports']!(tester);
    expect(widget, isInstanceOf<ReportListPage>());
  });

  testWidgets('"/reports/create" should return CreateReportPage', (WidgetTester tester) async {
    final widget = reportsRoutes['/reports/create']!(tester);
    expect(widget, isInstanceOf<CreateReportPage>());
  });

  testWidgets('"/reports/details" should return ReportDetailsPage', (WidgetTester tester) async {
    final widget = reportsRoutes['/reports/details']!(tester);
    expect(widget, isInstanceOf<ReportDetailsPage>());
  });

  testWidgets('"/reports/edit" should return ReportEditPage', (WidgetTester tester) async {
    final widget = reportsRoutes['/reports/edit']!(tester);
    expect(widget, isInstanceOf<ReportEditPage>());
  });

  testWidgets('"/reports/paged" should return ReportPagedListPage', (WidgetTester tester) async {
    final widget = reportsRoutes['/reports/paged']!(tester);
    expect(widget, isInstanceOf<ReportPagedListPage>());
  });
}
