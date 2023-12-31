import 'package:flutter/material.dart';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import 'edit_report_screen.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ReportService _reportService = ReportService();
  List<TrafficViolation> _reports = [];
  int _currentPage = 1;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  void _fetchReports({int page = 1}) async {
    setState(() {
      _isFetching = true;
    });
    List<TrafficViolation> reports = await _reportService.getReports(page: page);
    setState(() {
      _currentPage = page;
      _reports = reports;
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case List'),
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                if (index >= _reports.length - 1 && _reports.length % 25 == 0) {
                  // If we reached the end of the current page, fetch the next page
                  _fetchReports(page: _currentPage + 1);
                }

                TrafficViolation report = _reports[index];
                return ListTile(
                  title: Text(report.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReportScreen(recordId: report.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}