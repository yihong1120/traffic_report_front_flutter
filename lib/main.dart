import 'package:flutter/material.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:traffic_report_front_flutter/screens/map/home_map.dart';
import 'screens/map/routes.dart' as map_routes;
import 'screens/reports/routes.dart' as reports_routes;
import 'screens/chat/routes.dart' as chat_routes;
import 'screens/accounts/routes.dart' as account_routes;
import 'components/navigation_drawer.dart' as app_drawer;

Future main() async {
  await dotenv.load(fileName: ".env"); // 加载 .env 文件
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
      home: Scaffold(
        appBar: AppBar(title: const Text('Traffic Report System')),
        drawer: const AppDrawer.NavigationDrawer(), // 使用 NavigationDrawer
        body: const HomeMapPage(), // 设置 HomeMapPage 作为主体内容
      ),
    );
  }
}
