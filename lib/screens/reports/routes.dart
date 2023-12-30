import 'package:flutter/material.dart';
import 'create_report_page.dart';
import 'report_details_page.dart';
import 'report_list_page.dart';
import 'report_edit_page.dart';
import 'report_paged_list_page.dart';

Map<String, WidgetBuilder> reportsRoutes = {
  '/reports': (context) => const ReportListPage(),
  '/create': (context) => const CreateReportPage(),
  '/details': (context) => const ReportDetailsPage(),
  '/edit': (context) => const ReportEditPage(),
  '/paged': (context) => const ReportPagedListPage(),
};