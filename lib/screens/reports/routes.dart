/// Defines the routes for the reports section of the application.
/// Each route is associated with a specific page of the application.
import 'package:flutter/material.dart';
import 'create_report_page.dart';
import 'report_details_page.dart';
import 'report_list_page.dart';
import 'report_edit_page.dart';

/// Map containing the routes for the reports section of the application.
/// Each route is associated with a specific page.
Map<String, WidgetBuilder> reportsRoutes = {
  '/reports': (context) => const ReportListPage(),
  '/reports/create': (context) => const CreateReportPage(),
  '/reports/details': (context) => const ReportDetailsPage(),
  /// Route to the ReportEditPage for editing an existing report.
  '/reports/edit': (context) => const ReportEditPage(),
};
