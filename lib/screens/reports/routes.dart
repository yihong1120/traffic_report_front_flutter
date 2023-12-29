import 'package:flutter/material.dart';
import 'create_report_page.dart';
import 'report_details_page.dart';
import 'report_list_page.dart';
import 'report_edit_page.dart';

Map<String, WidgetBuilder> reportsRoutes = {
  '/reports': (context) => const ReportListPage(),
  '/reports/create': (context) => const CreateReportPage(),
  '/reports/details': (context) => const ReportDetailsPage(),
  '/reports/edit': (context) => const ReportEditPage(),
};
