import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_report_front_flutter/screens/map/home_map.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  group('HomeMapPage', () {
    late HomeMapPage homeMapPage;
    late MockGoogleMapController mockMapController;

    setUp(() {
      mockMapController = MockGoogleMapController();
      homeMapPage = HomeMapPage();
    });

    testWidgets('Initial state', (tester) async {
      await tester.pumpWidget(MaterialApp(home: homeMapPage));

      expect(find.text('交通違規報告系統'), findsOneWidget);
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButton), findsOneWidget);
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('Search data', (tester) async {
      await tester.pumpWidget(MaterialApp(home: homeMapPage));

      // Simulate entering a search keyword
      await tester.enterText(find.byType(TextField), 'keyword');

      // Simulate tapping the search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Verify that the _searchData function is called
      expect(homeMapPage._searchKeyword, 'keyword');
      // Verify that the _markers set is updated
      expect(homeMapPage._markers.isNotEmpty, true);
    });

    testWidgets('Select date range', (tester) async {
      await tester.pumpWidget(MaterialApp(home: homeMapPage));

      // Simulate selecting a date range
      await tester.tap(find.byType(DropdownButton));
      await tester.pump();
      await tester.tap(find.text('自訂時間範圍').last);
      await tester.pump();

      // Verify that the _selectDateRange function is called
      expect(homeMapPage._selectedTimeRange, '自訂時間範圍');
      // Verify that the _selectedDateRange variable is updated
      expect(homeMapPage._selectedDateRange, isNotNull);
    });
  });
}
