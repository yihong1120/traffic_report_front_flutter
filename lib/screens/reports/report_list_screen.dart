import 'package:flutter/material.dart';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import 'edit_report_screen.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  ReportListPageState createState() => ReportListPageState();
}

class ReportListPageState extends State<ReportListPage> {
  final ReportService _reportService = ReportService();
  final List<TrafficViolation> _reports = [];
  int _currentPage = 1;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  // 加載報告的函數
  void _fetchReports({int page = 1}) async {
    // 獲取 ScaffoldMessenger 的參考
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() => _isFetching = true);

    try {
      List<TrafficViolation> reports = await _reportService.getReports(page: page);
      setState(() {
        _currentPage = page;
        _reports.addAll(reports);
        _isFetching = false;
      });
    } catch (e) {
      // 使用先前獲取的 ScaffoldMessenger 顯示錯誤信息
      if (mounted) { // 檢查當前 Widget 是否仍然掛載在樹上
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to fetch reports: $e')),
        );
      }
      setState(() => _isFetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case List'),
      ),
      body: _isFetching && _reports.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _reports.length + (_isFetching ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _reports.length) {
                  // 在列表底部顯示加載指示器
                  return const Center(child: CircularProgressIndicator());
                }

                if (index >= _reports.length - 1 && _reports.length % 25 == 0) {
                  // 加載下一頁
                  _fetchReports(page: _currentPage + 1);
                }

                final report = _reports[index];
                return ListTile(
                  title: Text(report.title ?? 'No Title'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReportPage(recordId: report.id ?? -1),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}