import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/accounts/routes.dart' as account_routes;
import 'screens/map/routes.dart' as map_routes;
import 'screens/reports/routes.dart' as reports_routes;

Future main() async {
  await dotenv.load(fileName: ".env"); // 加載.env文件
  runApp(const TrafficReportApp());
}

class TrafficReportApp extends StatelessWidget {
  const TrafficReportApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Report System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        ...map_routes.mapRoutes,
        ...account_routes.accountsRoutes,
        ...reports_routes.reportsRoutes,
      },
    );
  }
}