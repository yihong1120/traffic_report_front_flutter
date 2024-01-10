import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/screens/map/home_map.dart';

void main() {
  group('HomeMapPage', () {
    testWidgets('Initial state', (WidgetTester tester) async {
      // Test the initial state of the HomeMapPage widget
      await tester.pumpWidget(HomeMapPage());

      // Verify the initial state values
      expect(find.text('交通違規報告系統'), findsOneWidget);
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('Search data', (WidgetTester tester) async {
      // Test the search functionality of the HomeMapPage widget
      await tester.pumpWidget(HomeMapPage());

      // Enter a search keyword
      await tester.enterText(find.byType(TextField), 'keyword');

      // Tap the search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Verify that the search data function is called and the markers are updated
      expect(_searchKeyword, 'keyword');
      expect(_markers.length, greaterThan(0));
    });

    testWidgets('Select date range', (WidgetTester tester) async {
      // Test the date range selection functionality of the HomeMapPage widget
      await tester.pumpWidget(HomeMapPage());

      // Tap the dropdown button
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pump();

      // Select a date range option
      await tester.tap(find.text('自訂時間範圍').last);
      await tester.pump();

      // Verify that the date range is updated
      expect(_selectedTimeRange, '自訂時間範圍');
      expect(_selectedDateRange, isNotNull);
    });
  });
}
