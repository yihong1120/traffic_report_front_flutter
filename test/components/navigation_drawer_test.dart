import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/components/navigation_drawer.dart'
    as custom;

// Create a mock navigator observer
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('NavigationDrawer', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Widget createTestableWidget({required Widget child}) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
        navigatorObservers: [mockObserver],
      );
    }

    testWidgets('tapping on a tile should navigate to the correct screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          createTestableWidget(child: const custom.NavigationDrawer()));

      // Define the list of tiles and corresponding expected routes
      final List<Map<String, dynamic>> tilesAndRoutes = [
        {'icon': Icons.home, 'route': '/home'},
        {'icon': Icons.report, 'route': '/create'},
        {'icon': Icons.edit, 'route': '/reports'},
        {'icon': Icons.chat, 'route': '/chat'},
        {'icon': Icons.account_circle, 'route': '/accounts'},
      ];

      for (var tileAndRoute in tilesAndRoutes) {
        // Find the ListTile widget by icon and tap it
        final Finder tileFinder =
            find.widgetWithIcon(ListTile, tileAndRoute['icon']);
        expect(tileFinder, findsOneWidget);
        await tester.tap(tileFinder);
        await tester.pumpAndSettle();

        // Verify that a push event happened on the mock navigator observer
        verify(mockObserver.didPush(
          argThat(isA<Route<dynamic>>())
              , // Cast to Route<dynamic>
          any, // Use any matcher for the second argument
        ));

        // Pop the current route to reset the navigation stack
        Navigator.of(tester.element(tileFinder)).pop();
        await tester.pumpAndSettle();
      }
    });
  });
}
