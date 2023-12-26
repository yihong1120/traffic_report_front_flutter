import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/map/home_map.dart'; // 引入 home_map.dart

Future main() async {
  await dotenv.load(fileName: ".env"); // 加載.env文件
  runApp(const TrafficReportApp());
}

// void main() {
//   runApp(const TrafficReportApp());
// }

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
      home: const HomeMapScreen(), // 使用 HomeMapScreen 作為主頁面
    );
  }
}
