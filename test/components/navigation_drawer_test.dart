import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/components/navigation_drawer.dart' as app_drawer;

// 创建Navigator的mock类
/// Mock class for NavigatorObserver

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('NavigationDrawer tests', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      // 在每个测试之前初始化mock对象
      mockObserver = MockNavigatorObserver();
    });

    /// Creates the widget under test
Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const app_drawer.NavigationDrawer(),
        navigatorObservers: [mockObserver],
        routes: {
          '/home': (_) => Container(), // 这里可以使用任何Widget
          '/create': (_) => Container(), // 这里可以使用任何Widget
        },
      );
    }

    testWidgets('should display all list tiles correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 检查所有ListTile是否存在
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Create Report'), findsOneWidget);
      expect(find.text('Edit Report'), findsOneWidget);
      expect(find.text('Chatbot'), findsOneWidget);
      expect(find.text('Accounts'), findsOneWidget);
    });

    testWidgets('should navigate to home when Home ListTile is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 模拟点击操作
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // 验证并获取第一个路由
      final capturedRoute = verify(mockObserver.didPush(captureAny, any)).captured.single as Route<dynamic>;
      expect(capturedRoute.settings.name, '/home');
    });

    testWidgets('should navigate to create report when Create Report ListTile is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 模拟点击操作
      await tester.tap(find.text('Create Report'));
      await tester.pumpAndSettle();

      // 验证并获取第一个路由
      final capturedRoute = verify(mockObserver.didPush(captureAny, any)).captured.single as Route<dynamic>;
      expect(capturedRoute.settings.name, '/create');
    });

    // 为'Edit Report', 'Chatbot', 和 'Accounts' ListTile项重复上述测试
    // ...

  });
}
