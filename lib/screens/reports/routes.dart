import 'package:flutter/material.dart';
import 'report_list_screen.dart';
import 'create_report_screen.dart';
import 'edit_report_screen.dart';

Map<String, WidgetBuilder> reportsRoutes = {
  '/reports': (context) => const ReportListPage(),
  '/create': (context) => const CreateReportPage(),
  '/edit': (context) => const EditReportPage(recordId: -1,),
};