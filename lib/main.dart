import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/map/routes.dart' as map_routes;
import 'screens/reports/routes.dart' as reports_routes;
import 'screens/chat/routes.dart' as chat_routes;
import 'screens/accounts/routes.dart' as account_routes;
import 'screens/map/home_map.dart';
import 'components/navigation_drawer.dart';

Future main() async {
  await dotenv.load(fileName: ".env"); // 加載.env文件
  runApp(const TrafficReportApp());
}

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
      // 將 HomeMapPage 設為首頁
      home: const HomeMapPage(), 
    );
  }
}