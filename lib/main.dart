// This file is the main entry point for the Traffic Report System app. It sets up the app's routes and theme, and defines the HomeScreen widget.
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/map/routes.dart' as map_routes;
import 'screens/reports/routes.dart' as reports_routes;
import 'screens/chat/routes.dart' as chat_routes;
import 'screens/accounts/routes.dart' as account_routes;
import 'components/navigation_drawer.dart';

/// This is the main function for the app. It loads the .env file and runs the TrafficReportApp widget.
/// It does not take any input parameters and does not return a value.
Future main() async {
  await dotenv.load(fileName: ".env"); // 加載.env文件
  runApp(const TrafficReportApp());
}

/// This is a StatelessWidget that sets up the MaterialApp with the app's routes and theme,
/// and defines the HomeScreen as the home screen.
class TrafficReportApp extends StatelessWidget {
  const TrafficReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Report System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      
      routes: {
        ...map_routes.mapRoutes,
        ...reports_routes.reportsRoutes,
        ...chat_routes.chatRoutes,
        ...account_routes.accountsRoutes,
      },
      home: const HomeScreen(), // 设置主屏幕
    );
  }
}

/// This is a StatelessWidget that defines the home screen of the app.
/// It includes an AppBar and a CustomNavigationDrawer.
// HomeScreen 类
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Report System'),
      ),
      drawer: const CustomNavigationDrawer(), // 使用新组件
      body: const Center(
        child: Text('Welcome to Traffic Report System'),
      ),
    );
  }
}